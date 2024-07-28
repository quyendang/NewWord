//
//  Appointment.swift
//  nieng
//
//  Created by Quyen Dang on 16/07/2023.
//

import Foundation


struct Appointment: Identifiable, Equatable {
    var id: Int
    var title: String
    var note: String?
    var description: String
    var date: Date
    var isCompleted: Bool
}
