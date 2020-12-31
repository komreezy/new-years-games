//
//  EventResultsView.swift
//  NYG
//
//  Created by Komran Ghahremani on 12/28/20.
//

import SwiftUI

struct EventResultsView: View {
    @State var isEditing: EditMode = .inactive
    
    var body: some View {
        List {
            ForEach(players, id: \.id) { player in
                EventResultsRow(player: player)
            }
            .onMove(perform: move)
        }
        .environment(\.editMode, $isEditing)
        .navigationBarTitle("Event Results")
        .navigationBarItems(trailing: Button(action: {
            self.isEditing = isEditing == .active ? .inactive : .active
        }, label: {
            HStack {
                Image(systemName: "pencil.circle")
                    .accentColor(.red)
                Text("Adjust")
            }
        }))
    }
    
    func move(from source: IndexSet, to destination: Int) {
        players.move(fromOffsets: source, toOffset: destination)
    }
}

struct EventResultsView_Previews: PreviewProvider {
    static var previews: some View {
        EventResultsView()
    }
}

struct EventResultsRow: View {
    @State var points = NumbersOnly()
    var player: Player = Player(name: "Komran")
    
    var body: some View {
        HStack() {
            Text(player.name)
            TextField("Points", text: $points.value)
                .multilineTextAlignment(.trailing)
                .keyboardType(.numberPad)
        }
    }
}

final class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}
