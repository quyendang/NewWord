//
//  AddWordView.swift
//  nieng
//
//  Created by Quyen Dang on 08/11/2023.
//

import SwiftUI
import TTProgressHUD
import Promises
import Animatable
import PromiseKit

struct AddWordView: View {
    @ObservedObject var lessonViewModel: LessonViewModel
    var lesson: Lesson
    @Binding var newWord: Word
    @Binding var isAddWordViewPresented: Bool
    @Binding var editMode: Bool
    @State private var showingUSActivity = false
    @State private var showingEgActivity = false
    @State private var selectedType = ""
    @State private var showError = false
    @State private var popupWordsPresented = false
    @FocusState var focused: Bool?
    
    @State var editing: Bool = false
    @State var vOffset: CGFloat = 5
    @State var hOffset: CGFloat = 0
    
    
    @State private var isDFLoading = false
    @State private var isEGLoading = false
    @State private var showErrorMess = false
    @State private var errMess = ""
    @AppStorage("voiceId") var voiceId = "en-US-Neural2-A/MALE"
    @AppStorage("ai") private var ai: Int = 0
    @AppStorage("claude_df") var claude_df = "Write a definition for the word: ***,in less than 100 characters"
    @AppStorage("claude_eg") var claude_eg = "Write a example for the word: ***,in less than 100 characters"
    @AppStorage("claude_trans") var claude_trans = "Translate word: *** to Vietnamese"
    @AppStorage("claude_pron") var claude_pron = "Phiên âm của từ *** trong tiếng Anh của Mỹ được viết như thế nào?"
    @AppStorage("claude_type") var claude_type = "Từ *** trong tiếng Anh cơ bản thuộc loại từ nào, ghi bằng Tiếng Anh"
    
