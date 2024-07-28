//
//  LessonView.swift
//  nieng
//
//  Created by Quyen Dang on 08/11/2023.
//

import SwiftUI
import FirebaseAuth
import PopupView
import SpriteKit
import TTProgressHUD
struct LessonViewPC: View {
    @ObservedObject var lessonViewModel: LessonViewModel
    var lesson: Lesson
    
    @State private var isAddWordViewPresented = false
    @State private var newWord = Word(id: "", word: "", wordType: "", pronunciation: "", meaning: "", usVoice: "", ukVoice: "", eg: "", eg2: "", time: "0", dfVoice: "", egVoice: "", viVoice: "")
    @State var isHideWord = false
    @State var isHideType = false
    @State var isHideMeaning = false
    @State var isHideEg = false
    @State var isHidePro = false
    @State private var showSettingView = false
    @State private var hiddenWords: Set<Int> = []
    @State private var hiddenMeanings: Set<Int> = []
    @State private var hiddenTypes: Set<Int> = []
    @State private var hiddenEgs: Set<Int> = []
    @State private var hiddenPros: Set<Int> = []
    
    
    @State private var exLoadings: Set<Int> = []
    @State private var wordLoadings: Set<Int> = []
    @State private var showDetailWord = false
    @State var selectedIndex = -1
    @State var highLineIndex = -2
    @State var editMode = false
    @State var isAToZ = false
    @State var showShare = false
    
    @State private var fontSize = 32.0
    @State var swapEnable = false
    @AppStorage("wordSize2") var wordSize2 = 35.0
    @AppStorage("wordTypeSize2") var wordTypeSize2 = 25.0
    @AppStorage("wordProSize2") var wordProSize2 = 25.0
    @AppStorage("wordMeaningSize2") var wordMeaningSize2 = 25.0
    @AppStorage("wordEgSize2") var wordEgSize2 = 25.0
    @AppStorage("wordDfSize2") var wordDfSize2 = 25.0
    

    @State var hudConfig = TTProgressHUDConfig(type: .success ,title: "Copied!",shouldAutoHide: true, autoHideInterval: 1)
    @State var showCopied = false
    @AppStorage("appearanceSelection") private var appearanceSelection: Int = 0
    @AppStorage("autoHiden") var autoHiden = false
    
    @AppStorage("speed") private var speed: Double = 1
    @AppStorage("voiceId") var voiceId = "en-US-Neural2-A/MALE"
    @AppStorage("useGoogleVoice") var useGoogleVoice = true
    
    var body: some View {
        ZStack{
            Image("bg")
                .resizable()
                .ignoresSafeArea()
                .isVisible(isVisible: appearanceSelection == 1)
            ScrollView(.vertical, content: {
                Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 15) {
                    if lesson.words.count > 0 {
                        GridRow(alignment: .firstTextBaseline) {
                            Text("*")
                                .foregroundColor(.secondary)
                                .font(.system(size: wordMeaningSize2))
                                .fontWeight(.bold)
                            Toggle(isOn: $isHideWord) {
                                HStack{
                                    Text("Word")
                                        .foregroundColor(.secondary)
                                        .font(.system(size: wordMeaningSize2))
                                        .fontWeight(.bold)
                                    Button(action: {
                                        isAToZ.toggle()
                                    }, label: {
                                        Image(systemName: "arrowtriangle.down.fill")
                                    })
                                    .controlSize(.large)
                                    .tint(isAToZ ? .blue: .white)
                                }
                                
                            }
                            .toggleStyle(iOSCheckboxToggleStyle())
                            Toggle(isOn: $isHideType) {
                                Text("Type")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: wordMeaningSize2))
                                    .fontWeight(.bold)
                            }
                            .toggleStyle(iOSCheckboxToggleStyle())
                            
                            Toggle(isOn: $isHidePro) {
                                Text("IPA")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: wordMeaningSize2))
                                    .fontWeight(.bold)
                            }
                            .toggleStyle(iOSCheckboxToggleStyle())
                            
                            Toggle(isOn: $isHideMeaning) {
                                Text("Definition")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: wordMeaningSize2))
                                    .fontWeight(.bold)
                            }
                            .toggleStyle(iOSCheckboxToggleStyle())
                            
