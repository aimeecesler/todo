//
//  Todo.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import Foundation

struct Todo: Codable, Identifiable, Hashable, Equatable {
    var id: String
    var title: String = ""
    var details: String = ""
    var categories: [TodoCategory] = []
    var dueDate: Date
    var completedOn: Date?
    var createdOn: Date
    
    enum CodingKeys: String, CodingKey {
        case id, title, details, categories, dueDate, completedOn, createdOn
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.details = try container.decode(String.self, forKey: .details)
        self.categories = try container.decodeIfPresent([TodoCategory].self, forKey: .categories) ?? []
        self.dueDate = try container.decode(Date.self, forKey: .dueDate)
        self.completedOn = try container.decodeIfPresent(Date.self, forKey: .completedOn)
        self.createdOn = try container.decode(Date.self, forKey: .createdOn)
    }
    
    init(id: String,
         title: String = "",
         details: String = "",
         categories: [TodoCategory] = [],
         dueDate: Date,
         completedOn: Date? = nil,
         createdOn: Date) {
        self.id = id
        self.title = title
        self.details = details
        self.categories = categories
        self.dueDate = dueDate
        self.completedOn = completedOn
        self.createdOn = createdOn
    }
}
