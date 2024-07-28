//
//  TextFieldView.swift
//  nieng
//
//  Created by Quyen Dang on 17/08/2023.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var string: String
    
    var passwordMode = false
    var placeholder: String
    var iconName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(Color.gray)
                    .padding(.vertical, 20)
                    .padding(.trailing, 5)
                    .padding(.leading, 20)
                
                if passwordMode {
                    SecureField(placeholder, text: $string)
                }
                else {
                    TextField(placeholder, text: $string)
                }
            }
        }
            
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
            )
    }
}

struct TextFieldView_Previews: PreviewProvider {
    @State static var myCoolBool = ""
    static var previews: some View {
        TextFieldView(string: $myCoolBool, placeholder: "Please enter your email", iconName: "envelope.fill")
    }
}
