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
        e.dateEncodingStrategy = .deferredToDate
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
            guard let json = snapshot.value as? NSArray else {
                return
            }
            
            do {
                let listData = try  JSONSerialization.data(withJSONObject: json)
                let decodedList = try self.decoder.decode([Todo].self, from: listData)
                completion(nil, decodedList)
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
                print(snapshot.value)
                guard let json = snapshot.value as? NSDictionary else {
                    print("Problem getting json")
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
        guard let encodedData = try? encoder.encode(todo) else {
            return
        }
        
        databasePath?.child(todo.id).setValue(encodedData,
                                              withCompletionBlock: { error, _ in
            completion(error)
        })
    }
    
    func deleteTodo(_ todo: Todo) {
        
    }
    
    func completeTodo(_ todo: Todo) {
        
    }
}
