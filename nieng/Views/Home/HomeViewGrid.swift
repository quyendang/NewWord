//
//  HomeView.swift
//  nieng
//
//  Created by Quyen Dang on 14/07/2023.
//

import SwiftUI
import SpriteKit

struct HomeViewGrid: View {
    @State private var groupSelected: Group?
    
    @ObservedObject var lessonViewModel: LessonViewModel
    @State private var isFormViewPresented = false
    @State private var showSettingView = false
    @State private var showText2Speech = false
    @State private var showSummary = false
    @State private var currentLesson: Lesson = Lesson(id: "", name: "", groupId: "", words: [])
    @State private var showEdit = false
    @AppStorage("chrismas") private var chrismas: Bool = true
    @State private var selection: Group?
    
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 300, maximum: 400)),
    ]
    
    var body: some View {
        
        NavigationSplitView {
            List(lessonViewModel.groups, selection: $selection) { group in
                NavigationLink(value: group) {
                    HStack(content: {
                        Image(systemName: "rectangle.3.group")
                        Text(group.name)
                            .font(.headline)
                    })
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Group")
            
        } detail: {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .leading, spacing: 20, pinnedViews: [.sectionHeaders, .sectionFooters]) {
                    if let selection {
                        ForEach(selection.lessons) { lesson in
                            NavigationLink(destination: LessonViewPC(lessonViewModel: lessonViewModel, lesson: lesson)) {
                                BookView(lesson: lesson)
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
                            
                        } .onDelete(perform: { indexSet in
                            //lessonViewModel.delete(group.lessons[indexSet.first!])
                        })
                    } else {
                        EmptyView()
                    }
                }
                .padding()
            }
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

struct HomeViewGrid_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


