//
//  LoginFooterView.swift
//  nieng
//
//  Created by Quyen Dang on 17/08/2023.
//

import SwiftUI

struct LoginFooterView: View {
    var signinApple: (()->()) = {}
    var signinGoogle: (()->()) = {}
    
    fileprivate func createButton(title: String, imageName: String, action:  @escaping (()->())) -> some View {
        return Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
                HStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22, alignment: .center)

                    Text(title)
                        .font(.caption)
                        .bold()
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 0.5)
                Text("More")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 0.5)
            }
                .padding(.vertical, 5)
            HStack {
                createButton(title: "Google", imageName: "google", action: signinGoogle)
                    .frame(height: 45, alignment: .center)
                    .buttonStyle(PlainButtonStyle())
                createButton(title: "Apple", imageName: "apple", action: signinApple)
                    
                    .frame(height: 45, alignment: .center)
                    .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct LoginFooterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFooterView()
    }
}
