//
//  EmailAuthenticationCntroller.swift
//  nieng
//
//  Created by Quyen Dang on 17/08/2023.
//

import Firebase
import FirebaseAuth
import SwiftUI

class EmailAuthenticationCntroller: ObservableObject {
    @Published var isLogin: Bool?
    @Published var session: User?
    
    func initialSession() {
        session = Auth.auth().currentUser
        if session != nil && session!.isEmailVerified {
            withAnimation {
                self.isLogin = true
            }
        }
        else {
            withAnimation {
                self.isLogin = false
            }
        }
    }
    
    func login(email: String, password: String) {
       // Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func createAccount(email: String, password: String) {
       // Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func logout() {
        try! Auth.auth().signOut()
        
        withAnimation {
            self.isLogin = false
        }
    }
}
