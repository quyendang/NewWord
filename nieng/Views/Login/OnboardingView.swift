////
////  OnboardingView.swift
////  nieng
////
////  Created by Quyen Dang on 17/08/2023.
////
//
//import SwiftUI
//
//struct OnboardingView: View {
//    @State private var selectedPage = 0
//    var presentLoginView: (()->()) = {}
//    
//    var body: some View {
//        VStack{
//            TabView(selection: $selectedPage) {
//                VStack(alignment: .center) {
//                    Image("t-logo")
//                        .resizable()
//                        .scaledToFit()
//                    Text("Follow the process of braces")
//                        .multilineTextAlignment(.center)
//                        .font(Font.largeTitle)
//                    Text("Count the time of braces, create an appointment, store the braces process")
//                        .font(Font.subheadline)
//                        .padding(.bottom, 20)
//                        .multilineTextAlignment(.center)
//                }.padding()
//                    .tag(0)
//                VStack(alignment: .center) {
//                    Text("Braces community")
//                        .font(Font.largeTitle)
//                        .multilineTextAlignment(.center)
//                    Text("Connect with the community of braces people")
//                        .font(Font.subheadline)
//                        .padding()
//                        .multilineTextAlignment(.center)
//                    Image("community")
//                        .resizable()
//                        .scaledToFit()
//                }.padding()
//                    .tag(1)
//            }
//            .tabViewStyle(.page)
//            .indexViewStyle(.page(backgroundDisplayMode: .always))
//            Button(action: {
//                if selectedPage == 1 {
//                    self.presentLoginView()
//                } else{
//                    withAnimation { selectedPage += 1 }
//                }
//            }, label: {
//                Text("Next").padding(.horizontal, 20)
//                    .foregroundColor(.labelButton)
//            })
//            .padding(.horizontal, 20)
//            .buttonStyle(.borderedProminent)
//            .controlSize(.large)
//            .tint(.button)
//            Button(action: {
//                self.presentLoginView()
//            }, label: {
//                Text("Skip").padding(.horizontal, 20)
//            })
//            
//            .padding(.horizontal, 20)
//            .controlSize(.large)
//        }
//        .edgesIgnoringSafeArea(.top)
//        .navigationViewStyle(StackNavigationViewStyle())
//    }
//}
//
//struct OnboardingViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView()
//    }
//}
