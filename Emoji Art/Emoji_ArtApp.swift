//
//  Emoji_ArtApp.swift
//  Emoji Art
//
//  Created by Steven Morin on 02/08/2024.
//

import SwiftUI

@main
struct Emoji_ArtApp: App {
    @StateObject var defaultDocument = EmojiArtDocument()
    @StateObject var paletteStore1 = PaletteStore(name: "Main")
    @StateObject var paletteStore2 = PaletteStore(name: "Alternate")
    @StateObject var paletteStore3 = PaletteStore(name: "Special")
    
    var body: some Scene {
        WindowGroup {
            PaletteManager(stores: [paletteStore1, paletteStore2, paletteStore3])
//            EmojiArtDocumentView(document: defaultDocument)
                .environmentObject(paletteStore1)
        }
    }
}
