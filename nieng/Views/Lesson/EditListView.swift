////
////  EditListView.swift
////  Học Từ Mới
////
////  Created by Quyen Dang on 14/05/2024.
////
//
//import SwiftUI
//
//struct EditListView: View {
//    @ObservedObject var lessonViewModel: LessonViewModel
//    var lesson: Lesson
//    var body: some View {
//        List{
//            ForEach(lesson.words.indices, id: \.self) { index in
//                HStack{
//                    Text("\(index+1)")
//                        .frame(width: 50)
//                    Divider()
//                        .overlay(Color.greenPro)
//                    Text(lesson.words[index].word)
//                }
//                
//            }
//            .onMove(perform: { indices, newOffset in
//                lessonViewModel.swap(to: lesson, word1: lesson.words[source.startIndex], word2: lesson.words[newOffset])
//            })
//        }
//        .toolbar {
//            EditButton()
//        }
//    }
//    
//   
//}
//
