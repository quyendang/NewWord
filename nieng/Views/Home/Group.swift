//
//  Group.swift
//  nieng
//
//  Created by Quyen Dang on 08/11/2023.
//

import Foundation

struct Group: Identifiable, Hashable {
    
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
//    var tempId = UUID()
    var id: String
    var name: String
    var lessons: [Lesson]
}
