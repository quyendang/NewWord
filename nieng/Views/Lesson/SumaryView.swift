//
//  SumaryView.swift
//  nieng
//
//  Created by Quyen Dang on 14/11/2023.
//

import SwiftUI
import FirebaseAuth

struct SumaryView: View {
    @ObservedObject var lessonViewModel: LessonViewModel
    var lesson: Lesson
    
    @State private var isAddWordViewPresented = false
    @State private var newWord = Word(id: "", word: "", wordType: "", pronunciation: "", meaning: "", usVoice: "", ukVoice: "", eg: "", eg2: "", time: "0", dfVoice: "", egVoice: "", viVoice: "")
    @State var isHideWord = false
    @State var isHideType = false
    @State var isHideMeaning = false
    @State var isHidePron = false
    @State private var showSettingView = false
    
    @State private var hiddenWords: Set<Int> = []
    @State private var hiddenMeanings: Set<Int> = []
    @State private var hiddenTypes: Set<Int> = []
    @State private var hiddenPronunciations: Set<Int> = []
    @State var editMode = false
    var body: some View {
        ScrollView(.vertical){
            LazyVGrid(columns: [
                GridItem(.fixed(50), spacing: 16),
                GridItem(.flexible(), spacing: 16),
                GridItem(.fixed(100), spacing: 16),
                GridItem(.fixed(200), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                Text("*").fontWeight(.bold)
                Toggle(isOn: $isHideWord) {
                    Text("Word")
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                .frame(minWidth: 0, maxWidth: .infinity / 2, alignment: .leading)
                Toggle(isOn: $isHideType) {
                    Text("Type")
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                .frame(minWidth: 0, maxWidth: .infinity / 8, alignment: .leading)
                Toggle(isOn: $isHidePron) {
                    Text("Pron")
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                .frame(minWidth: 0, maxWidth: .infinity / 2, alignment: .leading)
                Toggle(isOn: $isHideMeaning) {
                    Text("Meaning")
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                .frame(minWidth: 0, maxWidth: .infinity * 2, alignment: .leading)
                ForEach(lesson.words.indices, id: \.self) { index in
                    Text("\(index + 1)")
                        .font(.title)
                    HStack(content: {
                        Toggle(isOn: Binding(
                            get: { hiddenWords.contains(index) },
                            set: { newValue in toggleHiddenWord(index, newValue) }
                        )) {
                            Text(hiddenWords.contains(index) ? lesson.words[index].word.hiddenString : "\(lesson.words[index].word)")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .tint(.primary)
                        .toggleStyle(iOSCheckboxToggleStyle())
                        Button(action: {
                            AVPlayerManager.shared.play(url: URL(string: lesson.words[index].usVoice)!)
                        }, label: {
                            HStack{
                                Image(systemName: "speaker.wave.3.fill")
                            }
                        })
                        .buttonStyle(.bordered)
                        .tint(.pink)
                    })
                    .frame(minWidth: 0, maxWidth: .infinity / 2, alignment: .leading)
                    Toggle(isOn: Binding(
                        get: { hiddenTypes.contains(index) },
                        set: { newValue in toggleHiddenType(index, newValue) }
                    )) {
                        Text(hiddenTypes.contains(index) ? lesson.words[index].wordType.hiddenString : "\(lesson.words[index].wordType)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .tint(.primary)
                    .toggleStyle(iOSCheckboxToggleStyle())
                    .frame(minWidth: 0, maxWidth: .infinity / 8, alignment: .leading)
                    TextField("", text: Binding(get: {
                        lesson.words[index].pronunciation
                    }, set: { newValue in
                        newValue
                    }))
                        .font(.title2)
                        .textFieldStyle(PlainTextFieldStyle())
                        .frame(minWidth: 0, maxWidth: .infinity / 2, alignment: .leading)
                    Toggle(isOn: Binding(
                        get: { hiddenMeanings.contains(index) },
                        set: { newValue in toggleHiddenMeaning(index, newValue) }
                    )) {
                        Text(hiddenMeanings.contains(index) ? lesson.words[index].meaning.hiddenString : "\(lesson.words[index].meaning)")
                    }
                    .tint(.primary)
                    .toggleStyle(iOSCheckboxToggleStyle())
                    .frame(minWidth: 0, maxWidth: .infinity * 2, alignment: .leading)
                }
            }
            .padding(.horizontal)
            Spacer()
        }
        .navigationBarItems(trailing:
                                Button(action: {
            isAddWordViewPresented.toggle()
        }) {
            Image(systemName: "plus")
        }
        )
        .navigationBarItems(trailing:
                                Button(action: {
            showSettingView.toggle()
        }) {
            Image(systemName: "gearshape.fill")
        }
        )
        .navigationBarItems(trailing:
                                Button(action: {
            isAddWordViewPresented.toggle()
        }) {
            Text("Edit")
        }
        )
        .navigationBarItems(trailing: Button(action: actionSheet, label: {
            Image(systemName: "square.and.arrow.up")
        }))
        
        .navigationBarTitle(lesson.name)
        .sheet(isPresented: $isAddWordViewPresented) {
            AddWordView(lessonViewModel: lessonViewModel, lesson: lesson, newWord: $newWord, isAddWordViewPresented: $isAddWordViewPresented, editMode: $editMode)
        }
        .sheet(isPresented: $showSettingView, content: {
            SettingsView(presentedAsModal: $showSettingView)
        })
        .onChange(of: isHideWord, { _, _ in
            toggleAllHiddenWords()
        })
        .onChange(of: isHideMeaning, { _, _ in
            toggleAllHiddenMeanings()
        })
        .onChange(of: isHideType, { _, _ in
            toggleAllHiddenTypes()
        })
        .onChange(of: isHidePron, { _, _ in
            toggleAllHiddenPros()
        })
        .onAppear {
            
        }
    }
    
    func actionSheet() {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        NetWorkManager.shared.shortenURL("https://lopthaybinh.site/?userid=\(userID)&groupid=\(lesson.groupId)&lessonid=\(lesson.id)") { url in
            guard let urlShare = url else {return}
            DispatchQueue.main.async {
                let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
            }
            
        }
        
    }
}

extension SumaryView {
    func toggleHiddenWord(_ index: Int, _ newValue: Bool) {
        if newValue {
            hiddenWords.insert(index)
        } else {
            hiddenWords.remove(index)
        }
    }
    
    func toggleHiddenMeaning(_ index: Int, _ newValue: Bool) {
        if newValue {
            hiddenMeanings.insert(index)
        } else {
            hiddenMeanings.remove(index)
        }
    }
    
    func toggleHiddenType(_ index: Int, _ newValue: Bool) {
        if newValue {
            hiddenTypes.insert(index)
        } else {
            hiddenTypes.remove(index)
        }
    }
    
    func toggleHiddenPro(_ index: Int, _ newValue: Bool) {
        if newValue {
            hiddenPronunciations.insert(index)
        } else {
            hiddenPronunciations.remove(index)
        }
    }
    
    func toggleAllHiddenWords() {
        if hiddenWords.isEmpty {
            hiddenWords = Set(lesson.words.indices)
        } else {
            hiddenWords.removeAll()
        }
    }
    
    func toggleAllHiddenMeanings() {
        if hiddenMeanings.isEmpty {
            hiddenMeanings = Set(lesson.words.indices)
        } else {
            hiddenMeanings.removeAll()
        }
    }
    
    func toggleAllHiddenTypes() {
        if hiddenTypes.isEmpty {
            hiddenTypes = Set(lesson.words.indices)
        } else {
            hiddenTypes.removeAll()
        }
    }
    
    func toggleAllHiddenPros() {
        if hiddenPronunciations.isEmpty {
            hiddenPronunciations = Set(lesson.words.indices)
        } else {
            hiddenPronunciations.removeAll()
        }
    }
}
