//
//  NYGApp.swift
//  NYG
//
//  Created by Komran Ghahremani on 12/28/20.
//

import SwiftUI
import Firebase

@main
struct NYGApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
