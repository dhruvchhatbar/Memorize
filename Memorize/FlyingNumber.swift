//
//  FlyingNumber.swift
//  Memorize
//
//  Created by Dhruv Chhatbar on 17/12/24.
//

import SwiftUI

struct FlyingNumber: View {
    var number: Int
    @State private var offset: CGFloat = 0
    var body: some View {
        if number != 0{
            Text((number),format: .number.sign(strategy: .always()))
                .font(.largeTitle)
                .foregroundStyle(number < 0 ? .red : .green)
                .shadow(color: .black, radius: 1.5, x: 1, y: 1)
                .offset(x: 0, y: offset)
                .opacity(offset == 0 ? 1.0 : 0.0)
                .onAppear(perform: {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        offset = number < 0 ? 200 : -200
                    }
                })
                .onDisappear{
                    offset = 0
                }
        }
    }
}

#Preview {
    FlyingNumber(number: 0)
}
