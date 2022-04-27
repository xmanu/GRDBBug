//
//  ContentViewModel.swift
//  GRDBBug
//
//  Created by Manuel Weiel INVERS GmbH on 27.04.22.
//

import Foundation
import Combine
import GRDB

class ContentViewModel: ObservableObject {
    let databaseClient = DatabaseClient.shared
    
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        for _ in 1...100 {
            getNewObserver().sink { print("Received players count: \($0.count)") }.store(in: &cancellables)
        }
    }
    
    func getNewObserver() -> AnyPublisher<[Player], Never> {
        let observation = ValueObservation.tracking { db in
            try Player.fetchAll(db)
        }
        
        return observation.publisher(in: databaseClient.databaseWriter).removeDuplicates().replaceError(with: []).eraseToAnyPublisher()
    }
    
    @MainActor
    func insertPlayer() async {
        do {
            try await databaseClient.databaseWriter.write { db in
                var player = Player(name: "Some player")
                try player.insert(db)
            }
        } catch {
            print(error)
        }
    }
}
