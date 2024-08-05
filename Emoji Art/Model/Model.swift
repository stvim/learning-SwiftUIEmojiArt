//
//  Model.swift
//  Emoji Art
//
//  Created by Steven Morin on 05/08/2024.
//

import Foundation

struct Palette: Identifiable {
    var name: String
    var emojis: String
    let id = UUID()
    
    static let builtins = [
        Palette(name: "test1", emojis: "🎹🎼🏵️🏆🚇🚆🚜🎢🏘️🏝️🚝🚚🧨🧰⛓️‍💥🧿🛁")
        , Palette(name: "test2", emojis: "🤡💩👻💀💼🧣🧤💦🍋🍅🧅🥨🫑🥭🍑🎳🎯")
    ]
}

    
