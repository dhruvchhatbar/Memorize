//
//  CardView.swift
//  Memorize
//
//  Created by Dhruv Chhatbar on 12/12/24.
//

import SwiftUI

struct CardView: View {
    typealias Card = MemorizeGame<String>.Card
    let card:Card
    
    init(_ card: Card) {
        self.card = card
        
    }
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
        static let inset: CGFloat = 5
        struct FontSize {
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor = smallest / largest
        }
        struct pieConstants{
            static let opacity: CGFloat = 0.5
            static let inset: CGFloat = 5
        }
    }
    
    var body: some View {
        TimelineView((.animation)){ timeline in
            //        TimelineView((AnimationTimelineSchedule(minimumInterval: 1/10))){ timeline in
            if card.isFaceUp || !card.isMatched{
                Pie(endAngle: Angle(degrees: card.bonusPercentRemaining * 360))
                    .opacity(Constants.pieConstants.opacity)
                    .overlay {
                        cardContents
                            .padding(Constants.pieConstants.inset)
                    }
                    .transition(.scale)
                    .padding(Constants.inset)
                    .modifier(Cardify(isFaceUp: card.isFaceUp))
            }
            else{
                Color.clear
            }
        }
    }
    var cardContents: some View{
        Text(card.content)
            .font(.system(size: Constants.FontSize.largest))
            .minimumScaleFactor(Constants.FontSize.scaleFactor)
            .aspectRatio(contentMode: .fit)
            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
            .animation(.spin(duration: 1.0), value: card.isMatched)
    }
}
extension Animation
{
    static func spin(duration: TimeInterval) -> Animation{
        return .linear(duration: duration).repeatForever(autoreverses: false)
    }
}

#Preview {
    CardView(MemorizeGame.Card(content: "#", id: "test1"))
        .padding()
        .foregroundStyle(.red)
}
