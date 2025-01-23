//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Dhruv Chhatbar on 02/12/24.
// View-Model

import SwiftUI

class EmojiMemoryGame: ObservableObject{
    typealias Card = MemorizeGame<String>.Card
    private static var emojis = ["🕷️","😈","👻","🎃","😈","👻","🎃","😈","👻","🎃","🕷️","😈","👻","🎃","😈","👻","🎃","😈","👻","🎃"]
    var color : Color = .orange
    var score: Int{
        model.score
    }
    private static func createMemoryGame() -> MemorizeGame<String>{
        return MemorizeGame(numberOfPairs:9,cardContentFactory: { index in
            if emojis.indices.contains(index){
                return emojis[index]
            }
            else{
                return "👹"
            }
        })
    }
    
    
    @Published private var model: MemorizeGame = createMemoryGame()
    
    var card: [Card]{
        return model.cards
    }
    
    func choose(_ card: Card){
        model.choose(card)
    }
    func shuffle(){
        model.shuffle()
    }
}
