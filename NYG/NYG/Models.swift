//
//  Models.swift
//  NYG
//
//  Created by Komran Ghahremani on 12/28/20.
//

import SwiftUI

struct Player: Identifiable {
    var id: UUID = UUID()
    var name: String
    var icon: Image = Image(systemName: "gamecontroller.fill")
    var points: Int = Int.random(in: 1..<100)
}

struct Event: Identifiable {
    var id: UUID = UUID()
    var name: String
    var rankings: [Ranking] = [
        Ranking(player: Player(name: "Komran"), points: 12),
        Ranking(player: Player(name: "Kayvon"), points: 12),
        Ranking(player: Player(name: "Yasamin"), points: 12),
        Ranking(player: Player(name: "Navid"), points: 2),
        Ranking(player: Player(name: "Shawyon"), points: 12),
        Ranking(player: Player(name: "Sherwin"), points: 4),
        Ranking(player: Player(name: "Armon"), points: 12),
        Ranking(player: Player(name: "Paige"), points: 3)
    ]
    
    struct Ranking: Identifiable {
        var id: UUID = UUID()
        var player: Player
        var points: Int
    }
}
