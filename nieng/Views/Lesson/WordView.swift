//
//  WordView.swift
//  nieng
//
//  Created by Quyen Dang on 14/11/2023.
//

import SwiftUI


struct WordView: View {

    
    @AppStorage("wordSize") var wordSize = 52
    @AppStorage("wordTypeSize") var wordTypeSize = 30
    @AppStorage("wordProSize") var wordProSize = 40
    @AppStorage("wordMeaningSize") var wordMeaningSize = 40
    @AppStorage("wordEgSize") var wordEgSize = 40
    @AppStorage("wordDfSize") var wordDfSize = 40
    
    @AppStorage("autoHiden") var autoHiden = false
    @AppStorage("autoHidenVN") var autoHidenVN = true
    @State var isHideWord = false
    @State var isHidePro = false
    @State var isHideType = false
    @State var isHideMeaning = false
    @State var isHideEg = false
    @State var isHideEg2 = false
    
    @State var isLoadingMeaning = false
    @State var isLoadingEg = false
    @State var isLoadingWord = false
    @State private var textRectDf = CGRect()
    @State private var textRectPro = CGRect()
    
    @AppStorage("useGoogleVoice") var useGoogleVoice = true
    
    @AppStorage("speed") private var speed: Double = 1
    @AppStorage("voiceId") var voiceId = "en-US-Neural2-A/MALE"
    
