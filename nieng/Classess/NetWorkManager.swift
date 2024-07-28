//
//  NetWorkManager.swift
//  nieng
//
//  Created by Quyen Dang on 14/11/2023.
//

import Foundation
import SwiftSoup
import SwiftUI

enum AIType {
  case claude, chatgpt, gemini
}

func convertToAIType(from value: Int) -> AIType? {
    switch value {
    case 0:
        return .claude
    case 1:
        return .chatgpt
    case 2:
        return .gemini
    default:
        return nil
    }
}

class NetWorkManager: ObservableObject {
    static let shared = NetWorkManager()
    @AppStorage("chatgptkey") var chatgptkey = ""
    @AppStorage("claudekey") var claudekey = ""
    @AppStorage("geminikey") var geminikey = ""
//    func fetchEgVoice(_ word: String, voiceId: String, speed: String, completed: @escaping (String?)-> Void) {
//        let url = URL(string: "https://support.readaloud.app/ttstool/createParts")!
//        let jsonData = try? JSONSerialization.data(withJSONObject: [
//            ["voiceId": "\(voiceId)",
//             "ssml": "<speak version=\"1.0\" xml:lang=\"en-US\"><prosody volume='default' rate='\(speed)' pitch='default'>\(word)</prosody></speak>"]
//        ])
//        let config = URLSessionConfiguration.default
//        config.httpAdditionalHeaders = [
//            "Referer": "https://ttstool.com",
//            "Content-Type": "application/json",
//            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36"
//        ]
//        let session = URLSession(configuration: config)
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = jsonData
//        let task = session.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                completed(nil)
//            } else if let data = data {
//                if let responseString = String(data: data, encoding: .utf8), let jsonData = responseString.data(using: .utf8) {
//                    do {
//                        if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String] {
//                            if let firstValue = jsonArray.first {
//                                completed(firstValue)
//                            }
//                        }
//                    } catch {
//                        print("Lỗi khi phân tích chuỗi JSON: \(error.localizedDescription)")
//                        completed(nil)
//                    }
//                }
//            }
//        }
//        task.resume()
//        
//    }
//    
//    
//    func download(_ downloadURL: String, completed: @escaping (Data?)-> Void){
//        guard let url = URL(string: downloadURL) else {
//            print("Invalid URL")
//            completed(nil)
//            return
//        }
//        
//        // Sử dụng URLSession để download file
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Download error: \(error.localizedDescription)")
//                completed(nil)
//                return
//            }
//            
//            guard let data = data else {
//                print("No data received")
//                completed(nil)
//                return
//            }
//            
//            completed(data)
//        }.resume()
//    }
    
