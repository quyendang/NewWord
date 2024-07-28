//
//  ResetSuccessful.swift
//  nieng
//
//  Created by Quyen Dang on 17/08/2023.
//

import SwiftUI

struct Successful: View {
    @Binding var presentedBinding: Bool
    
    var body: some View {
        VStack(alignment: .trailing) {
            Spacer()
            VStack {
                Image("ok")
                    .resizable()
                    .scaledToFit()
                Text("Successful")
                    .font(.title)
                    .bold()
                Text("Password recovery instructions have been sent to your email.")
                    .foregroundColor(.secondary)
                    .padding(.vertical)
                    .padding(.horizontal, 30)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            Button(action: { self.presentedBinding = false })
            {
                Rectangle()
                    .fill(Color.button)
                    .frame(height: 50, alignment: .center)
                    .overlay(Text("Continue").foregroundColor(Color.labelButton).bold())
                    .cornerRadius(8)
            }
            .padding(.vertical)
            .padding(.horizontal, 30)
        }
    }
}

struct Successful_Previews: PreviewProvider {
    @State static var bool = true
    static var previews: some View {
        Successful(presentedBinding: $bool)
    }
}
