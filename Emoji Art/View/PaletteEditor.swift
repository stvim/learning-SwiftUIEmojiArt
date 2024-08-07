//
//  PaletteEditor.swift
//  Emoji Art
//
//  Created by Steven Morin on 07/08/2024.
//

import SwiftUI

struct PaletteEditor: View {
    @Binding var palette: Palette
    
    var emojiFont = Font.system(size: 40)
    
    var body: some View {
        Text("Palette Editor")
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $palette.name)
            }
            Section(header:Text("Emojis")) {
                Group {
                    Text("Add emojis here")
                    removeEmojis
                }
                .font(emojiFont)
            }
        }
        .frame(minWidth: 400, minHeight: 400)
    }
    
    
    var removeEmojis: some View {
        VStack {
            Text("Tap to remove emojis").font(.caption).foregroundStyle(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], content: {
                ForEach(palette.emojis.uniqued.map{ String.init($0) }, id: \.self) { emoji in
                    Text(emoji)
                }
            })
        }
    }
}

//#Preview {
//    PaletteEditor(palette: Palette.builtins.first!)
//}
