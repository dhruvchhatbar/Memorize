//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Dhruv Chhatbar on 25/11/24.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
