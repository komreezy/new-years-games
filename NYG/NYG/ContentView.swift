//
//  ContentView.swift
//  NYG
//
//  Created by Komran Ghahremani on 12/28/20.
//

import SwiftUI
import FirebaseDatabase

struct ContentView: View {
    @State var isShowingOnboarding = true
    @State var players: [Player] = []
    
    var body: some View {
        TabView {
            NavigationView {
                List(players, id: \.id) { player in
                    HStack {
                        Image(systemName: player.icon)
                        VStack(alignment: .leading) {
                            Text(player.name)
                                .font(.title3)
                            Text(player.caption)
                                .font(.subheadline)
                                .lineLimit(1)
                        }
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
            
            EventView(players: $players)
        }
        .accentColor(.red)
        .sheet(isPresented: $isShowingOnboarding) {
            OnboardingView(isPresentingSelf: $isShowingOnboarding)
        }
        .onAppear {
            let usersRef = Database.database().reference().child("users")
            usersRef.observe(DataEventType.value, with: { (snapshot) in
                if let users = snapshot.value as? [String: [String: AnyObject]] {
                    createPlayerArray(users)
                } else {
                    print("No go")
                }
            })
        }
    }
    
    private func createPlayerArray(_ json: [String: [String: AnyObject]]) {
        players = json.compactMap { id, user in
            if let name = user["name"] as? String,
               let icon = user["icon"] as? String,
               let caption = user["caption"] as? String,
               let points = user["points"] as? Int {
                return Player(id: id, name: name, caption: caption, icon: icon, points: points)
            } else {
                return nil
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
