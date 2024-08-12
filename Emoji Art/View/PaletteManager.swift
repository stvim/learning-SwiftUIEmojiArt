//
//  PaletteManager.swift
//  Emoji Art
//
//  Created by Steven Morin on 12/08/2024.
//

import SwiftUI

struct PaletteManager: View {
    var stores: [PaletteStore]
    @State private var selectedStore: PaletteStore?
    
    
    var body: some View {
        NavigationSplitView{
            List(stores
                 , selection: $selectedStore
                 , rowContent: { store in
                Text(store.name)
                    .tag(store)
            })
        } content: {
            if let selectedStore {
                EditablePaletteList(store: selectedStore)
            }
            Text("Choose a store")
        } detail: {
            Text("Choose a palette")
        }
    }
}

#Preview {
    PaletteManager(stores: [PaletteStore(name: "Preview")])
}
