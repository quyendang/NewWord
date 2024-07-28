//
//  FormView.swift
//  nieng
//
//  Created by Quyen Dang on 14/07/2023.
//

import SwiftUI

struct FormView: View {
    @ObservedObject var lessonViewModel: LessonViewModel
    @State private var lessonName = ""
    @State private var selectedGroup = 0
    @State private var showAddGroupAlert = false
    @State private var newGroupName = ""
    @Binding var isAddLessonView: Bool
    @State private var showEditGroup = false
    @State private var indexGroup = 0
    
    var body: some View {
        NavigationView(content: {
            Form {
                Section(header: Text("Info")) {
                    TextField("Lesson name", text: $lessonName)
                }
                
                Section {
                    Picker(selection: $selectedGroup, label: Text("Group")) {
                        ForEach(0..<lessonViewModel.groups.count, id: \.self) { index in
                            Text(lessonViewModel.groups[index].name)
                                .contextMenu(ContextMenu(menuItems: {
                                    Button("Delete") {
                                        lessonViewModel.delete(lessonViewModel.groups[index])
                                    }
                                    Button("Edit") {
                                        indexGroup = index
                                        showEditGroup = true
                                    }
                                }))
                        }
                        .onDelete(perform: { indexSet in
                            lessonViewModel.delete(lessonViewModel.groups[indexSet.first!])
                        })
                        
                    }.pickerStyle(.inline)
                    Button(action: {
                        showAddGroupAlert = true
                    }) {
                        Text("Add Group")
                    }
                }
                
                Section {
                    Button(action: {
                        let selectedGroup = lessonViewModel.groups[selectedGroup]
                        lessonViewModel.addLesson(to: selectedGroup, name: lessonName)
                        isAddLessonView = false
                    }) {
                        Text("Save")
                    }
                }
            }
            .navigationTitle("Add Lesson")
        })
        
        .alert("Add Group", isPresented: $showAddGroupAlert, actions: {
            TextField("Group name", text: $newGroupName)
            Button("Add", action: {
                if !newGroupName.isEmpty {
                    lessonViewModel.addGroup(newGroupName)
                
                }
            })
            Button("Cancel", role: .cancel, action: {})
        }, message: {
            Text("Please enter your group name.")
        })
        .alert("Edit Group", isPresented: $showEditGroup) {
            TextField("Group name", text: Binding(get: {
                lessonViewModel.groups[indexGroup].name
            }, set: { value in
                lessonViewModel.groups[indexGroup].name = value
            }))
            Button("Save", action: {
                lessonViewModel.editGroup(lessonViewModel.groups[indexGroup])
            })
            Button("Cancel", role: .cancel, action: {})
        } message: {
            Text("Please enter your group name.")
        }
    }
}
//
//struct FormView_Previews: PreviewProvider {
//    static var previews: some View {
//        FormView(viewModel: HomeViewModel())
//    }
//}
