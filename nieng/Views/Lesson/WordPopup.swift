//
//  PopupWheel.swift
//  TienLenPoint
//
//  Created by Quyen Dang on 13/02/2023.
//

import SwiftUI
import SpriteKit
import Lottie


struct WordPopup: View {
    @Binding var isPresented: Bool
    @Binding var selectedPage: Int
    @AppStorage("wordSize") var wordSize = 52
    @AppStorage("wordTypeSize") var wordTypeSize = 30
    @AppStorage("wordProSize") var wordProSize = 40
    @AppStorage("wordMeaningSize") var wordMeaningSize = 40
    @AppStorage("wordEgSize") var wordEgSize = 40

    @State var isLoading = false
    var delete: (() -> Void)
    @ObservedObject var lessonViewModel: LessonViewModel
    var lesson: Lesson
    
    var body: some View {
        ZStack{
//            SpriteView(scene: Snow(),
//                       options: [.allowsTransparency])
//            Eve()
//                .frame(maxHeight: .infinity)
//            SpriteView(scene: Snow(),
//                       options: [.allowsTransparency])
            VStack(spacing: 10){
//                Text(lesson.name)
//                    .font(.title)
//                    .textSelection(.enabled)
                LottieView(lottieFile: "duck.json")
                    .frame(height: 150)
                TabView(selection: $selectedPage) {
                    ForEach(lesson.words.indices, id: \.self) { index in
                        WordView(word: lesson.words[index], lesson: lesson, lessonViewModel: lessonViewModel)
                            .tabItem {
                                Label("Tab", systemImage: "circle")
                            }
                            .padding(.horizontal, 30)
                    }
                }
                
                Button {
                    isPresented.toggle()
                } label: {
                    Text("Done")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                HStack{
                    Spacer()
                    LottieView(lottieFile: "4061842.json")
                        .frame(width: 100, height: 150)
                    
                }
                
            }
            
            
        }
        
        .animation(.easeOut(duration: 0.2), value: selectedPage)
        .tabViewStyle(.page)
        .modifier(CustomWordViewModifier())
        .onAppear{
            
        }

    }
}


struct CustomWordPopupModifier: ViewModifier {
    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            content
        } else {
            content
                .padding(EdgeInsets(top: 37, leading: 24, bottom: 40, trailing: 24))
                .background(BlurView(style: .systemThinMaterial).cornerRadius(20))
                .shadowedStyle()
                .padding(.horizontal, 40)
        }
    }
}
