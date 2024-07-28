//
//  Int.swift
//  nieng
//
//  Created by Quyen Dang on 17/07/2023.
//

import Foundation
import SwiftUI

extension Int {
    func color() -> Color {
        let colors: [(Color, String)] = [
            (.yellow, "Yellow"),
            (.red, "Red"),
            (.orange, "Orange"),
            (.green, "Green"),
            (.blue, "Blue"),
            (.purple, "purple"),
            (Color(red: 238/255, green: 130/255, blue: 238/255), "Violet")]
        
        return colors[self].0
    }
}
