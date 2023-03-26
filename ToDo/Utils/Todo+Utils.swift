//
//  Todo+Utils.swift
//  ToDo
//
//  Created by Aimee Esler on 3/26/23.
//

import Foundation

extension Todo {
    var isCompleted: Bool {
        completedOn != nil
    }
    
    var isOverdue: Bool {
        dueDate.isPast
    }
    
    var dueToday: Bool {
        dueDate.isToday
    }
}
