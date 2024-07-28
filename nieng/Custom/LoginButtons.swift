//
//  LoginButtons.swift
//  nieng
//
//  Created by Quyen Dang on 17/08/2023.
//

import SwiftUI
import Firebase

struct LoginButtons: View {
    @ObservedObject var authModel: AuthenticationModel
    @Binding var bindEmail: String
    @Binding var bindPassword:String
    
    @State private var errorMesssage: String?
    @State private var showingAlert = false
    @State private var showingSignUpPage = false
    
    @State private var alert: alertState = .standartMessage
    
    enum alertState {
        case standartMessage
        case verifivationError
    }
    
    fileprivate func login() {
        authModel.signIn(email: bindEmail, password: bindPassword) { error in
            if error != nil {
                self.errorMesssage = error?.localizedDescription
                self.alert = .standartMessage
                self.showingAlert = true
                return
            }
            
            if !Auth.auth().currentUser!.isEmailVerified {
                self.errorMesssage = "Your account has been created but not verified. Confirm registration by your email."
                self.alert = .verifivationError
                self.showingAlert = true
                return
            }
            
            UIApplication.shared.endEditing()
        }
    }
    
    var body: some View {
        
        VStack(alignment: .trailing) {
            Button(action: { self.login() }) {
                Rectangle()
                    .fill(Color.button)
                    .frame(height: 50, alignment: .center)
                    .overlay(Text("Sign In")
                        .foregroundColor(.labelButton)
                        .bold())
                    .cornerRadius(8)
            }
            .alert(isPresented: $showingAlert) {
                if alert == alertState.verifivationError {
                    return Alert(title: Text("Error!"),
                          message: Text(errorMesssage!),
                          primaryButton: .cancel(),
                          secondaryButton: .default(Text("Send email again"), action: {
                                Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                          })
                    )
                }
                else {
                    return Alert(title: Text("Error!"),
                    message: Text(errorMesssage!),
                    dismissButton: .destructive(Text("OK")))
                }
            }
            
            HStack {
                Text("No account?")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Button(action: { self.showingSignUpPage = true }) {
                    Text("Sign Up")
                        .foregroundColor(.blue)
                        .bold()
                        .font(.footnote)
                }
                .sheet(isPresented: self.$showingSignUpPage) {
                    RegistrationPageView(presentedBinding: $showingSignUpPage, authModel: authModel)
                }
            }
        }
    }
}

struct LoginButtons_Previews: PreviewProvider {
    @State static var email = ""
    @State static var password = ""
    //@ObservedObject static var session = EmailAuthenticationCntroller()
    static var previews: some View {
        LoginButtons(authModel: AuthenticationModel(), bindEmail: $email, bindPassword: $password)
    }
}
