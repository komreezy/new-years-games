//
//  OnboardingView.swift
//  NYG
//
//  Created by Komran Ghahremani on 12/28/20.
//

import SwiftUI
import FirebaseDatabase

struct OnboardingView: View {
    @State var name: String = ""
    @State var caption: String = ""
    @State var icon: String = ""
    @State var isPresentingIcons = false
    @Binding var isPresentingSelf: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Text("Onboarding")
                    .font(.title)
                    .padding()
                
                Button(action: { isPresentingIcons.toggle() }) {
                    if icon != "" {
                        Image(systemName: icon)
                            .resizable()
                            .frame(width: 30, height: 30, alignment: .center)
                    } else {
                        Text("Choose Your Icon")
                            .accentColor(.red)
                    }
                }
                .accentColor(.black)
                
                Form {
                    Section {
                        TextField("Who are you?", text: $name)
                        TextField("What's your caption?", text: $caption)
                    }
                }
            }
            
            Button(action: {
                createUser()
                isPresentingSelf = false
            }, label: {
                Text("Done")
                    .accentColor(.red)
            })
        }
        .sheet(isPresented: $isPresentingIcons) {
            IconSelectionView(showModal: $isPresentingIcons, icon: $icon)
        }
    }
    
    private func createUser() {
        let ref = Database.database().reference().child("users").childByAutoId()
        ref.setValue(
            [
                "name": name,
                "caption": caption,
                "icon": icon,
                "points": 0
            ]
        )
    }
}
