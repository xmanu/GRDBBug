import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()

    var body: some View {
            List {
                Text("Pressing the Add player button will insert a single player into the DB. The viewModel will create **100 value observations** that _should_ print the count of players in the database 100 times to the console. But instead the app crashes with a stack overflow.")
                    .font(.caption)
                    .fixedSize(horizontal: false, vertical: true)
                Button {
                    Task {
                        await viewModel.insertPlayer()
                    }
                } label: {
                    Text("Add player")
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
