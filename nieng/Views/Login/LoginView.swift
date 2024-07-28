//
//  LoginView.swift
//  nieng
//
//  Created by Quyen Dang on 17/07/2023.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import GoogleSignInSwift
import TTProgressHUD

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var authModel: AuthenticationModel
    @State var signInHandler: AuthenticationModel?
    @State var hudConfig = TTProgressHUDConfig(type: .loading, title: "Loading")
    @State var email = ""
    @State var password = ""
    @State private var presentedPasswordReset = false
    var body: some View {
        ZStack(alignment: .top){
            VStack(alignment: .leading){
                Text("Login to account")
                    .bold()
                    .font(.largeTitle)
                    .padding(.horizontal, 30)
                    .padding(.top)
                Spacer()
                VStack(alignment: .center) {
                    Image("words")
                        .resizable()
                        .scaledToFit()
                        .padding()
                    VStack {
                        TextFieldView(string: self.$email,
                            passwordMode: false,
                            placeholder: "Enter your email",
                            iconName: "envelope.fill")
                            .padding(.vertical, 8)
                            
                        VStack(alignment: .trailing) {
                            TextFieldView(string: self.$password,
                                passwordMode: true,
                                placeholder: "Enter your password",
                                iconName: "lock.open.fill")
                            
                            Button(action: { self.presentedPasswordReset = true }) {
                                Text("Forgot password?")
                                    .foregroundColor(Color.blue)
                                    .bold()
                                    .font(.footnote)
                            }
                            .sheet(isPresented: $presentedPasswordReset) {
                                ResetView(presentedBinding: self.$presentedPasswordReset)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    LoginButtons(authModel: authModel, bindEmail: $email,
                        bindPassword: $password)
                }
                .keyboardAdaptive()
                .padding(.bottom)
                .padding(.horizontal, 30)
                LoginFooterView(signinApple: {
                    authModel.login(.apple)
                }, signinGoogle: {
                    authModel.login(.google)
                })
                    .padding(.horizontal, 20)
                    .padding(.bottom)
                Text("*When you use this application, you agree to our terms and regulations.")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 10)
                

            }
            TTProgressHUD($authModel.isAuthenticating, config: hudConfig)
        }
        .navigationBarTitle("")
    }
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthenticationModel())
    }
}
