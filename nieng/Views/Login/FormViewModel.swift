////
////  UserViewModel.swift
////  nieng
////
////  Created by Quyen Dang on 21/08/2023.
////
//
//import Foundation
//import FirebaseAuth
//import FirebaseDatabase
//import UserNotifications
//
//
//class FormViewModel: ObservableObject {
//    private lazy var databasePath: DatabaseReference? = {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return nil
//        }
//        let ref = Database.database()
//            .reference()
//            .child("users/\(uid)")
//        return ref
//    }()
//    private let encoder = JSONEncoder()
//    private let decoder = JSONDecoder()
//    @Published var isLoading: Bool = false
//    
//    
//    
//    func createBrace(_ braceData: BracesData, complete: @escaping (Bool?) -> Void) {
//        isLoading = true
//        guard let databasePath = databasePath else {
//            complete(nil)
//            return
//        }
//        
//        let braceDict: [String: Any] = [
//            "startDate": braceData.startDate.timeIntervalSince1970,
//            "endDate": braceData.endDate.timeIntervalSince1970,
//            "dentalName": braceData.dentalName,
//            "dentalAddress": braceData.dentalAddress,
//            "dentalPhone": braceData.dentalPhone,
//            "dentalDoctor": braceData.dentalDoctor
//        ]
//        databasePath.setValue(braceDict) { [self] error, ref in
//            self.isLoading = false
//            if error != nil {
//                complete(nil)
//            }
//            
//            guard let id = ref.key else {
//                complete(nil)
//                return
//            }
//            
//            complete(true)
//        }
//    }
//}
