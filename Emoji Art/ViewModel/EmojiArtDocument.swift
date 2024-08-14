//
//  EmojiArtDocument.swift
//  Emoji Art
//
//  Created by Steven Morin on 02/08/2024.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var emojiArt = EmojiArt() {
        didSet {
            autosave()
            if emojiArt.background != oldValue.background {
                Task {
                    await fetchBackgroundImage()
                }
            }
        }
    }
    
    private let autosaveURL: URL = URL.documentsDirectory.appendingPathComponent("Autosaved.emojiart")
    
    private func autosave() {
        save(to: autosaveURL)
        print("autosaved to \(autosaveURL)")
    }
    
    private func save(to url: URL) {
        do {
            let data = try emojiArt.json()
            try data.write(to: url)
        } catch let error {
            print("EmojiArtDocument: error while saving \(error.localizedDescription)")
        }
    }

    init() {
        if let data = try? Data(contentsOf: autosaveURL)
            , let autosavedEmojiArt = try? EmojiArt(json: data) 
        {
            emojiArt = autosavedEmojiArt
        }
    }

    var emojis: [Emoji] {
        emojiArt.emojis
    }
    
    @Published var background: UrlImage = .none
    
    // MARK: - Intent(s)
    
    func setBackground(_ url: URL?) {
        emojiArt.background = url
    }
    
    func addEmoji(_ emoji: String, at position:Emoji.Position, size: CGFloat) {
        emojiArt.addEmoji(emoji, at: position, size: Int(size))
    }
    
    // MARK: - Background fetching
    @MainActor
    private func fetchBackgroundImage() async {
        if let url = emojiArt.background {
            background = .fetching(url)
            do {
                let uiImage = try await UrlImage.fetchUIImage(from: url)
                if url == emojiArt.background {
                    background = .found(uiImage)
                }
            } catch let error {
                background = .failed("Error fetching background: \(error.localizedDescription)")
            }
        }
    }
    
    
}

enum UrlImage {
    case none
    case fetching(URL)
    case found(UIImage)
    case failed(String)
    
    var uiImage : UIImage? {
        switch(self) {
            case .found(let uiImage):
                return uiImage
            default:
                return nil
        }
    }
    
    var isFetching : Bool {
        switch(self) {
            case .fetching(_):
                return true
            default:
                return false
        }
    }
    
    static func fetchUIImage(from url:URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        if let uiImage = UIImage(data: data) {
            return uiImage
        } else {
            throw Err.WrongImageData
        }
    }
    enum Err : Error {
        case WrongImageData
    }
}


extension EmojiArt.Emoji {
    var font: Font {
        Font.system(size: CGFloat(size))
    }
}

extension EmojiArt.Emoji.Position {
    func `in`(_ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(x: center.x + CGFloat(x), y:  center.y - CGFloat(y))
    }
}
