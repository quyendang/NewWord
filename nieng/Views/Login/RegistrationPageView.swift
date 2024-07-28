//
//  RegistrationPageView.swift
//  nieng
//
//  Created by Quyen Dang on 17/08/2023.
//

import SwiftUI
import Firebase

struct RegistrationPageView: View {
    @Binding var presentedBinding: Bool
    @ObservedObject var authModel: AuthenticationModel
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @State private var errorMessage: String?
    @State private var showingAlert = false
    
    fileprivate func registration() {
        if password != confirmPassword {
            self.errorMessage = "Password mismatch!"
            self.showingAlert = true
            return
        }
        authModel.signUp(email: email, password: password) { error in
            if error != nil {
                self.errorMessage = error?.localizedDescription
                self.showingAlert = true
                return
            }
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                
            })
            UIApplication.shared.endEditing()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Get new account")
                    .bold()
                    .font(.largeTitle)
                    .padding(.horizontal, 30)
                    .padding(.top)
                Spacer()
                VStack(alignment: .center){
                    Image("words")
                        .resizable()
                        .scaledToFit()
                    
                    Spacer()
                    
                    VStack {
                       TextFieldView(string: $email,
                                     passwordMode: false,
                                     placeholder: "Enter your email",
                                     iconName: "envelope.fill")
                            .padding(.vertical, 8)
                        
                        TextFieldView(string: $password,
                                      passwordMode: true,
                                      placeholder: "Enter your password",
                                      iconName: "lock.open.fill")
                            .padding(.vertical, 8)
                        
                        TextFieldView(string: $confirmPassword,
                                      passwordMode: true,
                                      placeholder: "Confirm your password",
                                      iconName: "repeat")
                            .padding(.vertical, 8)
                    }
                    .padding(.vertical)
                    
                    Button(action: { self.registration() })
                    {
                        Rectangle()
                            .fill(Color.button)
                            .frame(height: 50, alignment: .center)
                            .overlay(Text("Continue")
                                .foregroundColor(.labelButton)
                                .bold())
                            .cornerRadius(8)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Error!"), message: Text(self.errorMessage!), dismissButton: .destructive(Text("OK")))
                    }
                }
            }
            .keyboardAdaptive()
            .padding(.horizontal, 30)
            .navigationBarItems(trailing: Button("Cancel") {
                self.presentedBinding = false
            })
        }
        .padding(.bottom)
        .padding(.bottom)
    }
}

struct RegistrationPageView_Previews: PreviewProvider {
    @State static var previewPresented = false
    @ObservedObject static var session = EmailAuthenticationCntroller()
    static var previews: some View {
        RegistrationPageView(presentedBinding: $previewPresented, authModel: AuthenticationModel())
    }
}