    func fetchWordInfo(_ word: String, completed: @escaping (Word?)-> Void) {
        
        if let url = URL(string: "https://www.oxfordlearnersdictionaries.com/definition/english/\(word.lowercased().pathWord)_1?q=\(word.lowercased())") {
            var request = URLRequest(url: url)
            request.addValue("https://www.oxfordlearnersdictionaries.com", forHTTPHeaderField: "Referer")
            request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let _ = error {
                    completed(nil)
                } else if let data = data {
                    if let htmlString = String(data: data, encoding: .utf8) {
                        //print(htmlString)
                        do {
                            let doc: Document = try SwiftSoup.parse(htmlString)
                            let usSoundElement = try doc.select("[class=sound audio_play_button pron-us icon-audio]")
                            if usSoundElement.count > 0 {
                                let type = try doc.select("[class=pos]").get(0).text()
                                let time = Date().milliseconds
                                let pronEl = try doc.select("[class=phon]")
                                var pronunciation = ""
                                var audioUS = ""
                                var audioUK = ""
                                if pronEl.count > 0 {
                                    let ukSoundElement = try doc.select("[class=sound audio_play_button pron-uk icon-audio]").get(0)
                                    audioUS = try usSoundElement.get(0).attr("data-src-mp3")
                                    audioUK = try ukSoundElement.attr("data-src-mp3")
                                    pronunciation = try pronEl.get(0).text()
                                }
                                
                                completed(Word(id: UUID().uuidString, word: word, wordType: type, pronunciation: pronunciation, meaning: "", usVoice: audioUS, ukVoice: audioUK, eg: "", eg2: "", time: "\(time)", dfVoice: "", egVoice: "", viVoice: ""))
                            } else {
                                completed(nil)
                            }
                            
                            
                        } catch Exception.Error(_, let message) {
                            print(message)
                            completed(nil)
                        } catch {
                            print("error")
                            completed(nil)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func shortenURL(_ longUrl: String, completed: @escaping (String?)-> Void) {
        let url = URL(string: "https://api.tinyurl.com/create?api_token=j24fW5EcVSE4l9sndA9sqvH1K1vc1RII4jx5EYOzAhFrwfjvpLqWObZqt1Lr")!
        let jsonData: [String: Any?] = [
            "url": longUrl,
            "domain": "tinyurl.com",
            "alias": "",
            "description": "",
            "tags": []
        ]
        
        let data = try? JSONSerialization.data(withJSONObject: jsonData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
        request.httpBody = data
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completed(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let dataR = json["data"] as? [String: Any], let tiny_url = dataR["tiny_url"] as? String {
                        completed(tiny_url)
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completed(nil)
            }
        }
        
        task.resume()
    }
    
    
    func AI(_ text: String, promt: String, aiType: AIType, completed: @escaping (String?)-> Void) {
        if aiType == .claude {
            claudeAI(text, promt: promt) { response in
                completed(response)
            }
        } else if aiType == .chatgpt {
            chatgptAI(text, promt: promt) { response in
                completed(response)
            }
        } else {
            geminiAI(text, promt: promt) { response in
                completed(response)
            }
        }
        
        
    }
    
    
    private func chatgptAI(_ text: String, promt: String, completed: @escaping (String?)-> Void) {
        let apiUrl = "https://api.openai.com/v1/chat/completions"
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(chatgptkey)", forHTTPHeaderField: "Authorization")
        let textPromt = promt.replacingOccurrences(of: "***", with: text)
        let jsonBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": textPromt]
            ]
        ]
        
        // Chuyển đổi JSON thành dữ liệu
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody) else {
            print("Error converting JSON to data")
            return
        }
        
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completed(nil)
                return
            }
            
            guard let data = data else {
                completed(nil)
                return
            }
            
            do {
                if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let contentArray = jsonDictionary["choices"] as? [[String: Any]],
                   let firstContentItem = contentArray.first,
                   let textClaude = firstContentItem["message"] as? [String: Any], let textgpt = textClaude["content"] as? String {
                    completed(textgpt)
                } else {
                    print("Invalid JSON format or missing content")
                    completed(nil)
                }
            } catch {
                completed(nil)
            }
        }
        task.resume()
    }
    
    private func geminiAI(_ text: String, promt: String, completed: @escaping (String?)-> Void) {
        let apiUrl = "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=\(geminikey)"
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let textPromt = promt.replacingOccurrences(of: "***", with: text)
        let jsonBody: [String: Any] = [
            "contents": [
                ["parts": [["text" : textPromt]]]
            ]
        ]
        
        // Chuyển đổi JSON thành dữ liệu
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody) else {
            print("Error converting JSON to data")
            return
        }
        
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completed(nil)
                return
            }
            
            guard let data = data else {
                completed(nil)
                return
            }
            
