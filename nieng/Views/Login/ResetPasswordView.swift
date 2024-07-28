//
//  ResetPasswordView.swift
//  nieng
//
//  Created by Quyen Dang on 17/08/2023.
//

import SwiftUI
import Firebase

struct ResetPasswordView: View {
    @State private var email = ""
    @State private var isShowingAlert = false
    @State private var errorMessage: String?
    @Binding var presentedBinding: Bool
    
    var presentSuccessfulMessage: (()->()) = {}
    
    fileprivate func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: self.email) { error in
            if error != nil {
                self.errorMessage = error?.localizedDescription
                self.isShowingAlert = true
                return
            }
            
            UIApplication.shared.endEditing()
            self.presentSuccessfulMessage()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .trailing) {
                Button("Cancel") {
                    self.presentedBinding = false
                }
                .padding()
                
                VStack {
                    Spacer()
                    
                    Image("resetpw")
                        .resizable()
                        .scaledToFit()
                        .frame(height: geometry.size.height * 0.35, alignment: .center)
                    
                    Spacer()
                    
                    VStack {
                        Text("Forgot Password?")
                            .bold()
                            .font(.title)
                            .padding(.vertical)
                        Text("Enter the email address associated with you account")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical)
                
                    TextFieldView(string: self.$email,
                                  passwordMode: false,
                                  placeholder: "Enter your email",
                                  iconName: "envelope.fill")
                        .padding(.bottom, 40)
                    
                    Button(action: { self.resetPassword() }) {
                        Rectangle()
                            .fill(Color.button)
                            .frame(height: 50, alignment: .center)
                            .overlay(Text("Reset").foregroundColor(Color.labelButton).bold())
                            .cornerRadius(8)
                    }
                        .alert(isPresented: self.$isShowingAlert) {
                            Alert(title: Text("Error!"),
                                  message: Text(self.errorMessage!),
                                  dismissButton: .destructive(Text("OK")))
                        }
                    .padding(.bottom)
                }
                .keyboardAdaptive()
                .padding(.horizontal, 30)
            }
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    @State static var presentedBinding = false
    static var previews: some View {
        ResetPasswordView(presentedBinding: $presentedBinding)
    }
}
