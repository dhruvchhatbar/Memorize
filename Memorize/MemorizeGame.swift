//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Dhruv Chhatbar on 02/12/24.
// Model

import Foundation

struct MemorizeGame<CardContent> where CardContent: Equatable{
   private(set) var cards: [Card]
   private(set) var score = 0
    
    init(numberOfPairs: Int, cardContentFactory: (Int) -> CardContent){
        cards = []
        for index in 0..<max(2,numberOfPairs){
            cards.append(Card(content: cardContentFactory(index), id: "\(index+1)a"))
            cards.append(Card(content: cardContentFactory(index), id: "\(index+1)b"))
        }
    }
    var indexOfTheOneAndOnlyFaceUpCard: Int?{
        get{
             return cards.indices.filter({index in cards[index].isFaceUp}).only
        }
        set{
            cards.indices.forEach({cards[$0].isFaceUp = (newValue == $0)})
            for index in cards.indices{
                if index == newValue{
                    cards[index].isFaceUp = true
                }
                else{
                    cards[index].isFaceUp = false
                }
            }
        }
    }
    mutating func choose(_ card: Card){
        guard let choosenCardIndex = cards.firstIndex(where: {$0.id == card.id}) else{return}
        print(card)
        if !cards[choosenCardIndex].isFaceUp && !cards[choosenCardIndex].isMatched{
            if let potentialCard = indexOfTheOneAndOnlyFaceUpCard{
                print("A")
                if cards[choosenCardIndex].content == cards[potentialCard].content{
                    cards[choosenCardIndex].isMatched = true
                    cards[potentialCard].isMatched = true
                    score += 2 + cards[choosenCardIndex].bonus + cards[potentialCard].bonus
                }
                else{
                    if cards[choosenCardIndex].hasBeenSeen{
                        score -= 1
                    }
                    if cards[potentialCard].hasBeenSeen{
                        score -= 1
                    }
                }
            }
            else{
                print("B")
                indexOfTheOneAndOnlyFaceUpCard = choosenCardIndex
            }
            cards[choosenCardIndex].isFaceUp = true
        }
        
        
//        cards[choosenCardIndex].isFaceUp.toggle()
    }
    mutating func shuffle(){
        cards.shuffle()
    }
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible{
        var debugDescription: String{
            return "\(id): \(content), \(isFaceUp ? "FaceUp" : "FaceDown")"
        }
        var isFaceUp: Bool = false{
            didSet{
                if isFaceUp{
                    startUsingBonusTime()
                }
                else{
                    stopUsingBonusTime()
                }
                if oldValue && !isFaceUp{
                    hasBeenSeen = true
                }
            }
        }
        var isMatched: Bool = false{
            didSet{
                if isMatched{
                    stopUsingBonusTime()
                }
            }
        }
        var hasBeenSeen: Bool = false
        var content: CardContent
        var id: String
        // MARK: - Bonus Time
        
        // call this when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // call this when the card goes back face down or gets matched
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
        
        // the bonus earned so far (one point for every second of the bonusTimeLimit that was not used)
        // this gets smaller and smaller the longer the card remains face up without being matched
        var bonus: Int {
            Int(bonusTimeLimit * bonusPercentRemaining)
        }
        
        // percentage of the bonus time remaining
        var bonusPercentRemaining: Double {
            bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
        }
        
        // how long this card has ever been face up and unmatched during its lifetime
        // basically, pastFaceUpTime + time since lastFaceUpDate
        var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // can be zero which would mean "no bonus available" for matching this card quickly
        var bonusTimeLimit: TimeInterval = 6
        
        // the last time this card was turned face up
        var lastFaceUpDate: Date?
        
        // the accumulated time this card was face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
    }
}
extension Array{
    var only:Element?{
        count == 1 ? first : nil
    }
}
