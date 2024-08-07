//
//  PaletteEditor.swift
//  Emoji Art
//
//  Created by Steven Morin on 07/08/2024.
//

import SwiftUI

struct PaletteEditor: View {
    @Binding var palette: Palette
    @State var emojisToAdd: String = ""
    @FocusState var focused : Focused?
    
    enum Focused {
        case name, addEmojis
    }
    
    var emojiFont = Font.system(size: 40)
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $palette.name)
                    .focused($focused, equals: .name)
            }
            Section(header:Text("Emojis")) {
                Group {
                    addEmojis
                        .focused($focused, equals: .addEmojis)
                    removeEmojis
                }
                .font(emojiFont)
            }
        }
        .frame(minWidth: 400, minHeight: 400)
        .onAppear{
            if palette.name.isEmpty {
                focused = .name
            } else {
                focused = .addEmojis
            }
        }
    }
    
    var addEmojis: some View {
        TextField("Add emojis", text: $emojisToAdd)
            .onChange(of: emojisToAdd) {
                palette.emojis = (emojisToAdd + palette.emojis)
                    .uniqued
            }
    }
    
    var removeEmojis: some View {
        VStack {
            Text("Tap to remove emojis").font(.caption).foregroundStyle(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], content: {
                ForEach(palette.emojis.uniqued.map{ String.init($0) }, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            palette.emojis.removeAll(emoji)
                            emojisToAdd.removeAll(emoji)
                        }
                }
            })
        }
    }
}

fileprivate struct Preview: View {
    @State private var palette = PaletteStore(name: "Preview").palettes.first!
    var body: some View {
        PaletteEditor(palette: $palette)
    }
}

#Preview {
    Preview()
}
