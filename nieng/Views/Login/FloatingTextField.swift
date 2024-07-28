//
//  FloatingTextField.swift
//  nieng
//
//  Created by Quyen Dang on 06/08/2023.
//

import SwiftUI

struct FloatingTextField: View {
    let title: String
    let text: Binding<String>
    var onTap: () -> Void
    @State var error = false
    var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(text.wrappedValue.isEmpty ? Color(.placeholderText) : .accentColor)
                .offset(y: text.wrappedValue.isEmpty ? 0 : -35)
                .scaleEffect(text.wrappedValue.isEmpty ? 1 : 0.75, anchor: .leading)
            HStack{
                TextField("", text: text)
                    .foregroundColor(error ? .red : .primary)
//                    .onChange(of: text.wrappedValue) { newValue in
//                        error = !GoogleAuthenticator().isValidSecret(secret: newValue)
//                    }
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary).onTapGesture {
                        text.wrappedValue = ""
                    }
                    .isVisible(isVisible: !text.wrappedValue.isEmpty)

            }
        }
        .padding(.top, 15)
        .animation(.spring(response: 0.4, dampingFraction: 0.3))
    }
}


struct FloatingTextField_Previews: PreviewProvider {
    static var previews: some View {
        FloatingTextField(title: "Secret", text: .constant("dsdsdsdsds"), onTap: {
            
        })
    }
}
