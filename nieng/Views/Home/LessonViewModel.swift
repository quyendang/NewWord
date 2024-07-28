//
//  LessonViewModel.swift
//  nieng
//
//  Created by Quyen Dang on 08/11/2023.
//

import Foundation
import Network
import SwiftSoup
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class LessonViewModel: ObservableObject {
    
    @Published var groups: [Group] = []
    @Published var isExpands: [Bool] = Array(repeating: false, count: 0)
//    @Published var words: [Word] = []
    @Published var isLoading = false
    private lazy var databasePath: DatabaseReference? = {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        let ref = Database.database()
            .reference()
            .child("users/\(uid)")
        return ref
    }()
    
    
    private lazy var storageRef: StorageReference? = {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        let ref = Storage.storage()
            .reference()
            .child("users/\(uid)")
        return ref
    }()
    
    
    init() {
        loadGroups()
    }
    

    
//    func upload(_ data: Data, completed: @escaping (String?)-> Void) {
//        guard let storageRef = storageRef else {
//            return
//        }
//        let audioRef = storageRef.child("\(UUID().uuidString).mp3")
//        audioRef.putData(data, metadata: nil) { (metadata, error) in
//            if let error = error {
//                print("Error uploading: \(error.localizedDescription)")
//                completed(nil)
//            } else {
//                // Lấy đường dẫn đến file đã tải lên
//                audioRef.downloadURL { (url, error) in
//                    if let downloadURL = url {
//                        print("Download URL: \(downloadURL)")
//                        // Bạn có thể sử dụng downloadURL ở đây
//                        completed(downloadURL.absoluteString)
//                    } else {
//                        completed(nil)
//                        print("Error getting download URL: \(error?.localizedDescription ?? "")")
//                    }
//                }
//            }
//        }
//    }
//    
    
    func delete(_ lesson: Lesson) {
        guard let databasePath = databasePath else {
            return
        }
        databasePath.child("groups").child(lesson.groupId).child("lessons").child(lesson.id).removeValue { error, dataRef in
            if error != nil {
                print("error \(error?.localizedDescription)")
            }
        }
    }
    
    func delete(_ group: Group){
        guard let databasePath = databasePath else {
            return
        }
        databasePath.child("groups").child(group.id).removeValue { error, dataRef in
            if error != nil {
                print("error \(error?.localizedDescription)")
            }
        }
    }
    
    func delete(in lesson: Lesson, word: Word) {
        guard let databasePath = databasePath else {
            return
        }
        databasePath.child("groups").child(lesson.groupId).child("lessons").child(lesson.id).child("words").child(word.id).removeValue { error, dataRef in
            if error != nil {
                print("error \(error?.localizedDescription)")
            }
        }
    }
    
    func loadGroups() {
        guard let databasePath = databasePath else {
            return
        }
        //self.words.removeAll()
        databasePath.child("groups").observe(.value) { snapshot in
            var loadedGroups: [Group] = []
            //self.isExpands.removeAll()
            for groupSnapshot in snapshot.children {
                if let groupSnapshot = groupSnapshot as? DataSnapshot, let groupData = groupSnapshot.value as? [String: Any] {
                    let groupID = groupSnapshot.key
                    let groupName = groupData["groupName"] as? String ?? ""
                    var lessons: [Lesson] = []
                    
                    if let lessonsData = groupData["lessons"] as? [String: Any] {
                        for (lessonID, lessonInfo) in lessonsData {
                            if let lessionDic = lessonInfo as? [String: Any] {
                                var loadedWords: [Word] = []
                                if let wordsData = lessionDic["words"] as? [String: Any] {
                                    for (wordID, wordInfo) in wordsData {
                                        guard let wordData = wordInfo as? [String: String]  else {
                                            return
                                        }
                                        let word = wordData["word"] ?? ""
                                        let wordType = wordData["wordType"] ?? ""
                                        let pronunciation = wordData["pronunciation"] ?? ""
                                        let meaning = wordData["meaning"] ?? ""
                                        let usVoice = wordData["usVoice"] ?? ""
                                        let ukVoice = wordData["ukVoice"] ?? ""
                                        let eg = wordData["eg"] ?? ""
                                        let time = wordData["time"] ?? "0"
                                        let eg2 = wordData["eg2"] ?? ""
                                        let dfVoice = wordData["dfVoice"] ?? ""
                                        let egVoice = wordData["egVoice"] ?? ""
                                        let viVoice = wordData["viVoice"] ?? ""
                                        loadedWords.append(Word(id: wordID, word: word, wordType: wordType, pronunciation: pronunciation, meaning: meaning, usVoice: usVoice, ukVoice: ukVoice, eg: eg, eg2: eg2, time: time, dfVoice: dfVoice, egVoice: egVoice, viVoice: viVoice))
                                        //self.words.append(Word(id: wordID, word: word, wordType: wordType, pronunciation: pronunciation, meaning: meaning, usVoice: usVoice, ukVoice: ukVoice, eg: eg, eg2: eg2, time: time, dfVoice: dfVoice, egVoice: egVoice))
                                    }
                                    loadedWords.sort{ Int($0.time)! < Int($1.time)! }
                                }
                                lessons.append(Lesson(id: lessonID, name: lessionDic["lessonName"] as! String, groupId: groupID, words: loadedWords))
                            }
                        }
                        lessons = lessons.sorted { (lhs: Lesson, rhs: Lesson) -> Bool in
                            return lhs.name.lowercased() < rhs.name.lowercased()
                        }
                    }
                    
                    loadedGroups.append(Group(id: groupID, name: groupName, lessons: lessons))
                    let index = loadedGroups.firstIndex(where: { gr in
                        gr.id == groupID
                    })!
                    if index < self.isExpands.count {
                        self.isExpands[index] = self.isExpands[index]
                    } else {
                        self.isExpands.append(lessons.count < 0)
                    }
                    
                }
            }
            loadedGroups = loadedGroups.sorted { $0.name.lowercased().localizedCompare($1.name.lowercased()) == .orderedAscending }
            self.groups = loadedGroups
        }
    }
    
    func initData() {
        guard let databasePath = databasePath else {
            return
        }
        databasePath.child("groups").observe(.value) { [self] snapshot in
            if !snapshot.exists() {
                addGroup("Saved Group")
            }
        }
    }
    
    func addGroup(_ name: String) {
        guard let databasePath = databasePath else {
            return
        }
        let groupRef = databasePath.child("groups").childByAutoId()
        let groupData: [String: Any] = [
            "groupName": name,
            "lessons": []
        ]
        groupRef.setValue(groupData)
    }
    
    func addLesson(to group: Group, name: String) {
        guard let databasePath = databasePath else {
            return
        }
        let lessonRef = databasePath.child("groups").child(group.id).child("lessons").childByAutoId()
        let lessonData: [String: Any] = [
            "lessonName": name
        ]
        lessonRef.setValue(lessonData)
    }
    
    func addWord(to lesson: Lesson, word: Word) {
        guard let databasePath = databasePath else {
            return
        }
        let lessonRef = databasePath.child("groups").child(lesson.groupId).child("lessons").child(lesson.id).child("words").childByAutoId()
        let wordData: [String: Any] = [
            "word": word.word,
            "wordType": word.wordType,
            "pronunciation": word.pronunciation,
            "meaning": word.meaning,
            "usVoice": word.usVoice,
            "ukVoice": word.ukVoice,
            "eg": word.eg,
            "time": word.time,
            "eg2": word.eg2,
            "dfVoice": word.dfVoice,
            "egVoice": word.egVoice
        ]
        //self.words.append(word)
        lessonRef.setValue(wordData)
    }
    
    func editLesson(_ lesson: Lesson, groupId: String) {
        guard let databasePath = databasePath else {
            return
        }
        let lessonRef = databasePath.child("groups").child(lesson.groupId).child("lessons").child(lesson.id)
        if groupId == lesson.groupId {
            let lessonData: [String: Any] = [
                "lessonName": lesson.name
            ]
            lessonRef.updateChildValues(lessonData)
        } else
        {
            lessonRef.observeSingleEvent(of: .value, with: { snapshot in
                if var value = snapshot.value as? [String: Any] {
                    value["lessonName"] = lesson.name
                    databasePath.child("groups").child(groupId).child("lessons").child(lesson.id).setValue(value)
                    lessonRef.removeValue()
                }
            })
        }
        
    }
    
    func editGroup(_ group: Group) {
        guard let databasePath = databasePath else {
            return
        }
        let groupRef = databasePath.child("groups").child(group.id)
        let groupData: [String: Any] = [
            "groupName": group.name
        ]
        groupRef.updateChildValues(groupData)
    }
    
    func editWord(to lesson: Lesson, word: Word) {
        guard let databasePath = databasePath else {
            return
        }
        let lessonRef = databasePath.child("groups").child(lesson.groupId).child("lessons").child(lesson.id).child("words").child(word.id)
        let wordData: [String: Any] = [
            "word": word.word,
            "wordType": word.wordType,
            "pronunciation": word.pronunciation,
            "meaning": word.meaning,
            "usVoice": word.usVoice,
            "ukVoice": word.ukVoice,
            "eg": word.eg,
            "time": word.time,
            "eg2": word.eg2,
            "dfVoice": word.dfVoice,
            "egVoice": word.egVoice
        ]
        lessonRef.updateChildValues(wordData)
    }
    
    
    func swap(to lesson: Lesson, word1: Word, word2: Word) {
        guard let databasePath = databasePath else {
            return
        }
        let lessonRef1 = databasePath.child("groups").child(lesson.groupId).child("lessons").child(lesson.id).child("words").child(word1.id)
        let lessonRef2 = databasePath.child("groups").child(lesson.groupId).child("lessons").child(lesson.id).child("words").child(word2.id)
        let wordData1: [String: Any] = [
            "word": word2.word,
            "wordType": word2.wordType,
            "pronunciation": word2.pronunciation,
            "meaning": word2.meaning,
            "usVoice": word2.usVoice,
            "ukVoice": word2.ukVoice,
            "eg": word2.eg,
            "time": word1.time,
            "eg2": word2.eg2,
            "dfVoice": word2.dfVoice,
            "egVoice": word2.egVoice
        ]
        let wordData2: [String: Any] = [
            "word": word1.word,
            "wordType": word1.wordType,
            "pronunciation": word1.pronunciation,
            "meaning": word1.meaning,
            "usVoice": word1.usVoice,
            "ukVoice": word1.ukVoice,
            "eg": word1.eg,
            "time": word2.time,
            "eg2": word1.eg2,
            "dfVoice": word1.dfVoice,
            "egVoice": word1.egVoice
        ]
        
        lessonRef1.setValue(wordData1)
        lessonRef2.setValue(wordData2)
    }
    
    func loadWords(in lesson: Lesson) {
        guard let databasePath = databasePath else {
            return
        }
        let lessonRef = databasePath.child("groups").child(lesson.groupId).child(lesson.id).child("words")
        lessonRef.observe(.value) { snapshot in
            var loadedWords: [Word] = []
            for wordSnapshot in snapshot.children {
                if let wordSnapshot = wordSnapshot as? DataSnapshot,
                   let wordData = wordSnapshot.value as? [String: String] {
                    let wordID = wordSnapshot.key
                    let word = wordData["word"] ?? ""
                    let wordType = wordData["wordType"] ?? ""
                    let pronunciation = wordData["pronunciation"] ?? ""
                    let meaning = wordData["meaning"] ?? ""
                    let usVoice = wordData["usVoice"] ?? ""
                    let ukVoice = wordData["ukVoice"] ?? ""
                    let eg = wordData["eg"] ?? ""
                    let eg2 = wordData["eg2"] ?? ""
                    let time = wordData["time"] ?? "0"
                    let dfVoice = wordData["dfVoice"] ?? ""
                    let egVoice = wordData["egVoice"] ?? ""
                    let viVoice = wordData["viVoice"] ?? ""
                    loadedWords.append(Word(id: wordID, word: word, wordType: wordType, pronunciation: pronunciation, meaning: meaning, usVoice: usVoice, ukVoice: ukVoice, eg: eg, eg2: eg2, time: time, dfVoice: dfVoice, egVoice: egVoice, viVoice: viVoice))
                }
            }
            loadedWords.sort{ Int($0.time)! < Int($1.time)! }
        }
    }
}