                            Toggle(isOn: $isHideEg) {
                                Text("Vietnamese")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: wordMeaningSize2))
                                    .fontWeight(.bold)
                            }
                            .toggleStyle(iOSCheckboxToggleStyle())
                            
                            
                        }
                        GridRow {
                            Divider()
                                .gridCellColumns(6)
                            //                            Rectangle()
                            //                                .fill(.secondary.opacity(0.5))
                            //                                .frame(height: 1)
                            //                                .gridCellColumns(7)
                            //                            .gridCellUnsizedAxes([.horizontal])
                        }
                    }
                    
                    ForEach(lesson.words.indices, id: \.self) { index in
                        GridRow(alignment: .firstTextBaseline) {
                            HStack {
                                Text("\(index + 1)")
                                    .font(.system(size: wordMeaningSize2))
                                Divider()
                            }
                            
                            HStack {
                                Toggle(isOn: Binding(
                                    get: { hiddenWords.contains(index) },
                                    set: { newValue in toggleHiddenWord(index, newValue) }
                                )) {
                                    Text(hiddenWords.contains(index) ? lesson.words[index].word.hiddenString : "\(lesson.words[index].word)")
                                        .font(.system(size: wordSize2))
                                        .fontWeight(.bold)

                                }
                                .tint(.primary)
                                .toggleStyle(iOSCheckboxToggleStyle())
                                Spacer()
                                Button(action: {
                                    highLineIndex = index
                                    if lesson.words[index].usVoice.isEmpty {
                                        wordLoadings.insert(index)
                                        NetWorkManager.shared.synthesizeTextToSpeech(lesson.words[index].word, voiceId: voiceId) { voiceData in
                                            wordLoadings.remove(index)
                                            guard let voiceData = voiceData else { return}
                                            AVPlayerManager.shared.play(voiceData, speed: 1.0)
                                            var newWord = lesson.words[index]
                                            newWord.usVoice = voiceData
                                            newWord.ukVoice = voiceData
                                            lessonViewModel.editWord(to: lesson, word: newWord)
                                        }
                                    } else {
                                        if lesson.words[index].usVoice.contains("http") {
                                            if useGoogleVoice {
                                                wordLoadings.insert(index)
                                                NetWorkManager.shared.synthesizeTextToSpeech(lesson.words[index].word, voiceId: voiceId) { voiceData in
                                                    wordLoadings.remove(index)
                                                    guard let voiceData = voiceData else { return}
                                                    AVPlayerManager.shared.play(voiceData, speed: 1.0)
                                                    var newWord = lesson.words[index]
                                                    newWord.usVoice = voiceData
                                                    newWord.ukVoice = voiceData
                                                    lessonViewModel.editWord(to: lesson, word: newWord)
                                                }
                                            } else {
                                                AVPlayerManager.shared.play(url: URL(string: lesson.words[index].usVoice)!)
                                            }
                                        } else {
                                            AVPlayerManager.shared.play(lesson.words[index].usVoice, speed: 1.0)
                                        }
                                    }
                                    
                                }, label: {
                                    HStack{
                                        if self.wordLoadings.contains(index) {
                                            ProgressView()
                                        }else{
                                            Image(systemName: "speaker.wave.3.fill")
                                        }
                                    }
                                })
                                .buttonStyle(.bordered)
                                .tint(.pink)
                                Divider()
                            }
                            .frame(maxWidth: 400)
                            HStack {
                                Toggle(isOn: Binding(
                                    get: { hiddenTypes.contains(index) },
                                    set: { newValue in toggleHiddenType(index, newValue) }
                                )) {
                                    Text(hiddenTypes.contains(index) ? lesson.words[index].wordType.hiddenString : "\(lesson.words[index].wordType)")
                                        .font(.system(size: wordTypeSize2))
                                        .foregroundStyle(lesson.words[index].wordType.wordColor)
                                }
                                .tint(.primary)
                                .toggleStyle(iOSCheckboxToggleStyle())
                                Spacer()
                                Divider()
                            }
                            .frame(maxWidth: 150)
                            HStack{
                                Toggle(isOn: Binding(get: {
                                    hiddenPros.contains(index)
                                }, set: { newValue in
                                    toggleHiddenPro(index, newValue)
                                })) {
                                    TextField("", text: Binding(get: {
                                        hiddenPros.contains(index) ? lesson.words[index].pronunciation.hiddenString : "\(lesson.words[index].pronunciation)"
                                    }, set: { newValue in
                                        newValue
                                    }))
                                    .frame(maxWidth: 190)
                                    .font(.system(size: wordProSize2))
                                    .textFieldStyle(PlainTextFieldStyle())
                                }
                                .toggleStyle(iOSCheckboxToggleStyle())
                                Divider()
                            }
                            .frame(maxWidth: 180)
                            HStack{
                                Toggle(isOn: Binding(
                                    get: { hiddenMeanings.contains(index) },
                                    set: { newValue in toggleHiddenMeaning(index, newValue) }
                                )) {
                                    
                                    let attributedString = makeAttributedString(for: hiddenMeanings.contains(index) ? lesson.words[index].meaning.hiddenString : "\(lesson.words[index].meaning)", highlighting: lesson.words[index].word, color: lesson.words[index].wordType.wordColor)
                                    Text(attributedString)
                                        .font(.system(size: wordDfSize2))
                                        .textSelection(.enabled)
                                    
                                    //                                    Text(hiddenMeanings.contains(index) ? lesson.words[index].meaning.hiddenString : "\(lesson.words[index].meaning)")
                                    //                                        .font(.system(size: wordOther))
                                }
                                .tint(.primary)
                                .toggleStyle(iOSCheckboxToggleStyle())
                                Spacer()
                                Button(action: {
                                    highLineIndex = index
                                    if lesson.words[index].dfVoice.isEmpty {
                                        exLoadings.insert(index)
                                        NetWorkManager.shared.synthesizeTextToSpeech(lesson.words[index].meaning, voiceId: voiceId) { voiceData in
                                            exLoadings.remove(index)
                                            guard let voiceData = voiceData else { return }
                                            AVPlayerManager.shared.play(voiceData, speed: Float(speed))
                                        }
                                    }
                                    else {
                                        if lesson.words[index].dfVoice.contains("http"){
                                            AVPlayerManager.shared.play(url: URL(string: lesson.words[index].dfVoice)!)
                                        } else {
                                            AVPlayerManager.shared.play(lesson.words[index].dfVoice, speed: Float(speed))
                                        }
                                    }
                                }, label: {
                                    HStack{
                                        if self.exLoadings.contains(index) {
                                            ProgressView()
                                        }else{
                                            Image(systemName: "speaker.wave.3.fill")
                                        }
                                        
                                        
                                    }
                                })
                                .buttonStyle(.bordered)
                                .tint(Color.greenPro)
                                .isVisible(isVisible: !lesson.words[index].eg.isEmpty)
                                Divider()
                            }
                            HStack{
                                Toggle(isOn: Binding(
                                    get: { hiddenEgs.contains(index) },
                                    set: { newValue in toggleHiddenEg(index, newValue) }
                                )) {
                                    Text(hiddenEgs.contains(index) ? lesson.words[index].eg.hiddenString : "\(lesson.words[index].eg)")
                                        .font(.system(size: wordMeaningSize2))
                                }
                                .tint(.primary)
                                .toggleStyle(iOSCheckboxToggleStyle())
                                .isVisible(isVisible: !lesson.words[index].eg.isEmpty)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                                Button(action: {
                                    highLineIndex = index
                                    if lesson.words[index].viVoice.isEmpty {
                                        NetWorkManager.shared.synthesizeTextToSpeech(lesson.words[index].eg, voiceId: "vi-VN-Standard-D/MALE") { voiceData in
                                            guard let voiceData = voiceData else { return }
                                            AVPlayerManager.shared.play(voiceData, speed: Float(speed))
                                        }
                                    }
                                    else {
                                        if lesson.words[index].viVoice.contains("http"){
                                            AVPlayerManager.shared.play(url: URL(string: lesson.words[index].viVoice)!)
                                        } else {
                                            AVPlayerManager.shared.play(lesson.words[index].viVoice, speed: Float(speed))
                                        }
                                    }
                                }, label: {
                                    HStack{
                                        Image(systemName: "speaker.wave.3.fill")
                                    }
                                })
                                .buttonStyle(.bordered)
                                .tint(Color.yellow)
                                VStack{
                                    Button {
                                        lessonViewModel.swap(to: lesson, word1: lesson.words[index], word2: lesson.words[index-1])
                                    } label: {
                                        Image(systemName: "chevron.up")
                                    }
                                    .buttonStyle(.bordered)
                                    .disabled(index == 0)
                                    Button {
                                        lessonViewModel.swap(to: lesson, word1: lesson.words[index], word2: lesson.words[index+1])
                                    } label: {
                                        Image(systemName: "chevron.down")
                                    }
                                    .buttonStyle(.bordered)
                                    .disabled(index == lesson.words.count - 1)
                                    
                                }.isVisible(isVisible: swapEnable)
                                
                            }
                            .frame(maxWidth: 270)
                        }
                        .contextMenu {
                            Button {
                                lessonViewModel.delete(in: lesson, word: lesson.words[index])
                            } label: {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Delete")
                                }
                            }
                            Button {
                                newWord = lesson.words[index]
                                editMode = true
                                isAddWordViewPresented.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit")
                                }
                            }
                            
                        }
                        .onTapGesture {
                            self.selectedIndex = index
                            self.showDetailWord = true
                            //showDetailWord = true
                        }
                        
                        
                        GridRow {
                            Divider()
                                .gridCellColumns(6)
                                .frame(minHeight: 3)
                                .overlay(highLineIndex == index || highLineIndex - 1 == index ? Color.red : Color(UIColor.separator))
                                
                            //                            Rectangle()
                            //                                .fill(.secondary.opacity(0.5))
                            //                                .frame(height: 1)
                            //                                .gridCellColumns(7)
                            //                            .gridCellUnsizedAxes([.horizontal])
                        }
                    }
                }
                .padding(.horizontal, 30)
            })
        }
        .overlay(content: {
            if lesson.words.count == 0 {
                ContentUnavailableView {
                    Label("Empty Words", systemImage: "text.word.spacing")
                } description: {
                    Text("Learn, learn more, learn forever")
                        .frame(maxWidth: .infinity)
                } actions: {
                    Button(action: {
                        isAddWordViewPresented.toggle()
                    }, label: {
                        Text("Add new Word")
                    })
                    .buttonStyle(.bordered)
                    .tint(.pink)
                }
            }
        })
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
        .navigationBarItems(trailing:
                                Button(action: {
            swapEnable.toggle()
        }) {
            Text(swapEnable ? "Done" : "Edit")
        }
        )
        .navigationBarItems(trailing: Button(action: {
            showShare = true
        }, label: {
            Image(systemName: "square.and.arrow.up")
        }))
        .navigationBarTitle(lesson.name)
        .sheet(isPresented: $isAddWordViewPresented) {
            AddWordView(lessonViewModel: lessonViewModel, lesson: lesson, newWord: $newWord, isAddWordViewPresented: $isAddWordViewPresented, editMode: $editMode)
        }
