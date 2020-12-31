//
//  EventView.swift
//  NYG
//
//  Created by Komran Ghahremani on 12/28/20.
//

import SwiftUI

struct EventView: View {
    @State private var isShowingResults = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List(events, id: \.id) { event in
                    Section {
                        NavigationLink(destination: EventResultsView()) {
                            Text("Ping Pong")
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
                    EventResultsView()
                }
            }
        }
        .tabItem {
            Image(systemName: "gamecontroller.fill")
            Text("Events")
        }
    }
}

struct EventView_Previews: PreviewProvider {
    static var previews: some View {
        EventView()
    }
}
