//
//  LessonView.swift
//  nieng
//
//  Created by Quyen Dang on 08/11/2023.
//

import SwiftUI
import FirebaseAuth

struct LessonView: View {
    @ObservedObject var lessonViewModel: LessonViewModel
    var lesson: Lesson
    
    @State private var isAddWordViewPresented = false
    @State private var newWord = Word(id: "", word: "", wordType: "", pronunciation: "", meaning: "", usVoice: "", ukVoice: "", eg: "", eg2: "", time: "0", dfVoice: "", egVoice: "", viVoice: "")
    @State var isHideWord = false
    @State var isHideType = false
    @State var isHideMeaning = false
    @State var isHideEg = false
    @State private var showSettingView = false
    @State private var hiddenWords: Set<Int> = []
    @State private var hiddenMeanings: Set<Int> = []
    @State private var hiddenTypes: Set<Int> = []
    @State private var hiddenEgs: Set<Int> = []
    @State private var exLoadings: Set<Int> = []
    @State private var showDetailWord = false
    @State var selectedIndex = -1
    @State var editMode = false
    
    
    @AppStorage("wordSize2") var wordSize2 = 35.0
    @AppStorage("wordTypeSize2") var wordTypeSize2 = 25.0
    @AppStorage("wordProSize2") var wordProSize2 = 25.0
    @AppStorage("wordMeaningSize2") var wordMeaningSize2 = 25.0
    @AppStorage("wordEgSize2") var wordEgSize2 = 25.0
    @AppStorage("wordDfSize2") var wordDfSize2 = 25.0
    

    @AppStorage("autoHiden") var autoHiden = false
    
    
    @AppStorage("sortList") private var sortList: Int = 0
    @AppStorage("speed") private var speed: Double = 1
    @AppStorage("voiceId") var voiceId = "en-US-Neural2-A/MALE"
    
    var body: some View {
        VStack{
            List {
                ForEach(lesson.words.indices, id: \.self) { index in
                    VStack(alignment: .leading){
                        HStack{
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
                            Toggle(isOn: Binding(
                                get: { hiddenTypes.contains(index) },
                                set: { newValue in toggleHiddenType(index, newValue) }
                            )) {
                                Text(hiddenTypes.contains(index) ? lesson.words[index].wordType.hiddenString : "\(lesson.words[index].wordType)")
                                    .font(.subheadline)
                                    .foregroundStyle(lesson.words[index].wordType.wordColor)
                            }
                            .tint(.primary)
                            .toggleStyle(iOSCheckboxToggleStyle())
                            Spacer()
                            Button(action: {
                                AVPlayerManager.shared.play(url: URL(string: lesson.words[index].usVoice)!)
                            }, label: {
                                HStack{
                                    Image(systemName: "speaker.wave.3.fill")
                                }
                            })
                            .buttonStyle(.bordered)
                            .tint(.pink)
                        }
                        HStack{
                            TextField("", text: Binding(get: {
                                lesson.words[index].pronunciation
                            }, set: { newValue in
                                newValue
                            }))
                            .font(.title2)
                            .textFieldStyle(PlainTextFieldStyle())
                        }
                        if !lesson.words[index].meaning.isEmpty {
                            Toggle(isOn: Binding(
                                get: { hiddenMeanings.contains(index) },
                                set: { newValue in toggleHiddenMeaning(index, newValue) }
                            )) {
                                Text(hiddenMeanings.contains(index) ? lesson.words[index].meaning.hiddenString : "\(lesson.words[index].meaning)")
                            }
                            .tint(.primary)
                            .toggleStyle(iOSCheckboxToggleStyle())
                        }
                        
                        if !lesson.words[index].eg.isEmpty {
                            HStack {
                                Toggle(isOn: Binding(
                                    get: { hiddenEgs.contains(index) },
                                    set: { newValue in toggleHiddenEg(index, newValue) }
                                )) {
                                    Text(hiddenEgs.contains(index) ? lesson.words[index].eg.hiddenString : "\(lesson.words[index].eg)")
                                }
                                .tint(.primary)
                                .toggleStyle(iOSCheckboxToggleStyle())
                                Spacer()
                                Button(action: {
                                    exLoadings.insert(index)
                                    NetWorkManager.shared.synthesizeTextToSpeech(lesson.words[index].eg, voiceId: voiceId) { voiceData in
                                        exLoadings.remove(index)
                                        guard let voiceData = voiceData else { return }
                                        AVPlayerManager.shared.play(voiceData, speed: 1.0)
                                    }
                                
                                }, label: {
                                    if self.exLoadings.contains(index) {
                                        ProgressView()
                                    }else{
                                        Image(systemName: "speaker.wave.3.fill")
                                    }
                                    
                                })
                                .buttonStyle(.bordered)
                                .tint(Color.greenPro)
                            }
                        }
                        
                    }.onTapGesture {
                        self.selectedIndex = index
                        self.showDetailWord = true
                    }
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Edit") {
                            newWord = lesson.words[index]
                            editMode = true
                            isAddWordViewPresented.toggle()
                        }
                    }))
                    
                    
                }
                .onDelete { index in
                    lessonViewModel.delete(in: lesson, word: lesson.words[index.first!])
                }
                .onMove(perform: move)
            }
            Spacer()
            HStack(content: {
                Toggle(isOn: $isHideWord) {
                    Text("Word")
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                Toggle(isOn: $isHideType) {
                    Text("Type")
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                Toggle(isOn: $isHideMeaning) {
                    Text("Meaning")
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                Toggle(isOn: $isHideEg) {
                    Text("Eg")
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                
            })
            .padding()
        }
        .listStyle(.plain)
        .navigationBarItems(trailing:
                                Button(action: {
            editMode = false
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
        //        .navigationBarItems(trailing:
        //                                Button(action: {
        //            isAddWordViewPresented.toggle()
        //        }) {
        //            Text("Edit")
        //        }
        //        )
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
        .sheet(isPresented: $showDetailWord, content: {
            WordPopup(isPresented: $showDetailWord, selectedPage: $selectedIndex, delete: {
                
            }, lessonViewModel: lessonViewModel, lesson: lesson)
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
        .onChange(of: isHideEg, { _, _ in
            toggleAllHiddenEgs()
        })
        .onChange(of: selectedIndex, { _, _ in
            showDetailWord = true
        })
        .onAppear {
            isHideWord = autoHiden
            isHideType = autoHiden
            isHideMeaning = autoHiden
            isHideEg = autoHiden
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        //users.move(fromOffsets: source, toOffset: destination)
        lessonViewModel.swap(to: lesson, word1: lesson.words[source.first!], word2: lesson.words[destination])
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

extension LessonView {
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
    
    func toggleHiddenEg(_ index: Int, _ newValue: Bool) {
        if newValue {
            hiddenEgs.insert(index)
        } else {
            hiddenEgs.remove(index)
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
    
    func toggleAllHiddenEgs() {
        if hiddenEgs.isEmpty {
            hiddenEgs = Set(lesson.words.indices)
        } else {
            hiddenEgs.removeAll()
        }
    }
}

