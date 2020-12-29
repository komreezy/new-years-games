//
//  ContentView.swift
//  NYG
//
//  Created by Komran Ghahremani on 12/28/20.
//

import SwiftUI

var players: [Player] = [
    Player(name: "Komran"),
    Player(name: "Kayvon"),
    Player(name: "Yasamin"),
    Player(name: "Navid"),
    Player(name: "Shawyon"),
    Player(name: "Sherwin"),
    Player(name: "Armon"),
    Player(name: "Paige")
]

var events: [Event] = [
    Event(name: "Ping Pong"),
    Event(name: "Ping Pong"),
    Event(name: "Ping Pong"),
    Event(name: "Ping Pong"),
    Event(name: "Ping Pong"),
]

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                List(players, id: \.id) { player in
                    HStack {
                        Image(systemName: "bolt.fill")
                        Text(player.name)
                        Spacer()
                        Text("\(player.points)")
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical)
                }
                .navigationTitle(Text("Live Standings"))
            }
            .tabItem {
                Image(systemName: "rosette")
                Text("Home")
            }
            
            EventView()
        }
        .accentColor(.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
