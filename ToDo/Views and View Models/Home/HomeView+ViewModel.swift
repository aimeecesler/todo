//
//  HomeView+ViewModel.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import Foundation

extension HomeView {
    class ViewModel: ViewModelProtocol {
        @Published var state: ViewState
        
        private let todoCache = TodoListCache.shared
        private let todoService: TodoService
        
        // MARK: Computed Vars
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
                return completedDate.startOfDay <= $0.dueDate.startOfDay
            }
            
            let completion = Double(completedOnTime.count) / completedCount * 100
            
            return completion.isNaN ? 0.0 : completion
        }
        
        // MARK: Init
        init(todoService: TodoService = .init()) {
            self.state = .init()
            self.todoService = todoService
        }
        
        // MARK: OnAction
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
            case .showAddTodoView:
                state.showAddTodoView = true
            }
        }
        
        // MARK: GET Actions
        private func getTodoList() {
            guard let todos = todoCache.getTodoList() else {
                getTodoListFromServer()
                return
            }
            
            onAction(.todoListSuccess(todos))
        }
        
        private func getTodoListFromServer() {
            state.loadingState = .loading
            
            todoService.getTodoList { [weak self] _, list in                
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
        
        // MARK: DELETE Actions
        private func deleteTodo(_ todo: Todo) {
            todoService.deleteTodo(todo) { error in
                self.state.todoList.removeAll(where: { $0 == todo })
            }
            
            // Mark cache as dirty on save to trigger update
            todoCache.markAsDirty()
        }
        
        // MARK: UPDATE Actions
        private func completeTodo(_ todo: Todo) {
            var newTodo = todo
            newTodo.completedOn = .now
            todoService.completeTodo(newTodo) { _, updatedTodo in
                if let updatedTodo = updatedTodo,
                   let i = self.state.todoList.firstIndex(of: todo){
                    self.state.todoList[i] = updatedTodo
                }
            }
            
            // Mark cache as dirty on save to trigger update
            todoCache.markAsDirty()
        }
    }
    
    // MARK: ViewState
    struct ViewState {
        var todoList: [Todo] = []
        var loadingState: LoadingState = .loading
        
        // UI Triggers
        var showAddTodoView: Bool = false
    }
    
    // MARK: Action
    enum Action {
        case getTodoList
        case todoListSuccess(_ list: [Todo])
        case todoListFailure
        case removeTodo(_ todo: Todo)
        case completeTodo(_ todo: Todo)
        case showAddTodoView
    }
}
