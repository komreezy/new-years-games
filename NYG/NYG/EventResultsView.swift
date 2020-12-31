//
//  EventResultsView.swift
//  NYG
//
//  Created by Komran Ghahremani on 12/28/20.
//

import SwiftUI
import FirebaseDatabase

struct EventResultsView: View {
    var isAdjustable: Bool
    
    @State var isEditing: EditMode = .inactive
    @State var name: String = ""
    @Binding var players: [Player]
    var ranking: [Event.Ranking]
    @Binding var showingModal: Bool
    
    var body: some View {
        if isAdjustable {
            adjustableContent
        } else {
            nonAdjustableContent
        }
    }
    
    private var adjustableContent: some View {
        VStack {
            TextField("Event Name", text: $name)
                .padding()
                .padding(.leading, 4)
                .font(.title)
            
            List {
                ForEach(Array(players.enumerated()), id: \.offset) { index, player in
                    EventResultsRow(index: index, totalPlayers: players.count, player: player, isAdjustable: isAdjustable)
                }
                .onMove(perform: move)
            }
        }
        .environment(\.editMode, $isEditing)
        .navigationBarTitle("Event Results")
        .navigationBarItems(leading:
            Button(action: {
                self.isEditing = isEditing == .active ? .inactive : .active
            }, label: {
                HStack {
                    Image(systemName: "pencil.circle")
                        .accentColor(.red)
                    Text("Adjust")
                        .accentColor(.red)
                }
            }),
                            trailing:
            Button(action: {
                createEvent()
                self.showingModal = false
            }) {
                Text("Done")
                    .accentColor(.red)
            }
        )
    }
    
    private var nonAdjustableContent: some View {
        VStack {
            HStack {
                Text(name)
                    .padding()
                    .padding(.leading, 4)
                    .font(.title)
                Spacer()
            }
            
            List {
                ForEach(ranking, id: \.id) { ranking in
                    EventResultsRow(index: 0,
                                    totalPlayers: players.count,
                                    historyPoints: ranking.points,
                                    player: ranking.player,
                                    isAdjustable: isAdjustable)
                }
                .onMove(perform: move)
            }
        }
        .environment(\.editMode, $isEditing)
        .navigationBarTitle("Event Results")
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        players.move(fromOffsets: source, toOffset: destination)
    }
    
    private func createEvent() {
        // map old point values
        var pointsDictionary: [String: Int] = [:]
        players.forEach { player in
            pointsDictionary[player.id] = player.points
        }
        
        // calculate points from event
        let playersWithPoints = Array(players.enumerated()).map { index, player in
            Player(id: player.id, name: player.name, caption: player.caption, icon: player.icon, points: players.count - index)
        }
        
        // convert to JSON and upload event
        let playerJSON = playersWithPoints.map({ $0.toJSON() })
        let eventRef = Database.database().reference().child("events").childByAutoId()
        eventRef.setValue(
            [
                "name": name,
                "rankings": playerJSON,
            ]
        )
        
        // update the users total points in live standings
        let userRef = Database.database().reference().child("users")
        playersWithPoints.forEach { player in
            let id = player.id
            if let oldPoints = pointsDictionary[id] {
                let newPoints = oldPoints + player.points
                userRef.child(id).updateChildValues(["points": newPoints])
            }
        }
    }
}

struct EventResultsRow: View {
    @State var points = NumbersOnly()
    var index: Int
    var totalPlayers: Int
    var historyPoints: Int = 0
    var player: Player
    var isAdjustable: Bool
    
    var body: some View {
        HStack() {
            Text(player.name)
            
            Spacer()
            
            if isAdjustable {
                Text("\(totalPlayers - index)")
            } else {
                Text("\(historyPoints)")
            }
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
