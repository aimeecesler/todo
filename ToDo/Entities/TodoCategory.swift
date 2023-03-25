//
//  TodoCategory.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import Foundation

enum TodoCategory: String, Codable, CaseIterable {
    case home = "Home"
    case work = "Work"
    case kids = "Kids/Family"
    case shopping = "Shopping/Expenses"
    case pets = "Pets"
}
