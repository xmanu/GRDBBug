//
//  Player.swift
//  GRDBBug
//
//  Created by Manuel Weiel INVERS GmbH on 27.04.22.
//

import Foundation
import GRDB

struct Player: FetchableRecord, MutablePersistableRecord, Codable, Equatable {
    var id: Int64?
    let name: String
    
    mutating func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
}

extension Player {
    enum Columns {
        static var id = Column(CodingKeys.id)
        static var name = Column(CodingKeys.name)
    }
}