    let word: Word
    let lesson: Lesson
    @ObservedObject var lessonViewModel: LessonViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            HStack() {
                Toggle(isOn: $isHideWord) {
                    Text(isHideWord ? word.word.hiddenString : "\(word.word)")
                        .font(.system(size: CGFloat(wordSize), weight: .bold))
                    
                }
                .tint(.primary)
                .toggleStyle(iOSCheckboxToggleStyle())
                
                Toggle(isOn: $isHideType) {
                    Text(isHideType ? word.wordType.hiddenString : "\(word.wordType)")
                        .font(.system(size: CGFloat(wordTypeSize)))
                        .foregroundStyle(word.wordType.wordColor)
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                Button(action: {
                    if word.usVoice.isEmpty {
                        isLoadingWord = true
                        NetWorkManager.shared.synthesizeTextToSpeech(word.word, voiceId: voiceId) { voiceData in
                            isLoadingWord = false
                            guard let voiceData = voiceData else { return }
                            AVPlayerManager.shared.play(voiceData, speed: 1.0)
                            var newWord = word
                            newWord.usVoice = voiceData
                            newWord.ukVoice = voiceData
                            lessonViewModel.editWord(to: lesson, word: newWord)
                        }
                    } else {
                        if word.usVoice.contains("http") {
                            if useGoogleVoice {
                                isLoadingWord = true
                                NetWorkManager.shared.synthesizeTextToSpeech(word.word, voiceId: voiceId) { voiceData in
                                    isLoadingWord = false
                                    guard let voiceData = voiceData else { return }
                                    AVPlayerManager.shared.play(voiceData, speed: 1.0)
                                    var newWord = word
                                    newWord.usVoice = voiceData
                                    newWord.ukVoice = voiceData
                                    lessonViewModel.editWord(to: lesson, word: newWord)
                                }
                            } else {
                                AVPlayerManager.shared.play(url: URL(string: word.usVoice)!)
                            }
                            
                        } else {
                            AVPlayerManager.shared.play(word.usVoice, speed: 1.0)
                        }
                    }
                    
                    
                }, label: {
                    HStack{
                        if self.isLoadingWord {
                            ProgressView()
                        }else{
                            Image(systemName: "speaker.wave.3.fill")
                        }
                    }
                })
                .buttonStyle(.bordered)
                .tint(.pink)
                .keyboardShortcut(.defaultAction)
            }
            Toggle(isOn: $isHidePro, label: {
                ZStack(content: {
                    Text(isHidePro ? word.pronunciation.hiddenString : "\(word.pronunciation)").background(GlobalGeometryGetter(rect: $textRectPro)).layoutPriority(1).opacity(0)
                        .font(.system(size: CGFloat(wordProSize)))
                        .multilineTextAlignment(.center)
                    
                    TextField("", text: Binding(get: {
                        isHidePro ? word.pronunciation.hiddenString : "\(word.pronunciation)"
                    }, set: { newValue in
                        newValue
                    }), axis: .vertical)
                    .tint(.pink)
                    .font(.system(size: CGFloat(wordProSize)))
                    .textFieldStyle(PlainTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .frame(width: textRectPro.width)
                    
                })
                
                
//                TextField("", text: Binding(get: {
//                    word.pronunciation
//                }, set: { newValue in
//                    newValue
//                }))
//                .tint(.pink)
//                .font(.system(size: CGFloat(wordProSize)))
//                .textFieldStyle(PlainTextFieldStyle())
//                .multilineTextAlignment(.center)
            })
            .toggleStyle(iOSCheckboxToggleStyle())
            HStack{
                Spacer()
                Toggle(isOn: $isHideMeaning) {
                    ZStack(content: {
                        Text(isHideMeaning ? word.meaning.hiddenString : "\(word.meaning)").background(GlobalGeometryGetter(rect: $textRectDf)).layoutPriority(1).opacity(0)
                            .font(.system(size: CGFloat(wordDfSize)))
                            .multilineTextAlignment(.center)
                        
                        TextField("", text: Binding(get: {
                            isHideMeaning ? word.meaning.hiddenString : "\(word.meaning)"
                        }, set: { newValue in
                            newValue
                        }), axis: .vertical)
                        .tint(.pink)
                        .font(.system(size: CGFloat(wordDfSize)))
                        .textFieldStyle(PlainTextFieldStyle())
                        .multilineTextAlignment(.center)
                        .frame(width: textRectDf.width)
                        
                    })
                }
                .toggleStyle(iOSCheckboxToggleStyle())
                Button(action: {
                    if word.dfVoice.isEmpty {
                        isLoadingMeaning = true
                        NetWorkManager.shared.synthesizeTextToSpeech(word.meaning, voiceId: voiceId) { voiceData in
                            isLoadingMeaning = false
                            guard let voiceData = voiceData else { return }
                            AVPlayerManager.shared.play(voiceData, speed: Float(speed))
                        }
                    } else {
                        if word.dfVoice.contains("http") {
                            AVPlayerManager.shared.play(url: URL(string: word.dfVoice)!)
                        } else {
                            AVPlayerManager.shared.play(word.dfVoice, speed: Float(speed))
                        }
                    }
                }, label: {
                    if self.isLoadingMeaning {
                        ProgressView()
                    }else{
                        Image(systemName: "speaker.wave.3.fill")
                    }
                })
                .contextMenu(menuItems: {
                    Button("x0.5") {
                        playVoice(word.dfVoice, speed: 0.5)
                    }
                    Button("x0.6") {
                        playVoice(word.dfVoice, speed: 0.6)
                    }
                    Button("x0.7") {
                        playVoice(word.dfVoice, speed: 0.7)
                    }
                    Button("x0.8") {
                        playVoice(word.dfVoice, speed: 0.8)
                    }
                })
                .buttonStyle(.borderedProminent)
                .tint(.greenPro)
                .keyboardShortcut("r", modifiers: .command)
                Spacer()
            }
            
            
            
            if !word.eg2.isEmpty {
                HStack{
                    Toggle(isOn: $isHideEg2) {
                        let attributedString = makeAttributedString(for: isHideEg2 ? word.eg2.hiddenString : "\(word.eg2)", highlighting: word.word)
                        Text(attributedString)
                            .font(.system(size: CGFloat(wordEgSize)))
                    }
                    .toggleStyle(iOSCheckboxToggleStyle())
                    
                    Button(action: {
                        
                        if word.egVoice.isEmpty {
                            isLoadingEg = true
                            NetWorkManager.shared.synthesizeTextToSpeech(word.eg2, voiceId: voiceId) { voiceData in
                                isLoadingEg = false
                                guard let voiceData = voiceData else { return }
                                AVPlayerManager.shared.play(voiceData, speed: Float(speed))
                            }
                        } else {
                            if word.dfVoice.contains("http") {
                                AVPlayerManager.shared.play(url: URL(string: word.egVoice)!)
                            } else {
                                AVPlayerManager.shared.play(word.egVoice, speed: Float(speed))
                            }
                        }
                        
                    }, label: {
                        if self.isLoadingEg {
                            ProgressView()
                        }else{
                            Image(systemName: "speaker.wave.3.fill")
                        }
                    })
                    .contextMenu(menuItems: {
                        Button("x0.5") {
                            playVoice(word.egVoice, speed: 0.5)
                        }
                        Button("x0.6") {
                            playVoice(word.egVoice, speed: 0.6)
                        }
                        Button("x0.7") {
                            playVoice(word.egVoice, speed: 0.7)
                        }
                        Button("x0.8") {
                            playVoice(word.egVoice, speed: 0.8)
                        }
                    })
                    .buttonStyle(.bordered)
                    .tint(.greenPro)
                    .keyboardShortcut("e", modifiers: .command)
                }
            }
            
            if !word.eg.isEmpty {
                Divider()
                    .foregroundColor(.gray)
                    .frame(width: 100)
                HStack(content: {
                    Toggle(isOn: $isHideEg) {
                        Text(isHideEg ? word.eg.hiddenString : word.eg)
                            .font(.system(size: CGFloat(wordMeaningSize)))
                    }
                    .toggleStyle(iOSCheckboxToggleStyle())
                    Button(action: {
                        if word.viVoice.isEmpty {
                            NetWorkManager.shared.synthesizeTextToSpeech(word.eg, voiceId: "vi-VN-Standard-D/MALE") { voiceData in
                                guard let voiceData = voiceData else { return }
                                AVPlayerManager.shared.play(voiceData, speed: Float(speed))
                            }
                        } else {
                            if word.viVoice.contains("http") {
                                AVPlayerManager.shared.play(url: URL(string: word.viVoice)!)
                            } else {
                                AVPlayerManager.shared.play(word.viVoice, speed: Float(speed))
                            }
                        }
                    }, label: {
                        Image(systemName: "speaker.wave.3.fill")
                    })
                    .contextMenu(menuItems: {
                        Button("x0.5") {
                            playVoice(word.viVoice, speed: 0.5)
                        }
                        Button("x0.6") {
                            playVoice(word.viVoice, speed: 0.6)
                        }
                        Button("x0.7") {
                            playVoice(word.viVoice, speed: 0.7)
                        }
                        Button("x0.8") {
                            playVoice(word.viVoice, speed: 0.8)
                        }
                    })
                    .buttonStyle(.bordered)
                    .tint(.yellow)
                })
                .padding(.bottom, 20)
            }
            
            
            
        }
        .modifier(CustomWordViewModifier())
        .onAppear{
            isHideWord = autoHiden
            isHideType = autoHiden
            isHideMeaning = autoHiden
            isHideEg = autoHidenVN
            isHideEg2 = autoHiden
        }
    }
    
    private func playVoice(_ voiceData: String, speed: Float){
        if !voiceData.isEmpty{
            if !voiceData.contains("http") {
                AVPlayerManager.shared.play(voiceData, speed: speed)
            }
        }
    }
    
    private func makeAttributedString(for string: String, highlighting keyword: String) -> AttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        
        // Tìm vị trí của từ cần kiểm tra trong chuỗi và thiết lập màu đỏ
        if let range = string.range(of: keyword) {
            let startIndex = string.distance(from: string.startIndex, to: range.lowerBound)
            let endIndex = string.distance(from: string.startIndex, to: range.upperBound)
            attributedString.addAttribute(.foregroundColor, value: UIColor(word.wordType.wordColor), range: NSRange(startIndex..<endIndex))
        }
        
        return AttributedString(attributedString)
    }
}



struct CustomWordViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            content
            //                .background(BlurView(style: .systemUltraThinMaterial).cornerRadius(10))
            
        } else {
            content
               
                .padding(.vertical, 30)
                .padding(.horizontal, 20)
                //.background(.white.cornerRadius(20))
                .background(BlurView(style: .systemThickMaterial).cornerRadius(20))
        }
    }
}
