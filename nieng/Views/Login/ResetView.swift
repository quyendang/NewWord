//
//  ResetView.swift
//  nieng
//
//  Created by Quyen Dang on 17/08/2023.
//

import SwiftUI

struct ResetView: View {
    @Binding var presentedBinding: Bool
    
    @State private var showingPage = false
    
    var body: some View {
        ZStack {
            VStack {
                if showingPage == true {
                    Successful(presentedBinding: $presentedBinding)
                        .animation(.spring())
                        .transition(.move(edge: .trailing))
                }
                else {
                    ResetPasswordView(presentedBinding: $presentedBinding, presentSuccessfulMessage: {
                            withAnimation {
                                self.showingPage = true
                            }
                        })
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
            }
        }
    }
}

struct ResetView_Previews: PreviewProvider {
    @State static var bool = true
    static var previews: some View {
        ResetView(presentedBinding: $bool)
    }
}
