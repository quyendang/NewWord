//
//  iOSCheckboxToggleStyle.swift
//  nieng
//
//  Created by Quyen Dang on 09/11/2023.
//

import Foundation
import SwiftUI

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            // 3
            Image(systemName: !configuration.isOn ? "eye.fill" : "eye.slash.fill")
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}