//        .sheet(isPresented: $swapEnable, content: {
//            EditListView(lessonViewModel: lessonViewModel, lesson: lesson)
//        })
        .sheet(isPresented: $showShare, content: {

            ShareView(presentedAsModal: $showShare, onShare: { url in
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
//                    UIApplication.shared.keyWindow?.rootViewController?.present(activityVC, animated: true)
//                }
                let pasteboard = UIPasteboard.general
                pasteboard.string = url
                showCopied = true
            }, lesson: lesson)
        })
        .sheet(isPresented: $showSettingView, content: {
            SettingsView(presentedAsModal: $showSettingView)
        })
        .popup(isPresented: $showDetailWord) {
            //            WordPopup(isPresented: $showDetailWord, delete: {
            //                showDetailWord = false
            //                lessonViewModel.delete(in: lesson, word: lesson.words[selectedIndex])
            //            }, word: lesson.words[selectedIndex])
            WordPopup(isPresented: $showDetailWord, selectedPage: $selectedIndex, delete: {
                
            }, lessonViewModel: lessonViewModel, lesson: lesson)
        } customize: { $0
                        
            .closeOnTap(false)
            .closeOnTapOutside(true)
            .backgroundColor(.black.opacity(0.7))
        }
        .overlay(content: {
            TTProgressHUD($showCopied, config: hudConfig)
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
        .onChange(of: isHidePro, { _, _ in
            toggleAllHiddenPros()
        })
        .onChange(of: selectedIndex, { _, _ in
            showDetailWord = true
        })
        .onChange(of: isAToZ, { oldValue, newValue in
            if newValue {
                var loadedGroups: [Group] = []
                for group in lessonViewModel.groups {
                    var lessons: [Lesson] = []
                    for l in group.lessons {
                        if l.id == lesson.id {
                            var words: [Word] = l.words.sorted { (lhs: Word, rhs: Word) -> Bool in
                                return lhs.word.lowercased() < rhs.word.lowercased()
                            }
                            lessons.append(Lesson(id: l.id, name: l.name, groupId: l.groupId, words: words))
                        } else {
                            lessons.append(l)
                        }
                    }
                   loadedGroups.append(Group(id: group.id, name: group.name, lessons: lessons))
                }
                lessonViewModel.groups = loadedGroups
            } else {
                var loadedGroups: [Group] = []
                for group in lessonViewModel.groups {
                    var lessons: [Lesson] = []
                    for l in group.lessons {
                        if l.id == lesson.id {
                            var words: [Word] = l.words.sorted { (lhs: Word, rhs: Word) -> Bool in
                                return Int(lhs.time)! < Int(rhs.time)!
                            }
                            lessons.append(Lesson(id: l.id, name: l.name, groupId: l.groupId, words: words))
                        } else {
                            lessons.append(l)
                        }
                    }
                   loadedGroups.append(Group(id: group.id, name: group.name, lessons: lessons))
                }
                lessonViewModel.groups = loadedGroups
            }
        })
        .onAppear {
            isHideWord = autoHiden
            isHideType = autoHiden
            isHideMeaning = autoHiden
            isHideEg = autoHiden
            isHidePro = autoHiden
        }
    }

    
    private func makeAttributedString(for string: String, highlighting keyword: String, color: Color) -> AttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        if let range = string.range(of: keyword) {
            let startIndex = string.distance(from: string.startIndex, to: range.lowerBound)
            let endIndex = string.distance(from: string.startIndex, to: range.upperBound)
            attributedString.addAttribute(.foregroundColor, value: UIColor(color), range: NSRange(startIndex..<endIndex))
        }
        
        return AttributedString(attributedString)
    }
    
