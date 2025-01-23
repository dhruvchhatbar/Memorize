//
//  Cardify.swift
//  Memorize
//
//  Created by Dhruv Chhatbar on 16/12/24.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable{
    
    init(isFaceUp: Bool) {
        self.rotation = isFaceUp ? 0 : 180
    }
    var isFaceUp: Bool{
        rotation < 90
    }
    
    var rotation: Double
    var animatableData: Double{
        get{return rotation}
        set{rotation = newValue}
    }
    
    func body(content: Content) -> some View {
        ZStack
        {
            let baseRec =  RoundedRectangle(cornerRadius: Constants.cornerRadius)
            
            baseRec
                .stroke(style: StrokeStyle(lineWidth:Constants.lineWidth)).background(baseRec.fill(.white))
                .overlay {
                    content
                }
                .opacity(isFaceUp ? 1 : 0)
            baseRec
                .fill()
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(
            .degrees(rotation),axis: (x: 0.0, y: 1.0, z: 0.0)
        )
    }
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
    }
}
extension View {
    func cardify(isFaceUp:Bool) -> some View{
       return modifier(Cardify(isFaceUp: isFaceUp))
    }
}
