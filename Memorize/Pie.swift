//
//  Pie.swift
//  Memorize
//
//  Created by Dhruv Chhatbar on 16/12/24.
//

import SwiftUI
import CoreGraphics

struct Pie: Shape{
    var startAngle : Angle = .zero
    var endAngle : Angle
    var clockwise = true
    func path(in rect: CGRect) -> Path {
        let startAngle = startAngle - Angle(degrees: 90)
        let endAngle = endAngle - Angle(degrees: 90)
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let starrt = CGPoint(
            x: center.x + radius * cos(startAngle.radians),
            y: center.x + radius * sin(startAngle.radians)
        )
        
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: starrt)
        
        p.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: !clockwise
        )
        p.addLine(to: center)
        
        return p
    }
    
}
