//
//  EmojiArtDocumentView.swift
//  Emoji Art
//
//  Created by Steven Morin on 02/08/2024.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArt.Emoji
    
    @ObservedObject var document: EmojiArtDocument
    @EnvironmentObject var paletteStore : PaletteStore
    
    private let emojis = "🤡💩👻💀💼🧣🧤💦🍋🍅🧅🥨🫑🥭🍑🎳🎯🎹🎼🏵️🏆🚇🚆🚜🎢🏘️🏝️🚝🚚🧨🧰⛓️‍💥🧿🛁"
    
    private let paletteEmojiSize: CGFloat = 40
    
    var body: some View {
        VStack {
            documentBody
//            ScrollingEmojis(emojis)
            PaletteChooser()
                .font(.system(size: paletteEmojiSize))
                .padding(.horizontal)
                .scrollIndicators(.hidden)
        }
    }
    
    private var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                documentContents(in: geometry)
                    .scaleEffect(zoom * gestureZoom)
                    .offset(pan + gesturePan)
            }
            .gesture(panGesture.simultaneously(with: zoomGesture))
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                return drop(sturldatas, at: location, in: geometry)
            }
        }
    }
    
    @State private var zoom: CGFloat = 1
    @State private var pan: CGOffset = .zero
    @GestureState private var gestureZoom: CGFloat = 1
    @GestureState private var gesturePan: CGOffset = .zero
    
    private var zoomGesture : some Gesture {
        MagnifyGesture()
            .updating($gestureZoom) { inMotionPinchScale, gestureZoom, transation in
                gestureZoom = inMotionPinchScale.magnification
            }
            .onEnded { endingPinchScale in
                zoom *= endingPinchScale.magnification
            }
    }
    
    private var panGesture : some Gesture {
        DragGesture()
            .updating($gesturePan) { value, gesturePan, _ in
                gesturePan = value.translation
            }
            .onEnded { value in
                pan += value.translation
            }
    }
    
    @ViewBuilder
    private func documentContents(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: document.background)
            .position(Emoji.Position.zero.in(geometry))
        ForEach(document.emojis) { emoji in
            Text(emoji.string)
                .font(emoji.font)
                .position(emoji.position.in(geometry))
        }
    }
    
    private func drop(_ sturldatas: [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        if let sturldata = sturldatas.first {
            switch sturldata {
            case .url(let url):
                document.setBackground(url)
                return true
            case .string(let emoji):
                document.addEmoji(emoji
                                  , at: emojiPostion(at: location, in: geometry)
                                  , size: paletteEmojiSize / zoom)
                return true
            default:
                break
            }
        }
        return false
    }
    
    private func emojiPostion(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        return Emoji.Position(x: Int((location.x - center.x - pan.width) / zoom)
                              , y: Int(-(location.y - center.y - pan.height) / zoom))
    }
}


//struct EmojiArtDocumentView_Previews : PreviewProvider {
//    static var previews: some View {
//            EmojiArtDocumentView(document: EmojiArtDocument())
//        }
//    
//}
#Preview {
    EmojiArtDocumentView(document: EmojiArtDocument())
        .environmentObject(PaletteStore(name: "Preview"))
}
