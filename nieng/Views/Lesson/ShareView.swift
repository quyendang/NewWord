//
//  ShareView.swift
//  Học Từ Mới
//
//  Created by Quyen Dang on 27/11/2023.
//

import SwiftUI
import FirebaseAuth
struct ShareView: View {
    @Binding var presentedAsModal: Bool
    @State private var isWord = true
    @State private var isType = true
    @State private var isPro = true
    @State private var isDefinition = true
    @State private var isEg = true
    @State private var isMeaning = true
    
    @State private var isPWord = true
    @State private var isPType = true
    @State private var isPPro = true
    @State private var isPDefinition = true
    @State private var isPEg = true
    @State private var isPMeaning = true
    
    @State private var linkType = 1
    @State private var sortType = 0
    var onShare: (_ url: String) -> (Void)
    var lesson: Lesson
 
    var body: some View {
        NavigationView(content: {
            Form {
                Section {
                    Toggle(isOn: $isWord, label: {
                        Text("Word")
                        
                    })
                    Toggle(isOn: $isType, label: {
                        Text("Type")
                        
                    })
                    Toggle(isOn: $isPro, label: {
                        Text("IPA")
                        
                    })
                    Toggle(isOn: $isDefinition, label: {
                        Text("Definition")
                        
                    })
                    Toggle(isOn: $isEg, label: {
                        Text("EG")
                        
                    })
                    Toggle(isOn: $isMeaning, label: {
                        Text("Vietnamese")
                        
                    })
                } header: {
                    Text("Website")
                } footer: {
                    Text("Hide or show content on the website.")
                }
                
                Section {
                    Toggle(isOn: $isPWord, label: {
                        Text("Word")
                        
                    })
                    Toggle(isOn: $isPType, label: {
                        Text("Type")
                        
                    })
                    Toggle(isOn: $isPPro, label: {
                        Text("IPA")
                        
                    })
                    Toggle(isOn: $isPDefinition, label: {
                        Text("Definition")
                        
                    })
                    Toggle(isOn: $isPEg, label: {
                        Text("EG")
                        
                    })
                    Toggle(isOn: $isPMeaning, label: {
                        Text("Vietnamese")
                        
                    })
                } header: {
                    Text("Print")
                } footer: {
                    Text("Hide or show content when printing.")
                }
                
                Section {
                    Picker(selection: $linkType, label: Text("Link type:")) {
                        Text("Short Link - Bit.ly").tag(0)
                        Text("Default Link").tag(1)
                    }
                } header: {
                    Text("Link")
                } footer: {
                    VStack(alignment: .leading, content: {
                        Text("Short Link: https://tinyurl.com/xxxxx")
                        Text("Default Link: https://lopthaybinh.site/xxxxx")
                    })
                }
                
                Section("Sort"){
                    Picker(selection: $sortType) {
                        Text("Time").tag(0)
                        Text("A-Z").tag(1)
                        Text("Default").tag(2)
                    } label: {
                        Text("Sort List")
                    }

                }
                
                Section {
                    Button("Share") {
                        guard let userID = Auth.auth().currentUser?.uid else {return}
                        var hidens: [String] = []
                        var hidensprint: [String] = []
                        if !isWord {
                            hidens.append("1")
                        }
                        
                        if !isType {
                            hidens.append("2")
                        }
                        
                        if !isPro {
                            hidens.append("3")
                        }
                        
                        if !isDefinition {
                            hidens.append("4")
                        }
                        
                        if !isEg {
                            hidens.append("5")
                        }
                        
                        if !isMeaning {
                            hidens.append("6")
                        }
                        
                        
                        if !isPWord {
                            hidensprint.append("1")
                        }
                        
                        if !isPType {
                            hidensprint.append("2")
                        }
                        
                        if !isPPro {
                            hidensprint.append("3")
                        }
                        
                        if !isPDefinition {
                            hidensprint.append("4")
                        }
                        
                        if !isPEg {
                            hidensprint.append("5")
                        }
                        
                        if !isPMeaning {
                            hidensprint.append("6")
                        }
                        
                        var url = "https://lopthaybinh.site/?userid=\(userID)&groupid=\(lesson.groupId)&lessonid=\(lesson.id)&sort=\(sortType)"
                        
                        if hidens.count > 0 {
                            let hidenStr = hidens.joined(separator: ",")
                            let base64 = hidenStr.base64Encoded()!
                            url = "\(url)&column=\(base64)"
                        }
                        
                        if hidensprint.count > 0 {
                            let hidenPStr = hidensprint.joined(separator: ",")
                            let base64P = hidenPStr.base64Encoded()!
                            url = "\(url)&print=\(base64P)"
                        }
                        
                        
                        if linkType == 0 {
                            NetWorkManager.shared.shortenURL(url) { urlShorted in
                                guard let urlShare = urlShorted else {return}
                                presentedAsModal = false
                                onShare(urlShare)
                            }
                        } else {
                            presentedAsModal = false
                            onShare(url)
                        }
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
            .navigationBarItems(trailing: Button("Share", action: {
                guard let userID = Auth.auth().currentUser?.uid else {return}
                var hidens: [String] = []
                var hidensprint: [String] = []
                if !isWord {
                    hidens.append("1")
                }
                
                if !isType {
                    hidens.append("2")
                }
                
                if !isPro {
                    hidens.append("3")
                }
                
                if !isDefinition {
                    hidens.append("4")
                }
                
                if !isEg {
                    hidens.append("5")
                }
                
                if !isMeaning {
                    hidens.append("6")
                }
                
                
                if !isPWord {
                    hidensprint.append("1")
                }
                
                if !isPType {
                    hidensprint.append("2")
                }
                
                if !isPPro {
                    hidensprint.append("3")
                }
                
                if !isPDefinition {
                    hidensprint.append("4")
                }
                
                if !isPEg {
                    hidensprint.append("5")
                }
                
                if !isPMeaning {
                    hidensprint.append("6")
                }
                
                var url = "https://lopthaybinh.site/?userid=\(userID)&groupid=\(lesson.groupId)&lessonid=\(lesson.id)&sort=\(sortType)"
                
                if hidens.count > 0 {
                    let hidenStr = hidens.joined(separator: ",")
                    let base64 = hidenStr.base64Encoded()!
                    url = "\(url)&column=\(base64)"
                }
                
                if hidensprint.count > 0 {
                    let hidenPStr = hidensprint.joined(separator: ",")
                    let base64P = hidenPStr.base64Encoded()!
                    url = "\(url)&print=\(base64P)"
                }
                
                
                if linkType == 0 {
                    NetWorkManager.shared.shortenURL(url) { urlShorted in
                        guard let urlShare = urlShorted else {return}
                        presentedAsModal = false
                        onShare(urlShare)
                    }
                } else {
                    presentedAsModal = false
                    onShare(url)
                }
            }))
            .navigationTitle("Share")
        })
    }
    
}
