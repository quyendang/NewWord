//
//  HomeView.swift
//  nieng
//
//  Created by Quyen Dang on 14/07/2023.
//

import SwiftUI
import SpriteKit

struct HomeView: View {
    @ObservedObject var lessonViewModel: LessonViewModel
    @State private var isFormViewPresented = false
    @State private var showSettingView = false
    @State private var showText2Speech = false
    @State private var showSummary = false
    @State private var currentLesson: Lesson = Lesson(id: "", name: "", groupId: "", words: [])
    @State private var showEdit = false
    @AppStorage("chrismas") private var chrismas: Bool = true
    
    
    
    
    var body: some View {
        ZStack{
            VStack{
                

                List {
                    if !checkGroups() {
                        ForEach(lessonViewModel.groups) { group in
                            Section(isExpanded: Binding(get: {
                                let index = lessonViewModel.groups.firstIndex(where: { gr in
                                    gr.id == group.id
                                })!
                                return lessonViewModel.isExpands[index]
                            }, set: { newValue in
                                let index = lessonViewModel.groups.firstIndex(where: { gr in
                                    gr.id == group.id
                                })!
                                lessonViewModel.isExpands[index] = newValue
                            })) {
                                ForEach(group.lessons) { lesson in
                                    if UIDevice.current.userInterfaceIdiom == .phone {
                                        NavigationLink(destination: LessonView(lessonViewModel: lessonViewModel, lesson: lesson)) {
                                            Text(lesson.name)
                                                .modifier(HomeViewModifier())
                                                .contextMenu(ContextMenu(menuItems: {
                                                    Button("Delete") {
                                                        lessonViewModel.delete(lesson)
                                                    }
                                                    Button("Edit") {
                                                        showEdit = true
                                                        currentLesson = lesson
                                                    }
                                                }))
                                        }
                                    } else {
                                        NavigationLink(destination: LessonViewPC(lessonViewModel: lessonViewModel, lesson: lesson)) {
                                            Text(lesson.name)
                                                .modifier(HomeViewModifier())
                                                .contextMenu(ContextMenu(menuItems: {
                                                    Button("Delete") {
                                                        lessonViewModel.delete(lesson)
                                                    }
                                                    Button("Edit") {
                                                        showEdit = true
                                                        currentLesson = lesson
                                                    }
                                                }))
                                        }
                                    }
                                    
                                } .onDelete(perform: { indexSet in
                                    lessonViewModel.delete(group.lessons[indexSet.first!])
                                })
                            } header: {
                                Text("\(group.name) (\(group.lessons.count))")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                            }
                        }
                    }
                }
                .listStyle(SidebarListStyle())
                NavigationLink("", destination: LessonPageView(lessonViewModel: lessonViewModel, lesson: currentLesson), isActive: $showSummary)
                .hidden()
            }
            SpriteView(scene: Snow(),
                       options: [.allowsTransparency])
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .isVisible(isVisible: chrismas)
            SpriteView(scene: Snow(),
                       options: [.allowsTransparency])
            .ignoresSafeArea()
            .allowsHitTesting(false)
            .isVisible(isVisible: chrismas)
        }
        .overlay(content: {
            if checkGroups() {
                ContentUnavailableView {
                    Label("Empty Lessons", systemImage: "book")
                } description: {
                    Text("Learn, learn more, learn forever")
                } actions: {
                    Button(action: {
                        isFormViewPresented.toggle()
                    }, label: {
                        Text("Add new Lesson")
                    })
                    .buttonStyle(.bordered)
                    .tint(.pink)
                }
            }
        })
        
        .navigationBarItems(trailing:
                                Button(action: {
            isFormViewPresented.toggle()
        }) {
            Image(systemName: "plus")
        }
        )
        .navigationBarItems(trailing: Button(action: {
            self.showSettingView = true
        }, label: {
            Image(systemName: "gearshape.fill")
        }))
        .navigationBarItems(trailing: Button(action: {
            self.showText2Speech = true
        }, label: {
            Image(systemName: "rectangle.2.swap")
        }))
        
        .sheet(isPresented: $isFormViewPresented) {
            FormView(lessonViewModel: lessonViewModel, isAddLessonView: $isFormViewPresented)
        }
        .sheet(isPresented: $showSettingView, content: {
            SettingsView(presentedAsModal: $showSettingView)
        })
        .sheet(isPresented: $showEdit, content: {
            EditLessonView(lessonViewModel: lessonViewModel, lesson: $currentLesson, isEditLessonView: $showEdit)
        })
        .sheet(isPresented: $showText2Speech) {
            TextToSpeechView()
        }
        .navigationBarTitle("Lesson List")
        .navigationViewStyle(.stack)
        
        .onAppear{
            lessonViewModel.initData()
            
            
            
        }
        
    }
    func delete(lesson: Lesson) {
        lessonViewModel.delete(lesson)
    }
    
    func checkGroups() -> Bool {
        if lessonViewModel.groups.isEmpty {
            return true
        }
        
        // Kiểm tra nếu tất cả các group đều có lessons == 0
        for group in lessonViewModel.groups {
            if group.lessons.isEmpty == false {
                return false
            }
        }
        
        return true
    }
    

}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct HomeViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            content
                
        } else {
            content
                .font(.title)
        }
    }
}
