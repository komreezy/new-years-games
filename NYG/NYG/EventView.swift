//
//  EventView.swift
//  NYG
//
//  Created by Komran Ghahremani on 12/28/20.
//

import SwiftUI
import FirebaseDatabase

struct EventView: View {
    @State private var isShowingResults = false
    @State var events: [Event] = []
    @Binding var players: [Player]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List(events, id: \.id) { event in
                    Section {
                        // this is for history
                        // grab players from firebase
                        NavigationLink(destination: EventResultsView(isAdjustable: false, name: event.name, players: .constant([]), ranking: event.rankings, showingModal: $isShowingResults)) {
                            Text(event.name)
                                .padding(.vertical)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                Button(action: { isShowingResults = true }, label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding(.trailing, 40)
                        .padding(.bottom, 40)
                        .accentColor(.red)
                })
            }
            .navigationTitle(Text("2020"))
            .sheet(isPresented: $isShowingResults) {
                NavigationView {
                    // this is for creation
                    EventResultsView(isAdjustable: true, players: $players, ranking: [], showingModal: $isShowingResults)
                }
            }
            .onAppear {
                let eventsRef = Database.database().reference().child("events")
                eventsRef.observe(DataEventType.value, with: { (snapshot) in
                    if let events = snapshot.value as? [String: [String: AnyObject]] {
                        createEventsArray(events)
                    } else {
                        print("No go")
                    }
                })
            }
        }
        .tabItem {
            Image(systemName: "gamecontroller.fill")
            Text("Events")
        }
    }
    
    private func createEventsArray(_ json: [String: [String: AnyObject]]) {
        events = json.compactMap { id, event in
            if let name = event["name"] as? String,
               let rankings = event["rankings"] as? [[String: AnyObject]] {
                let rankings = createRankingsArray(rankings)
                return Event(id: id, name: name, rankings: rankings)
            } else {
                return nil
            }
        }
    }
    
    private func createRankingsArray(_ json: [[String: AnyObject]]) -> [Event.Ranking] {
        json.compactMap { ranking in
            if let id = ranking["id"] as? String,
               let name = ranking["name"] as? String,
               let caption = ranking["caption"] as? String,
               let points = ranking["points"] as? Int {
                return Event.Ranking(id: id,
                                     player: Player(id: id, name: name, caption: caption, icon: "icon", points: points),
                                     points: points)
            } else {
                return nil
            }
        }
    }
}
