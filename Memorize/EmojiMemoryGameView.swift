//
//  ContentView.swift
//  Memorize
//
//  Created by Dhruv Chhatbar on 25/11/24.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    typealias Card = MemorizeGame<String>.Card
   @ObservedObject var viewModel: EmojiMemoryGame
    
    @State var cardCount = 10
    private let aspectRatio : CGFloat = 2/3

    var body: some View {
        VStack {
            cards.foregroundColor(viewModel.color)
            HStack{
                score
                Spacer()
                deck.foregroundColor(viewModel.color)
                Spacer()
                shuffle
            }
            .font(.largeTitle)
        }
        .padding()
    }
    
    private var score: some View{
        Text("Score: \(viewModel.score)")
            .animation(nil)
    }
    
    private var shuffle: some View{
        Button("Shuffle", action: {
            withAnimation {
                viewModel.shuffle()
            }
        })
    }
    
    private var cards: some View{
        AspectVGrid(viewModel.card, aspectRatio: aspectRatio) { card in
            if isDealt(card){
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .padding(4)
                    .overlay(FlyingNumber(number: showChange(causedBy: card)))
                    .zIndex(showChange(causedBy: card) != 0 ? 1 : 0)
                    .onTapGesture {
                        withAnimation {
                            chooseCard(card)
                        }
                    }
            }
        }
        .foregroundStyle(viewModel.color)
    }
    @Namespace private var dealingNameSpace
    private var deck: some View{
        ZStack{
            ForEach(unDealtCard){card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .onTapGesture {
            dealCards()
        }
    }
    
    private func dealCards(){
        // Deal the card
        var delay: TimeInterval = 0
            for card in viewModel.card{
                withAnimation(.easeInOut(duration: 1.0).delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += 0.15
        }
    }
    
    private let deckWidth: CGFloat = 50
    
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool{
        dealt.contains(card.id)
    }
    
    private var unDealtCard: [Card]{
        viewModel.card.filter{!isDealt($0)}
    }
    
    private func chooseCard(_ card: Card){
        let scoreBeforeChoosing = viewModel.score
        viewModel.choose(card)
        let scoreAfterChoosing = viewModel.score - scoreBeforeChoosing
        lastScoreChange = (scoreAfterChoosing, card.id)
    }
    
    @State private var lastScoreChange = (0, causedByCardId: "")
    
    private func showChange(causedBy card : Card) -> Int{
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
    }
}


#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}


//    var cardCountAdjusters: some View{
//        HStack {
//            cardRemover
//            Spacer()
//            cardAdder
//        }
//        .imageScale(.large)
//        .font(.largeTitle)
//    }
//    func cardCountAdjuster(by offset: Int, symbol: String) -> some View{
//        Button(action: {
//            cardCount += offset
//        }, label: {
//            Image(systemName: symbol)
//        })
//        .disabled(cardCount + offset < 1 || cardCount + offset > emojis.count)
//    }
//    var cardRemover: some View{
//        cardCountAdjuster(by: -1, symbol: "rectangle.stack.badge.minus.fill")
//    }
//    var cardAdder: some View{
//        cardCountAdjuster(by: +1, symbol: "rectangle.stack.badge.plus.fill")
//    }
