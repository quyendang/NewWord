//
//  LessonPageView.swift
//  nieng
//
//  Created by Quyen Dang on 14/11/2023.
//

import SwiftUI


struct LessonPageView: View {
    @ObservedObject var lessonViewModel: LessonViewModel
    var lesson: Lesson
    @State var selectedPage = 0
    @State private var isPageDeatailActive = false
    @State private var showSettingView = false
    
    
    
    var body: some View {
        VStack {
            TabView(selection: $selectedPage) {
                ForEach(lesson.words.indices, id: \.self) { index in
                    WordView(word: lesson.words[index], lesson: lesson, lessonViewModel: lessonViewModel)
                        .tabItem {
                            Label("Tab", systemImage: "circle")
                        }
                        .padding(.horizontal, 30)
                }
            }
            .animation(.easeOut(duration: 0.2), value: selectedPage)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            Spacer()
            HStack {
                if selectedPage > 0 {
                    Button {
                        if selectedPage > 0 {
                            selectedPage -= 1
                        }
                    } label: {
                        Text("Previous")
                    }
                    .buttonStyle(.bordered)
                    .tint(.pink)
                    Divider()
                        .frame(height: 20)
                        .foregroundColor(.gray)
                    
                }
                
                Button {
                    if selectedPage < lesson.words.count - 1 {
                        selectedPage += 1
                    } else {
                        isPageDeatailActive = true
                    }
                } label: {
                    Text(selectedPage == lesson.words.count - 1 ? "Finish" : "Next")
                }
                .buttonStyle(.borderedProminent)
                
            }
            .padding(.vertical, 20)
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                NavigationLink(destination:  LessonView(lessonViewModel: lessonViewModel, lesson: lesson), isActive: $isPageDeatailActive) {
                    EmptyView()
                }
                .hidden()
                .frame(width: 0, height: 0)
            } else {
                NavigationLink(destination:  LessonViewPC(lessonViewModel: lessonViewModel, lesson: lesson), isActive: $isPageDeatailActive) {
                    EmptyView()
                }
                .hidden()
                .frame(width: 0, height: 0)
            }
            
            
        }
        .navigationTitle(lesson.name)
        .navigationBarItems(trailing: Button(action: {
            isPageDeatailActive = true
        }, label: {
            Text("Finish")
        }))
        .navigationBarItems(trailing:
                                Button(action: {
            showSettingView.toggle()
        }) {
            Image(systemName: "gearshape.fill")
        }
        )
        .sheet(isPresented: $showSettingView, content: {
            SettingsView(presentedAsModal: $showSettingView)
        })
    }
}