//    private func playWord(_ text: String, index: Int){
//        wordLoadings.insert(index)
//        NetWorkManager.shared.fetchEgVoice(text, voiceId: selectedVoiceId, speed: selectedSpeed) { voiceUrl in
//            self.wordLoadings.remove(index)
//            guard let voiceUrl = voiceUrl else {return}
//            AVPlayerManager.shared.play(url: URL(string: "https://support.readaloud.app/ttstool/getParts?q=\(voiceUrl)")!)
//        }
//    }
//    
//    private func playEx(_ text: String, index: Int){
//        exLoadings.insert(index)
//        NetWorkManager.shared.fetchEgVoice(text, voiceId: selectedVoiceId, speed: selectedSpeed) { voiceUrl in
//            self.exLoadings.remove(index)
//            guard let voiceUrl = voiceUrl else {return}
//            AVPlayerManager.shared.play(url: URL(string: "https://support.readaloud.app/ttstool/getParts?q=\(voiceUrl)")!)
//        }
//    }
}

extension LessonViewPC{
    func toggleHiddenWord(_ index: Int, _ newValue: Bool) {
        if newValue {
            hiddenWords.insert(index)
        } else {
            hiddenWords.remove(index)
        }
    }
    
    
    func toggleHiddenPro(_ index: Int, _ newValue: Bool) {
        if newValue {
            hiddenPros.insert(index)
        } else {
            hiddenPros.remove(index)
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
    
    func toggleAllHiddenPros() {
        if hiddenPros.isEmpty {
            hiddenPros = Set(lesson.words.indices)
        } else {
            hiddenPros.removeAll()
        }
    }
}


struct AnimatableSystemFontModifier: ViewModifier, Animatable {
    var size: Double
    var weight: Font.Weight
    var design: Font.Design

    var animatableData: Double {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight, design: design))
    }
}
extension View {
    func animatableSystemFont(size: Double, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        self.modifier(AnimatableSystemFontModifier(size: size, weight: weight, design: design))
    }
}
