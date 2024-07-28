//
//  Color.swift
//  nieng
//
//  Created by Quyen Dang on 17/08/2023.
//

import Foundation
import SwiftUI

extension Color{
    static var button: Color {
        Color(UIColor { (traits) -> UIColor in
            if traits.userInterfaceStyle == .dark {
                return UIColor.white
            } else {
                return UIColor.black
            }
        })
    }
    
    static var labelButton: Color {
        Color(UIColor { (traits) -> UIColor in
            if traits.userInterfaceStyle == .dark {
                return UIColor.black
            } else {
                return UIColor.white
            }
        })
    }
    
    static var redPro: Color {
        Color(#colorLiteral(red: 0.855, green: 0.063, blue: 0.224, alpha: 1)) // #da1039
    }
    
    static var bluePro: Color {
        Color(#colorLiteral(red: 0, green: 0.698, blue: 1, alpha: 1)) // #00b2ff
    }
    
    static var yellowPro: Color {
        Color(#colorLiteral(red: 0.996, green: 0.839, blue: 0.016, alpha: 1)) // #fed604
    }
    
    static var orangePro: Color {
        Color(#colorLiteral(red: 1, green: 0.6, blue: 0.439, alpha: 1)) // #ff9970
    }
    
    static var pinkPro: Color {
        Color(#colorLiteral(red: 1, green: 0.361, blue: 0.827, alpha: 1)) // #ff5cd3
    }
    
    static var greenPro: Color {
        Color(#colorLiteral(red: 0.216, green: 0.906, blue: 0.675, alpha: 1)) // #37e7ac
    }
    
    public enum Eve {
        static let background = Color.init(red: 0, green: 0.697, blue: 0.266)
    }
    
    public enum Ball {
        static let green = Color.init(red: 0.271, green: 0.982, blue: 0.577)
        static let pink = Color.init(red: 1, green: 0, blue: 0.254)
        static let cloud = Color.init(red: 0.415, green: 0.829, blue: 0.947)
        static let yellow = Color.init(red: 0.990, green: 0.935, blue: 0.131)
        static let lightYellow = Color.init(red: 0.993, green: 0.968, blue: 0.649)
    }

    static let christmasRed = Color.init(red: 214/255, green: 0, blue: 28/255)
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension Color {
    static func random() -> Color {
        return Color(
           red:   CGFloat.random(),
           green: CGFloat.random(),
           blue:  CGFloat.random()
        )
    }
}
