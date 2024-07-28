import SwiftUI
import AVFoundation

class AudioManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?

    init() {
        // Tên của file .mp3 trong bundle của bạn (đảm bảo đã thêm file vào target của bạn)
        if let soundURL = Bundle.main.url(forResource: "christmas-ident-21090", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print("Error loading sound file: \(error.localizedDescription)")
            }
        }
    }

    func playSound() {
        audioPlayer?.play()
    }
}
