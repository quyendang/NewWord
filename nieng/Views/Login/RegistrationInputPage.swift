//
//  RegistrationInputPage.swift
//  nieng
//
//  Created by Quyen Dang on 17/08/2023.
//

import SwiftUI

struct RegistrationInputPage: View {
    @State private var firstName = ""
    @State private var lastName  = ""
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Button(action: {
                
            })
            {
                Image("asset2")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
            }
            .padding()
            
            TextFieldView(string: $firstName,
                          placeholder: "Enter your name",
                          iconName: "folder")
                .padding(.vertical, 8)
            
            TextFieldView(string: $firstName,
                          placeholder: "Enter your last name",
                          iconName: "folder")
                .padding(.vertical, 8)
            
            Spacer()
            Button(action: {  }) {
                Rectangle()
                    .fill(Color.button)
                    .frame(height: 50, alignment: .center)
                    .overlay(Text("Finish")
                        .foregroundColor(.labelButton)
                        .bold())
                    .cornerRadius(8)
            }
        }
        .padding(.bottom)
        .padding(.horizontal, 30)
    }
}

struct RegistrationInputPage_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationInputPage()
    }
}
