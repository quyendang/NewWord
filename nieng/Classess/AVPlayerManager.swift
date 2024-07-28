//
//  AVPlayerManager.swift
//  nieng
//
//  Created by Quyen Dang on 09/11/2023.
//

import Foundation
import AVFoundation
import MediaPlayer


class AVPlayerManager: ObservableObject {
    static let shared = AVPlayerManager()
    
    private var player: AVPlayer?
    private var player2: AVAudioPlayer?
    
    func play(url: URL) {
        player = AVPlayer(url: url)
        player?.play()
    }
    
    
    func play(_ base64String: String, speed: Float) {
        if let audioData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
            guard let pl = try? AVAudioPlayer(data: audioData) else {return}
            self.player2 = pl
            self.player2!.enableRate = true
            self.player2!.prepareToPlay()
            self.player2!.rate = speed
            self.player2!.play()
        }
    }
    
    
    func saveBase64AudioToLibrary(base64String: String, withTitle title: String) {
        // Chuyển đổi base64String thành dạng Data
        guard let audioData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) else {
            print("Lỗi khi chuyển đổi base64 thành Data.")
            return
        }

        // Lấy đường dẫn đến thư mục tạm để lưu file audio
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let audioURL = temporaryDirectory.appendingPathComponent("temp_audio.wav")

        do {
            // Lưu dữ liệu audio vào tệp tạm
            try audioData.write(to: audioURL)

            // Lưu vào thư viện âm nhạc của máy
            let mediaLibrary = MPMediaLibrary.default()
            mediaLibrary.beginGeneratingLibraryChangeNotifications()
            mediaLibrary.addItem(withProductID: title, completionHandler: { (persistentID, error) in
                if let error = error {
                    print("Lỗi khi thêm audio vào thư viện: \(error.localizedDescription)")
                } else {
                    print("Đã lưu audio vào thư viện với title: \(title)")
                }

                // Xóa tệp tạm
                do {
                    try FileManager.default.removeItem(at: audioURL)
                } catch {
                    print("Lỗi khi xóa tệp tạm: \(error.localizedDescription)")
                }

                mediaLibrary.endGeneratingLibraryChangeNotifications()
            })
        } catch {
            print("Lỗi khi lưu dữ liệu audio vào tệp tạm: \(error.localizedDescription)")
        }
    }
}
