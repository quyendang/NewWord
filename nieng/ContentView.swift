//
//  ContentView.swift
//  nieng
//
//  Created by Quyen Dang on 14/07/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var authModel: AuthenticationModel
    @State var presentedLoginPage = false
    private let initialLaunchKey = "isInitialLoginLaunch"
    @StateObject private var audioManager = AudioManager()
    @AppStorage("chrismas") private var chrismas: Bool = true
    var body: some View {
        ZStack {
            if authModel.user == nil {
//                if presentedLoginPage || UserDefaults.standard.bool(forKey: "isInitialLoginLaunch") {
//                    LoginView()
//                        .environmentObject(authModel)
//                } else {
//                    OnboardingView(presentLoginView: {
//                        UserDefaults.standard.set(true, forKey: self.initialLaunchKey)
//                        withAnimation {
//                            self.presentedLoginPage = true
//                        }
//                    })
//                }
                LoginView()
                    .environmentObject(authModel)
            } else {
                MainView()
                
            }
        }.onAppear{
            
            authModel.listenToAuthState()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AuthenticationModel())
    }
}
