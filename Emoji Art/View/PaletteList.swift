//
//  PaletteList.swift
//  Emoji Art
//
//  Created by Steven Morin on 07/08/2024.
//

import SwiftUI

struct PaletteList: View {
    @EnvironmentObject var store: PaletteStore
    
    var body: some View {
        NavigationStack {
            List (store.palettes) { palette in
                NavigationLink(value: palette) {
                    VStack(alignment: .leading) {
                        Text(palette.name)
                        Text(palette.emojis).lineLimit(1)
                    }
                }
            }
            .navigationDestination(for: Palette.self ) {
                palette in
                PaletteView(palette: palette)
            }
            .navigationTitle("\(store.name) Palettes")
        }
    }
}

struct EditablePaletteList: View {
    @EnvironmentObject var store: PaletteStore
    @State private var showCursorPalette = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.palettes) { palette in
                    NavigationLink(value: palette) {
                        VStack(alignment: .leading) {
                            Text(palette.name)
                            Text(palette.emojis).lineLimit(1)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    withAnimation {
                        store.palettes.remove(atOffsets: indexSet)
                    }
                })
                .onMove(perform: { indices, newOffset in
                    store.palettes.move(fromOffsets: indices, toOffset: newOffset)
                })
            }
            .navigationDestination(for: Palette.self ) {
                palette in
                if let paletteIndex = store.palettes.firstIndex(where: { $0.id == palette.id }) {
                    PaletteEditor(palette: $store.palettes[paletteIndex])
                }
            }
            .navigationDestination(isPresented: $showCursorPalette) {
                PaletteEditor(palette: $store.palettes[store.cursorIndex])
            }
            .navigationTitle("\(store.name) Palettes")
            .toolbar {
                Button {
                    store.insert(name: "", emojis: "")
                    showCursorPalette = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct PaletteView: View {
    let palette: Palette
    
    var body: some View {
        VStack {
            Text(palette.name)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], content: {
                ForEach(palette.emojis.uniqued.map{ String.init($0) }, id: \.self) { emoji in
                    NavigationLink(value: emoji) {
                        Text(emoji)
                    }
                }
            })
            .navigationDestination(for: String.self) { emoji in
                Text(emoji).font(.system(size: 300))
            }
            Spacer()
        }
    }
}

//#Preview {
//    PaletteList(store: PaletteStore(name: "Preview"))
//}