    @AppStorage("useGoogleVoice") var useGoogleVoice = true
    
    
    @State var hudConfig = TTProgressHUDConfig(type: .error,title: "Error",shouldAutoHide: true, autoHideInterval: 1)
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                HStack(content: {
                    ZStack(alignment: .trailing) {
                        TextField("Word", text:  $newWord.word, onEditingChanged: { edit in
                                    self.editing = edit})
                        .focused($focused, equals: true)
                            .onSubmit {
                                search()
                            }
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .isVisible(isVisible: !newWord.word.isEmpty)
                            .onTapGesture {
                                newWord.word = ""
                            }
                    }
                    
                    
                        
                    Button(action: {
                        search()
                    }, label: {
                        if lessonViewModel.isLoading {
                            ProgressView()
                        } else {
                            Image(systemName: "speaker.wave.3.fill")
                                .symbolEffect(.variableColor, value: self.showingUSActivity)
                        }
                    })
                    .buttonStyle(.bordered)
                    .tint(.pink)
                    .keyboardShortcut(.defaultAction)
                })
                Divider()
                ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
                    VStack{
                        HStack {
                            ClearableTextField("Type", text: $newWord.wordType)
                            Button(action: {
                                NetWorkManager.shared.AI(newWord.word, promt: claude_type, aiType: convertToAIType(from: ai)!) { response in
                                    guard let wordType = response else {
                                        return
                                    }
                                    newWord.wordType = wordType
                                }
                            }) {
                                HStack {
                                    Text("\(ai == 0 ? "C": ai == 1 ? "GPT": "G" )-AI")
                                }
                            }
                            .foregroundColor(ai == 0 ? Color.orangePro: ai == 1 ? Color.greenPro: Color.purple)
                            .buttonStyle(.bordered)
                        }
                        
                        Divider()
                        HStack(content: {
                            ClearableTextField("Pronunciation", text: $newWord.pronunciation)
                            Button(action: {
                                NetWorkManager.shared.AI(newWord.word, promt: claude_pron, aiType: convertToAIType(from: ai)!) { response in
                                    guard let pronunciation = response else {
                                        return
                                    }
                                    newWord.pronunciation = pronunciation.contains("/") ? pronunciation : "/\(pronunciation)/"
                                }
                            }) {
                                HStack {
                                    Text("\(ai == 0 ? "C": ai == 1 ? "GPT": "G" )-AI")
                                }
                            }
                            .foregroundColor(ai == 0 ? Color.orangePro: ai == 1 ? Color.greenPro: Color.purple)
                            .buttonStyle(.bordered)
                        })
                        
                        Divider()
                        HStack{
                            ClearableTextField("Vietnamese", text: $newWord.eg)
                            Button("\(ai == 0 ? "C": ai == 1 ? "GPT": "G" )-AI") {
                                NetWorkManager.shared.AI(newWord.word, promt: claude_trans, aiType: convertToAIType(from: ai)!) { response in
                                    guard let vn = response else {
                                        return
                                    }
                                    newWord.eg = vn
                                }
                            }
                            .foregroundColor(ai == 0 ? Color.orangePro: ai == 1 ? Color.greenPro: Color.purple)
                            .buttonStyle(.bordered)
                            Button(action: {
                                NetWorkManager.shared.synthesizeTextToSpeech(newWord.eg, voiceId: "vi-VN-Standard-D/MALE") { voiceData in
                                    guard let voiceData = voiceData else {
                                        
                                        showError = true
                                        return
                                    }
                                    AVPlayerManager.shared.play(voiceData, speed: 1.0)
                                    
                                    /// Set Meaning Sound
                                    newWord.viVoice = voiceData
                                    
                                }
                            }) {
                                HStack(content: {
                                    Text("VI")
                                    Image(systemName: "speaker.wave.3.fill")
                                })
                            }
                            .buttonStyle(.bordered)
                            .tint(.yellow)
                        }
                        Divider()
                        Picker("Voice",
                               selection: $voiceId) {
                            Text("en-US-Neural2-A/MALE")
                                .tag("en-US-Neural2-A/MALE")
                            Text("en-US-Neural2-C/FEMALE")
                                .tag("en-US-Neural2-C/FEMALE")
                            Text("en-US-Neural2-D/MALE")
                                .tag("en-US-Neural2-D/MALE")
                            Text("en-US-Neural2-E/FEMALE")
                                .tag("en-US-Neural2-E/FEMALE")
                            Text("en-US-News-K/FEMALE")
                                .tag("en-US-News-K/FEMALE")
                            Text("en-US-News-M/MALE")
                                .tag("en-US-News-M/MALE")
                            Text("en-US-Standard-A/MALE")
                                .tag("en-US-Standard-A/MALE")
                            Text("en-US-Standard-B/MALE")
                                .tag("en-US-Standard-B/MALE")
                            Text("en-US-Standard-C/FEMALE")
                                .tag("en-US-Standard-C/FEMALE")
                            Text("en-US-Standard-D/MALE")
                                .tag("en-US-Standard-D/MALE")
                        }
                        Divider()
                        HStack(content: {
                            ClearableTextField("Definition", text: $newWord.meaning)
                            Button(action: {
                                NetWorkManager.shared.AI(newWord.word, promt: claude_df, aiType: convertToAIType(from: ai)!) { response in
                                    guard let df = response else {
                                        return
                                    }
                                    newWord.meaning = df
                                }
                            }) {
                                HStack {
                                    Text("\(ai == 0 ? "C": ai == 1 ? "GPT": "G" )-AI")
                                }
                            }
                            .foregroundColor(ai == 0 ? Color.orangePro: ai == 1 ? Color.greenPro: Color.purple)
                            .buttonStyle(.bordered)
                            
                            Button {
                                if !newWord.meaning.isEmpty {
                                    isDFLoading = true
                                    
                                    NetWorkManager.shared.synthesizeTextToSpeech(newWord.meaning, voiceId: voiceId) { voiceData in
                                        isDFLoading = false
                                        guard let voiceData = voiceData else {
                                            
                                            showError = true
                                            return
                                        }
                                        AVPlayerManager.shared.play(voiceData, speed: 1.0)
                                        
                                        /// Set Meaning Sound
                                        newWord.dfVoice = voiceData
                                        
                                    }                            }
                            } label: {
                                Image(systemName: "speaker.wave.3.fill")
                                    .symbolEffect(.variableColor, value: self.isDFLoading)
                            }
                            .buttonStyle(.bordered)
                            .tint(.pink)
                            .keyboardShortcut(.defaultAction)
                        })
                        Divider()
                        HStack(content: {
                            ClearableTextField("Eg", text: $newWord.eg2)
                            Button(action: {
                                NetWorkManager.shared.AI(newWord.word, promt: claude_eg, aiType: convertToAIType(from: ai)!) { response in
                                    guard let eg = response else {
                                        return
                                    }
                                    newWord.eg2 = eg
                                }
                            }) {
                                HStack {
                                    Text("\(ai == 0 ? "C": ai == 1 ? "GPT": "G" )-AI")
                                }
                            }
                            .foregroundColor(ai == 0 ? Color.orangePro: ai == 1 ? Color.greenPro: Color.purple)
                            .buttonStyle(.bordered)
                            Button {
                                if !newWord.eg2.isEmpty {
                                    isEGLoading = true
                                    
                                    NetWorkManager.shared.synthesizeTextToSpeech(newWord.eg2, voiceId: voiceId) { voiceData in
                                        isEGLoading = false
                                        guard let voiceData = voiceData else {
                                            
                                            showError = true
                                            return
                                        }
                                        AVPlayerManager.shared.play(voiceData, speed: 1.0)
                                        newWord.egVoice = voiceData
                                    }
                                }
                            } label: {
                                Image(systemName: "speaker.wave.3.fill")
                                    .symbolEffect(.variableColor, value: self.isEGLoading)
                            }
                            .buttonStyle(.bordered)
                            .tint(.pink)
                            .keyboardShortcut(.defaultAction)
                        })
                    }
                    //SuggestionTextFieldMenu(editing: $editing, text: $newWord.word, verticalOffset: vOffset, horizontalOffset: hOffset)
//                    SuggestionTextFieldMenu(words: lessonViewModel.words, editing: $editing, inputText: $newWord.word, newWord: $newWord, verticalOffset: vOffset, horizontalOffset: hOffset, chosse: { w in
//                        newWord.word = w.word
//                        newWord.wordType = w.wordType
//                        newWord.pronunciation = w.pronunciation
//                        newWord.usVoice = w.usVoice
//                        newWord.ukVoice = w.ukVoice
//                        newWord.meaning = w.meaning
//                        newWord.eg2 = w.eg2
//                        newWord.eg = w.eg
//                    })
                }
                Spacer()
                HStack{
                    Text("Command + Shift + 1")
                        .foregroundColor(.blue)
                    Text("để đổi AI nhanh!")
                }
                HStack{
                    Text("Command + Enter")
                        .foregroundColor(.blue)
                    Text("để Save!")
                }
                Button("") {
                    if ai == 0 {
                        ai = 1
                    } else if ai == 1 {
                        ai = 2
                    } else {
                        ai = 0
                    }
                }
                .keyboardShortcut("1", modifiers: [.command, .shift])
                Text("Have bug!")
                if editMode {
                    Button(action: {
                        lessonViewModel.editWord(to: lesson, word: newWord)
                        newWord = Word(id: "", word: "", wordType: "", pronunciation: "", meaning: "", usVoice: "", ukVoice: "", eg: "", eg2: "", time: "0", dfVoice: "", egVoice: "", viVoice: "")
                        isAddWordViewPresented = false
                    }) {
                        Text("Save")
                    }
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                }
                else {
                    Button(action: {
                        if newWord.word.isEmpty {
                            showErrorMess = true
                            errMess = "Word can't be empty!"
                        } else {
                            newWord.time = "\(Date().milliseconds)"
                            lessonViewModel.addWord(to: lesson, word: newWord)
                            newWord = Word(id: "", word: "", wordType: "", pronunciation: "", meaning: "", usVoice: "", ukVoice: "", eg: "", eg2: "", time: "0", dfVoice: "", egVoice: "", viVoice: "")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.focused = true
                            }
                        }
                    }) {
                        Text("Add")
                    }
                    .controlSize(.large)
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.return, modifiers: [.command])
                }
                
            }
            .padding(20)
            .alert(errMess, isPresented: $showErrorMess) {
                Button("OK", role: .cancel) { }
            }
            .overlay(content: {
                TTProgressHUD($showError, config: hudConfig)
            })
            .navigationBarTitle(editMode ? "Edit": "Add new word")
        }
    }
    
    func search() {
        lessonViewModel.isLoading = true
        NetWorkManager.shared.synthesizeTextToSpeech(newWord.word, voiceId: voiceId) { voiceData in
            NetWorkManager.shared.fetchWordInfo(newWord.word) { word in
                self.lessonViewModel.isLoading = false
                if let word = word, !word.usVoice.isEmpty {
                    if editMode {
                        self.newWord.wordType = word.wordType
                        self.newWord.pronunciation = word.pronunciation
                        self.newWord.usVoice = word.usVoice
                        self.newWord.ukVoice = word.ukVoice
                        if useGoogleVoice, let voiceData = voiceData {
                            self.newWord.usVoice = voiceData
                            self.newWord.ukVoice = voiceData
                            AVPlayerManager.shared.play(voiceData, speed: 1.0)
                        } else {
                            AVPlayerManager.shared.play(url: URL(string: word.usVoice)!)
                        }
                    } else {
                        self.newWord = word
                        if useGoogleVoice, let voiceData = voiceData {
                            self.newWord.usVoice = voiceData
                            self.newWord.ukVoice = voiceData
                            AVPlayerManager.shared.play(voiceData, speed: 1.0)
                        } else {
                            AVPlayerManager.shared.play(url: URL(string: word.usVoice)!)
                        }
                    }
                    self.showingUSActivity.toggle()
                    NetWorkManager.shared.translateText(newWord.word) { transText in
                        guard let transText = transText else {return}
                        self.newWord.eg = transText
                    }
                    
                    NetWorkManager.shared.AI(newWord.word, promt: claude_df, aiType: convertToAIType(from: ai)!) { response in
                        guard let df = response else {
                            return
                        }
                        newWord.meaning = df
                    }
                    NetWorkManager.shared.AI(newWord.word, promt: claude_eg, aiType: convertToAIType(from: ai)!) { response in
                        guard let eg = response else {
                            return
                        }
                        newWord.eg2 = eg
                    }
                } else
                {
                    
                    DispatchQueue.main.async {
                        lessonViewModel.isLoading = false
                        newWord.wordType = word?.wordType ?? ""
                        newWord.pronunciation = word?.pronunciation ?? ""
                        
                    }
                    
                    if let voiceData = voiceData {
                        AVPlayerManager.shared.play(voiceData, speed: 1.0)
                        self.newWord.time = editMode ? self.newWord.time : "\(Date().milliseconds)"
                        self.newWord.usVoice = voiceData
                        self.newWord.ukVoice = voiceData
                    }
                    
                    NetWorkManager.shared.translateText(newWord.word) { transText in
                        
                        guard let transText = transText else {return}
                        self.newWord.eg = transText
                    }
                }
                
            }
        }
        
        
    }
}

