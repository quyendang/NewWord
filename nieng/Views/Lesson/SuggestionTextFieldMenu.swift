//
//  SuggestionTextFieldMenu.swift
//  Học Từ Mới
//
//  Created by Quyen Dang on 03/05/2024.
//


import SwiftUI

public struct SuggestionTextFieldMenu: View {
    
    @State var names: [String] = ["Apple", "HAHA", "Alo", "Peach","Orange","Banana", "Melon", "Watermelon","Mandarin","Mulberries","Lemon","Lime","Loquat","Longan","Lychee","Grape","Pear","Kiwi","Mango"]
    @State var words: [Word] = []
    @Binding var editing: Bool
    @Binding var inputText: String
    @Binding var newWord: Word
    @State var verticalOffset: CGFloat = 0
    @State var horizontalOffset: CGFloat = 0
    var chosse: ((Word) -> Void)
    private var filteredWords: Binding<[Word]> { Binding (
        get: {
            if inputText.isEmpty {
                return []
            } else
            {
                return words.filter{$0.word.lowercased().hasPrefix(inputText.lowercased())}
            }
            
        },
        set: { _ in })
    }
    
//    public init(editing: Binding<Bool>, text: Binding<String>) {
//        self._editing = editing
//        self._inputText = text
//        self.verticalOffset = 0
//        self.horizontalOffset = 0
//        self.words = []
//    }
//    
//    public init(editing: Binding<Bool>, text: Binding<String>, verticalOffset: CGFloat, horizontalOffset: CGFloat, w: [Word]) {
//        self._editing = editing
//        self._inputText = text
//        self.verticalOffset = verticalOffset
//        self.horizontalOffset = horizontalOffset
//    }
    
    public var body: some View {
        
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(filteredWords, id: \.id) { word in
                    Text(word.word.wrappedValue)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 25)
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               minHeight: 0,
                               maxHeight: 50,
                               alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture(perform: {
                            //self.chosse(Word(id: word.id, word: word.word.wrappedValue, wordType: word.wordType.wrappedValue, pronunciation: word.pronunciation.wrappedValue, meaning: word.meaning.wrappedValue, usVoice: word.usVoice.wrappedValue, ukVoice: word.ukVoice.wrappedValue, eg: word.eg.wrappedValue, eg2: word.eg2.wrappedValue, time: word.time.wrappedValue, dfVoice: word.dfVoice.wrappedValue, egVoice: word.egVoice.wrappedValue))
                            //self.chosse(word.wrappedValue)
                            newWord = word.wrappedValue
                            //inputText = word.word.wrappedValue
                            editing = false
                            
                            self.endTextEditing()
                        })
                    Divider()
                        .padding(.horizontal, 10)
                }
            }
        }
        .background(Color.purple.opacity(0.7))
        .cornerRadius(15)
        .foregroundColor(Color(.white))
        .ignoresSafeArea()
        .frame(maxWidth: .infinity,
               minHeight: 0,
               maxHeight: 50 * CGFloat( (filteredWords.count > 6 ? 6: filteredWords.count)))
        .shadow(radius: 4)
        .padding(.horizontal, 25)
        .offset(x: horizontalOffset, y: verticalOffset)
        .isHidden(!editing, remove: !editing)
        
    }
    
    
}


//
