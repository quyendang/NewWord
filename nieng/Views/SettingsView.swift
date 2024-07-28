//
//  SettingsView.swift
//  nieng
//
//  Created by Quyen Dang on 14/07/2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authModel: AuthenticationModel
    @Binding var presentedAsModal: Bool
    @AppStorage("appearanceSelection") private var appearanceSelection: Int = 0
    @AppStorage("ai") private var ai: Int = 0
    @AppStorage("sortList") var sortList: Int = 0
    @AppStorage("wordSize") var wordSize = 52
    @AppStorage("wordTypeSize") var wordTypeSize = 30
    @AppStorage("wordProSize") var wordProSize = 40
    @AppStorage("wordMeaningSize") var wordMeaningSize = 40
    @AppStorage("wordEgSize") var wordEgSize = 40
    @AppStorage("wordDfSize") var wordDfSize = 40
    
    @AppStorage("wordSize2") var wordSize2 = 35
    @AppStorage("wordTypeSize2") var wordTypeSize2 = 25
    @AppStorage("wordProSize2") var wordProSize2 = 25
    @AppStorage("wordMeaningSize2") var wordMeaningSize2 = 25
    @AppStorage("wordEgSize2") var wordEgSize2 = 25
    @AppStorage("wordDfSize2") var wordDfSize2 = 25
    
    @AppStorage("autoHiden") var autoHiden = false
    @AppStorage("autoHidenVN") var autoHidenVN = true
    
    @AppStorage("useGoogleVoice") var useGoogleVoice = true
    
    @AppStorage("speed") private var speed: Double = 1
    @AppStorage("chrismas") private var chrismas: Bool = true
    @AppStorage("voiceId") var voiceId = "en-US-Neural2-A/MALE"
    
    
    @AppStorage("claude_df") var claude_df = "Write a definition for the word: ***,in less than 100 characters"
    @AppStorage("claude_eg") var claude_eg = "Write a example for the word: ***,in less than 100 characters"
    @AppStorage("claude_trans") var claude_trans = "Translate word: *** to Vietnamese"
    @AppStorage("claude_pron") var claude_pron = "Phiên âm của từ *** trong tiếng Anh của Mỹ được viết như thế nào?"
    @AppStorage("claude_type") var claude_type = "Từ *** trong tiếng Anh cơ bản thuộc loại từ nào, ghi bằng Tiếng Anh"
    
    
    @AppStorage("chatgptkey") var chatgptkey = ""
    @AppStorage("claudekey") var claudekey = ""
    @AppStorage("geminikey") var geminikey = ""
    
    var body: some View {
        Form {
            Section {
                Picker(selection: $appearanceSelection) {
                    Text("System")
                        .tag(0)
                    Text("Light")
                        .tag(1)
                    Text("Dark")
                        .tag(2)
                } label: {
                    Text("Select Appearance")
                }
                .pickerStyle(.menu)
            } header: {
                Text("Display")
            }
            
            Section("Chrismas") {
                Toggle(isOn: $chrismas, label: {
                    Text("Chrismaxxx")
                })
            }
//            Section("Sort List") {
//                Picker(selection: $sortList) {
//                    Text("Default")
//                        .tag(0)
//                    Text("A-Z")
//                        .tag(1)
//                } label: {
//                    Text("Sort list")
//                }
//                .pickerStyle(.menu)
//            }
            
//            Section("Sort List") {
//                
//            }
            Section("Voice Setting"){
                Toggle(isOn: $useGoogleVoice, label: {
                    VStack(alignment: .leading){
                        Text("Word Google Voice")
                            .foregroundColor(.red)
                        Text("Turn on to disable Oxford Voice")
                            .font(.footnote)
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }
                })
                
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
                
                HStack{
                    Text("Speed: \(speed)")
                    Slider(value: $speed, in: 0...2, step: 0.1)
                                
                }
            }
            Section {
                Stepper("Word: \(wordSize)", value: $wordSize, in: 20...100)
                Stepper("Type: \(wordTypeSize)", value: $wordTypeSize, in: 10...100)
                Stepper("Pronunciation: \(wordProSize)", value: $wordProSize, in: 20...100)
                Stepper("Definition: \(wordDfSize)", value: $wordDfSize, in: 20...100)
                Stepper("Meaning: \(wordMeaningSize)", value: $wordMeaningSize, in: 20...100)
                Stepper("Example: \(wordEgSize)", value: $wordEgSize, in: 20...100)
            } header: {
                Text("PageView Setting")
            } footer: {
                Text("Size of text in Page View")
            }
            
            Section {
                Stepper("Word: \(wordSize2)", value: $wordSize2, in: 20...100)
                Stepper("Type: \(wordTypeSize2)", value: $wordTypeSize2, in: 10...100)
                Stepper("Pronunciation: \(wordProSize2)", value: $wordProSize2, in: 20...100)
                Stepper("Definition: \(wordDfSize2)", value: $wordDfSize2, in: 20...100)
                Stepper("Meaning: \(wordMeaningSize2)", value: $wordMeaningSize2, in: 20...100)
                Stepper("Example: \(wordEgSize2)", value: $wordEgSize2, in: 20...100)
            } header: {
                Text("Detail Setting")
            } footer: {
                Text("Size of text in Deatail View")
            }
            
            
            
            Section {
                Toggle("Auto Hide", isOn: $autoHiden)
                Toggle("Auto Hide Vietnamese", isOn: $autoHidenVN )
            } header: {
                Text("Auto Hide")
            } footer: {
                Text("Automatically hide content when switching pages")
            }
            
            
            Section("AI") {
                Picker(selection: $ai) {
                    Text("Claude AI")
                        .tag(0)
                    Text("ChatGPT AI")
                        .tag(1)
                    Text("Gemini AI")
                        .tag(2)
                } label: {
                    Text("Select AI for promt")
                }
                .pickerStyle(.menu)
                HStack{
                    Image(systemName: "bolt.trianglebadge.exclamationmark")
                        .renderingMode(.template)
                        .foregroundColor(.yellow)
                    Text("Claude Key")
                        .foregroundColor(Color.orangePro)
                    TextField("Claude API KEY", text: $claudekey)
                    Button(action: {
                        if let myString = UIPasteboard.general.string {
                            claudekey = myString
                        }
                    }, label: {
                        Image(systemName: "doc.on.clipboard")
                    })
                }
                HStack{
                    Image(systemName: "bolt.trianglebadge.exclamationmark")
                        .renderingMode(.template)
                        .foregroundColor(.yellow)
                    Text("Chatgpt Key")
                        .foregroundColor(Color.greenPro)
                    TextField("Chatgpt API KEY", text: $chatgptkey)
                    Button(action: {
                        if let myString = UIPasteboard.general.string {
                            chatgptkey = myString
                        }
                    }, label: {
                        Image(systemName: "doc.on.clipboard")
                    })
                }
                HStack{
                    Image(systemName: "bolt.trianglebadge.exclamationmark")
                        .renderingMode(.template)
                        .foregroundColor(.yellow)
                    Text("Gemini Key")
                        .foregroundColor(.purple)
                    TextField("Gemini API KEY", text: $geminikey)
                    Button(action: {
                        if let myString = UIPasteboard.general.string {
                            geminikey = myString
                        }
                    }, label: {
                        Image(systemName: "doc.on.clipboard")
                    })
                }
                Button("Restore Default Key") {
                    chatgptkey = ""
                    claudekey = ""
                    geminikey = ""
                }
                
                
                HStack{
                    Text("Definition promt")
                        .foregroundColor(.gray)
                    TextField("Definition promt", text: $claude_df)
                }
                HStack{
                    Text("Eg promt")
                        .foregroundColor(.gray)
                    TextField("Eg promt", text: $claude_eg)
                }
                
                HStack{
                    Text("Translate promt")
                        .foregroundColor(.gray)
                    TextField("Translate promt", text: $claude_trans)
                }
                HStack{
                    Text("Type promt")
                        .foregroundColor(.gray)
                    TextField("Type promt", text: $claude_type)
                }
                HStack{
                    Text("IPA promt")
                        .foregroundColor(.gray)
                    TextField("IPA promt", text: $claude_pron)
                }
                
                HStack{
                    Link("Get Claude Key", destination: URL(string: "https://console.anthropic.com/settings/keys")!)
                        .foregroundColor(.orangePro)
                    Divider()
                    Link("Get Chatgpt Key", destination: URL(string: "https://taphoammo.net/gian-hang/tai-khoan-5-chatgpt-co-key-api_482807")!)
                        .foregroundColor(.greenPro)
                    Divider()
                    Link("Get Gemini Key", destination: URL(string: "https://taphoammo.net/gian-hang/api-key-gemini-sll_668534")!)
                        .foregroundColor(.purple)
                }
                
            }
            
            
            if let user = authModel.user{
                Section(user.email ?? "") {
                    Button(role: .destructive) {
                        authModel.signout()
                    } label: {
                        Text("Logout")
                    }
                    
                }
            }
        }
        .navigationTitle("Cài đặt")
    }
    
    
//    private func playEx(){
//        NetWorkManager.shared.fetchEgVoice("my name is Quyen", voiceId: selectedVoiceId, speed: selectedSpeed) { voiceUrl in
//            guard let voiceUrl = voiceUrl else {return}
//            AVPlayerManager.shared.play(url: URL(string: "https://support.readaloud.app/ttstool/getParts?q=\(voiceUrl)")!)
//        }
//    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//            .environmentObject(AuthenticationModel())
//    }
//}
