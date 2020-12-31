//
//  UserDefault.swift
//  NYG
//
//  Created by Komran Ghahremani on 12/31/20.
//

import Foundation
import Combine

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

final class UserSettings: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()

    @UserDefault("icon", defaultValue: "")
    var icon: String {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault("name", defaultValue: "")
    var name: String {
        willSet {
            objectWillChange.send()
        }
    }
}