            do {
                if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let contentArray = jsonDictionary["candidates"] as? [[String: Any]],
                   let firstContentItem = contentArray.first,
                   let textClaude = firstContentItem["content"] as? [String: Any], let parts = textClaude["parts"] as? [[String: Any]],
                   let part = parts.first, let textgpt = part["text"] as? String{
                    completed(textgpt)
                } else {
                    print("Invalid JSON format or missing content")
                    completed(nil)
                }
            } catch {
                completed(nil)
            }
        }
        task.resume()
    }
    
    private func claudeAI(_ text: String, promt: String, completed: @escaping (String?)-> Void) {
        let apiUrl = "https://api.anthropic.com/v1/messages"
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.addValue(claudekey, forHTTPHeaderField: "x-api-key")
        let textPromt = promt.replacingOccurrences(of: "***", with: text)
        let jsonBody: [String: Any] = [
            "model": "claude-3-opus-20240229",
            "max_tokens": 100,
            "messages": [
                ["role": "user", "content": textPromt]
            ]
        ]
        
        // Chuyển đổi JSON thành dữ liệu
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody) else {
            print("Error converting JSON to data")
            return
        }
        
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completed(nil)
                return
            }
            
            guard let data = data else {
                completed(nil)
                return
            }
            
            do {
                if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let contentArray = jsonDictionary["content"] as? [[String: Any]],
                   let firstContentItem = contentArray.first,
                   let textClaude = firstContentItem["text"] as? String {
                    completed(textClaude)
                } else {
                    print("Invalid JSON format or missing content")
                    completed(nil)
                }
            } catch {
                completed(nil)
            }
        }
        task.resume()
    }
    func synthesizeVITextToSpeech(_ text: String, completed: @escaping (String?)-> Void) {
        let apiUrl = "https://api.openai.com/v1/audio/speech"
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(chatgptkey)", forHTTPHeaderField: "Authorization")
        let jsonBody: [String: Any] = [
            "model": "tts-1",
            "input": text,
            "voice": "alloy"
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody) else {
            print("Error converting JSON to data")
            return
        }
        
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completed(nil)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completed(nil)
                return
            }

            guard let data = data else {
                completed(nil)
                return
            }

            let base64EncodedData = data.base64EncodedString()
            print("Base64 encoded audio data: \(base64EncodedData)")
            completed(base64EncodedData)

            // You can further process or store the base64EncodedData as needed
        }

        task.resume()
    }
    
    
    func synthesizeTextToSpeech(_ text: String, voiceId: String, speed: Double? = 1, completed: @escaping (String?)-> Void) {
        let apiUrl = "https://content-texttospeech.googleapis.com/v1/text:synthesize?alt=json&key=AIzaSyB_1LnNnqLDIXXt-3q_TEmfmW9Gg3qo9Vw"
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let name = voiceId.split(separator: "/")[0]
        let ssmlGender = voiceId.split(separator: "/")[1]
        
        let roundedValue = round(speed! * 100) / 100.0
        
        let jsonBody: [String: Any] = [
            "input": ["text": text],
            "voice": ["languageCode": "en-US", "ssmlGender": ssmlGender, "name": name],
            "audioConfig": ["audioEncoding": "MP3", "pitch": 0, "speakingRate": roundedValue]
        ]
        
        // Chuyển đổi JSON thành dữ liệu
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody) else {
            print("Error converting JSON to data")
            return
        }
        
        request.httpBody = jsonData
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completed(nil)
                return
            }
            
            guard let data = data else {
                completed(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDict = json as? [String: Any], let audioContent = jsonDict["audioContent"] as? String {
                    completed(audioContent)
                } else {
                    completed(nil)
                }
            } catch {
                completed(nil)
            }
        }
        task.resume()
    }


    
    
    func translateText(_ text: String, completed: @escaping (String?) -> Void) {
        let url = URL(string: "https://translate.googleapis.com/translate_a/single?client=gtx&dj=1&dt=t&dt=at&dt=bd&dt=ex&dt=md&dt=rw&dt=ss&dt=rm&sl=en&tl=vi&tk=266477.176324&q=\(text)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("https://translatiz.com/", forHTTPHeaderField: "Referer")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completed(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let sentences = json["sentences"] as? [[String: Any]], let sentence = sentences.first, let translatedText = sentence["trans"] as? String {
                    completed(translatedText)
                } else {
                    completed(nil)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completed(nil)
            }
        }
        
        task.resume()
    }
    
}
