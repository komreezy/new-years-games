//
//  IconSelectionView.swift
//  NYG
//
//  Created by Komran Ghahremani on 12/29/20.
//

import SwiftUI

struct IconSelectionView: View {
    @Binding var showModal: Bool
    var columns: [GridItem] = [
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16),
        GridItem(.fixed(100), spacing: 16),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 16,
                pinnedViews: [.sectionHeaders, .sectionFooters]
            ) {
                Section(header: Text("Choose your Icon").font(.title).padding()) {
                    ForEach(symbols, id: \.self) { symbol in
                        Image(systemName: symbol)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 30, maxHeight: 30)
                            .onTapGesture {
                                UserDefaults.standard.set(symbol, forKey: "icon")
                                showModal.toggle()
                            }
                    }
                }
            }
        }
    }
}

struct IconSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        IconSelectionView(showModal: .constant(true))
    }
}
