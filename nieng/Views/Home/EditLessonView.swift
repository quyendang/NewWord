//
//  EditLessonView.swift
//  Học Từ Mới
//
//  Created by Quyen Dang on 22/11/2023.
//

import SwiftUI

struct EditLessonView: View {
    @ObservedObject var lessonViewModel: LessonViewModel
    @Binding var lesson: Lesson
    @Binding var isEditLessonView: Bool
    @State private var selectedGroup = 0
    @State private var showAddGroupAlert = false
    @State private var newGroupName = ""
    @State private var showEditGroup = false
    @State private var indexGroup = 0
    var body: some View {
        NavigationView(content: {
            Form(content: {
                Section(header: Text("Info")) {
                    TextField("Lesson name", text: $lesson.name)
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
                        isEditLessonView = false
                        lessonViewModel.editLesson(lesson, groupId: selectedGroup.id)
                    }) {
                        Text("Done")
                    }
                }
            })
            .navigationTitle("Edit Lesson")
        })
        
        .onAppear{
            selectedGroup = lessonViewModel.groups.firstIndex(where: { gr in
                gr.id == lesson.groupId
            })!
        }
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
