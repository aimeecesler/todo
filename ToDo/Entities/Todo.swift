//
//  Todo.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import Foundation

struct Todo: Codable, Identifiable, Hashable, Equatable {
    var id: String
    var title: String
    var details: String
    var categories: [TodoCategory]
    var dueDate: Date?
    var completedOn: Date?
    var createdOn: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "uid"
        case title, details, categories, dueDate, completedOn, createdOn
    }
    
    var isCompleted: Bool {
        completedOn != nil
    }
    
    var isOverdue: Bool {
        dueDate?.isPast ?? false
    }
    
    var dueToday: Bool {
        dueDate?.isToday ?? false
    }
}
