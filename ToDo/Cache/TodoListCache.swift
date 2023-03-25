//
//  TodoListCache.swift
//  todo
//
//  Created by Aimee Esler on 3/25/23.
//

import Foundation

class TodoListCache: ObservableObject {
    static let shared = TodoListCache()
    
    @Published var todoList: [Todo] = []
    @Published private var cacheIsDirty: Bool = false
    
    func markAsDirty() {
        cacheIsDirty = true
    }
    
    func getTodoList() -> [Todo]? {
        guard todoList.isEmpty || cacheIsDirty else {
            return todoList
        }
        
        return nil
    }
    
    func setTodoList(_ list: [Todo]) {
        todoList = list
        cacheIsDirty = false
    }
}
