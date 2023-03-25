//
//  HomeView+ViewModel.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import Foundation

extension HomeView {
    class ViewModel: ObservableObject {
        @Published var state: ViewState
        let todoCache = TodoListCache.shared
        let todoService: TodoService
        
        // NOT SURE IF THIS IS REALLY NEEDED
//        var disableSwipe: Bool {
//            state.loadingState != .loaded || state.updateTaskLoadingState != .idle
//        }
                
        private var completedCount: Double {
            Double(state.todoList.filter { $0.isCompleted }.count)
        }
        
        var completionRate: Double {
            let completion = (completedCount / Double(state.todoList.count) * 100)
            return completion.isNaN ? 0.0 : completion
        }
        
        var onTimeCompletionRate: Double {
            let completedOnTime = state.todoList.filter {
                guard let completedDate = $0.completedOn else { return false }
                // If there was no due date, then it is always completed on time - default due date to completed date
                return completedDate <= $0.dueDate ?? completedDate
            }
            
            let completion = Double(completedOnTime.count) / completedCount * 100
            
            return completion.isNaN ? 0.0 : completion
        }
        
        init(todoService: TodoService = .init()) {
            self.state = .init()
            self.todoService = todoService
        }
        
        func onAction(_ action: Action) {
            switch action {
            case .getTodoList:
                getTodoList()
            case .removeTodo(let todo):
                deleteTodo(todo)
            case .todoListSuccess(let list):
                state.todoList = list
                state.loadingState = .loaded
            case .todoListFailure:
                state.loadingState = .error
            case .completeTodo(let todo):
                completeTodo(todo)
            }
        }
        
        private func getTodoList() {
            guard let todos = todoCache.getTodoList() else {
                getTodoListFromServer()
                return
            }
            
            onAction(.todoListSuccess(todos))
        }
        
        private func getTodoListFromServer() {
            state.loadingState = .loading
            
            todoService.getTodoList { [weak self] error, list in
                guard let list = list else {
                    self?.onAction(.todoListFailure)
                    return
                }
                
                let sortedList = list.sorted {
                    $0.createdOn < $1.createdOn
                }
                
                self?.onAction(.todoListSuccess(sortedList))
                self?.todoCache.setTodoList(sortedList)
            }
        }
        
        private func deleteTodo(_ todo: Todo) {
            state.updateTaskLoadingState = .loading
            print("----DELETE----")
            print(todo.id)
            // TODO: ADD DELETE FUNCTIONALITY HERE
            
            // Mark cache as dirty on successful save to trigger update on other views
            todoCache.markAsDirty()
        }
        
        private func completeTodo(_ todo: Todo) {
            state.updateTaskLoadingState = .loading
            
            todoService.getTodoDetails(for: todo.id) { error, todo in
                print(error)
                print(todo)
            }
            print("----COMPLETE----")
            print(todo.id)
            // TODO: ADD COMPLETE FUNCTIONALITY HERE
            
            // Mark cache as dirty on successful save to trigger update on other views
            todoCache.markAsDirty()
        }
    }
    
    struct ViewState {
        var todoList: [Todo] = []
        var loadingState: LoadingState = .loading
        var updateTaskLoadingState: LoadingState = .idle
    }
    
    enum Action {
        case getTodoList
        case todoListSuccess(_ list: [Todo])
        case todoListFailure
        case removeTodo(_ todo: Todo)
        case completeTodo(_ todo: Todo)
    }
}
