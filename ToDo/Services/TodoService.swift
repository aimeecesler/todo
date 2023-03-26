//
//  TodoService.swift
//  ToDo
//
//  Created by Aimee Esler on 3/25/23.
//

import Foundation
import FirebaseDatabase

class TodoService {
    private lazy var databasePath: DatabaseReference? = {
        let ref = Database.database().reference().child("todos")
            return ref
        }()
    
    private lazy var encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()
    
    private lazy var decoder: JSONDecoder = {
       let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
    
    func getTodoList(completion: @escaping (Error?, [Todo]?) -> Void) {
        guard let databasePath = databasePath else {
            return
        }
        
        databasePath
            .observeSingleEvent(of: .value,
                                with:  { snapshot in
            guard let json = snapshot.value as? NSDictionary else {
                // Snapshot value is nil for empty response
                completion(nil, [])
                return
            }
            
            do {
                let listData = try  JSONSerialization.data(withJSONObject: json)
                let decodedObject = try self.decoder.decode([String: Todo].self, from: listData)
                let list = decodedObject.map { $0.value }
                
                completion(nil, list)
            } catch let encodingError as NSError {
                completion(encodingError, nil)
            }
        }) { error in
            completion(error, nil)
        }
    }
    
    func getTodoDetails(for id: String,
                        completion: @escaping (Error?, Todo?) -> Void) {
        databasePath?
            .child(id)
            .observeSingleEvent(of: .value, with: { snapshot in
                guard let json = snapshot.value as? NSDictionary else {
                    return
                }
                
                do {
                    let todoData = try  JSONSerialization.data(withJSONObject: json)
                    let decodedTodo = try self.decoder.decode(Todo.self, from: todoData)
                    completion(nil, decodedTodo)
                } catch let encodingError as NSError {
                    completion(encodingError, nil)
                }
        }) { error in
            completion(error, nil)
        }
    }
    
    func upsertTodo(_ todo: Todo, completion: @escaping (Error?) -> Void) {
        do {
            let encodedData = try encoder.encode(todo)
            let json = try JSONSerialization.jsonObject(with: encodedData)
            databasePath?.child(todo.id).setValue(json,
                                                  withCompletionBlock: { error, _ in
                completion(error)
            })
        } catch let error as NSError {
            completion(error)
        }
    }
    
    func deleteTodo(_ todo: Todo, completion: @escaping (Error?) -> Void) {
        databasePath?.child(todo.id).removeValue() { error, _ in
            completion(error)
        }
    }
    
    func completeTodo(_ todo: Todo, completion: @escaping (Error?, Todo?) -> Void) {
        databasePath?.child("\(todo.id)/completedOn").setValue(todo.completedOn?.ISO8601Format()) { error, _ in
            guard let error = error else {
                completion(nil, todo)
                return
            }
            
            completion(error, nil)
        }
    }
}
