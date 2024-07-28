//
//  BookView.swift
//  Học Từ Mới
//
//  Created by Quyen Dang on 16/04/2024.
//

import SwiftUI

struct BookView: View {
    var lesson: Lesson
    var body: some View {
        VStack {
            // Hiển thị text "Hello, World!" trong hình chữ nhật màu cam bo 4 góc
            Text(lesson.name)
                .padding()
                .frame(maxWidth: .infinity) // Chiều rộng tối đa
                .background(Color.orange.opacity(0.4))
                .cornerRadius(10)
                .foregroundColor(.white)
            Spacer()
        }
        .frame(height: 50) // Chiều cao cố định
    }
}



struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView(lesson: Lesson(id: "aa", name: "A5", groupId: "", words: [Word(id: "", word: "", wordType: "", pronunciation: "", meaning: "", usVoice: "", ukVoice: "", eg: "", eg2: "", time: "", dfVoice: "", egVoice: "", viVoice: "")]))
    }
}
