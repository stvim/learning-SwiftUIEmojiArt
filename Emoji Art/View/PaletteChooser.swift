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
    }
    
    var chooser: some View {
        Button {
            withAnimation{
                store.cursorIndex += 1
            }
        } label: {
            Image(systemName: "paintpalette")
        }
    }
    
    func view(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollingEmojis(palette.emojis)
        }
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
