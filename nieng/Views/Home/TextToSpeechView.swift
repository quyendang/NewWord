//
//  TextToSpeechView.swift
//  Học Từ Mới
//
//  Created by Quyen Dang on 24/01/2024.
//

import SwiftUI

struct TextToSpeechView: View {
    @State var text = ""

    @AppStorage("voiceId") var voiceId = "en-US-Neural2-A/MALE"
    @AppStorage("speed") private var speed: Double = 1
    
    
    var body: some View {
        NavigationView {
            Form {
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
                TextFieldView(string: $text, placeholder: "Text 2 Speech", iconName: "rectangle.2.swap")
                Button("Play") {
                    NetWorkManager.shared.synthesizeTextToSpeech(text, voiceId: voiceId, speed: speed) { voiceData in
                        guard let voiceData = voiceData else {
                            return
                        }
                        AVPlayerManager.shared.play(voiceData, speed: 1.0)
                    }
                }
                Button("Download") {
                    NetWorkManager.shared.synthesizeTextToSpeech(text, voiceId: voiceId, speed: speed) { voiceData in
                        guard let voiceData = voiceData else {
                            return
                        }
                        let pasteboard = UIPasteboard.general
                        pasteboard.string = "data:audio/mp3;base64,\(voiceData)"

                    }
                }
            }
            .navigationTitle("Text 2 Speech")
        }
    }
}

#Preview {
    TextToSpeechView()
}
