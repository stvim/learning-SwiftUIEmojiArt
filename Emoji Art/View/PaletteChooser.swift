//
//  PaletteChooser.swift
//  Emoji Art
//
//  Created by Steven Morin on 06/08/2024.
//

import SwiftUI

struct PaletteChooser: View {
    @EnvironmentObject var store: PaletteStore
    
    var body: some View {
        HStack {
            chooser
            view(for: store.palettes[store.cursorIndex])
        }
        .clipped()
    }
    
    var chooser: some View {
        AnimatedActionButton(systemImage: "paintpalette") {
            store.cursorIndex += 1
        }
        .contextMenu{
            gotoMenu
            AnimatedActionButton("New", systemImage: "plus") {
                store.insert(name: "Math", emojis: "+-x/")
            }
            AnimatedActionButton("Delete", systemImage: "minus.circle", role: .destructive) {
                store.palettes.remove(at: store.cursorIndex)
            }
        }
//        Button {
//            withAnimation{
//                store.cursorIndex += 1
//            }
//        } label: {
//            Image(systemName: "paintpalette")
//        }
    }
    
    private var gotoMenu: some View {
        Menu {
            ForEach(store.palettes) { palette in
                AnimatedActionButton(palette.name) {
                    if let paletteIndex = store.palettes.firstIndex(where: { $0.id == palette.id }) {
                        store.cursorIndex = paletteIndex
                    }
                }
            }
        } label: {
            Label("Go to", systemImage: "text.insert")
        }
    }
    
    func view(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollingEmojis(palette.emojis)
        }
        .id(palette.id)
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
    }
}

struct ScrollingEmojis: View {
    let emojis: [String]
    
    init(_ emojis: String) {
        self.emojis = emojis.uniqued.map(String.init)
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .draggable(emoji)
                }
            }
        }
    }
}


#Preview {
    PaletteChooser()
        .environmentObject(PaletteStore(name: "Preview"))
}
