//
//  Model.swift
//  Emoji Art
//
//  Created by Steven Morin on 05/08/2024.
//

import Foundation

struct Palette: Identifiable, Codable, Hashable {
    var name: String
    var emojis: String
    var id = UUID()
    
    static var builtins : [Palette] { [
        Palette(name: "test1", emojis: "🎹🎼🏵️🏆🚇🚆🚜🎢🏘️🏝️🚝🚚🧨🧰⛓️‍💥🧿🛁")
        , Palette(name: "test2", emojis: "🤡💩👻💀💼🧣🧤💦🍋🍅🧅🥨🫑🥭🍑🎳🎯")
    ]
    }
}

    
