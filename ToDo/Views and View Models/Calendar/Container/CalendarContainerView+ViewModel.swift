//
//  CalendarContainerView+ViewModel.swift
//  todo
//
//  Created by Aimee Esler on 3/25/23.
//

import Foundation

extension CalendarContainerView {
    class ViewModel: ViewModelProtocol {
        @Published var state: ViewState
        private var todoService: TodoService
        
        private let todoCache: TodoListCache
        private let dateFormatter = CustomDateFormatter()
        
        // MARK: Computed Vars
        var selectedDateTitle: String {
            guard let selectedDate = state.selectedDate else { return "" }
            return dateFormatter.getLongDateString(selectedDate)
        }
        
        // MARK: Init
        init(todoService: TodoService = .init(),
             todoCache: TodoListCache = .shared) {
            self.state = .init()
            self.todoService = todoService
            self.todoCache = todoCache
        }
        
        // MARK: OnAction
        func onAction(_ action: Action) {
            switch action {
            case .getTodoList:
                getTodoList()
            case .todoListSuccess(let list):
                state.todoList = list
                state.loadingState = .loaded
            case .todoListFailure:
                state.loadingState = .error
            case .newDateSelected(let date):
                showTodosForNewDate(date)
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
            
            state.todoList = todos
            state.loadingState = .loaded
        }
        
        private func getTodoListFromServer() {
            state.loadingState = .loading
            
            todoService.getTodoList { _, list in
                guard let list = list else {
                    self.onAction(.todoListFailure)
                    return
                }
                
                let sortedList = list.sorted {
                    $0.createdOn < $1.createdOn
                }
                
                self.onAction(.todoListSuccess(sortedList))
                self.todoCache.setTodoList(sortedList)
            }
        }
        
        // MARK: UI Helpers
        private func showTodosForNewDate(_ date: DateComponents?) {
            guard let date = date else {
                state.selectedDate = nil
                state.displayedTodoList = []
                return
            }
            
            let selectedDateTodos = state.todoList.filter {
                $0.dueDate.startOfDay == date.date?.startOfDay
            }
            state.displayedTodoList = selectedDateTodos
            state.selectedDate = date.date
        }
    }
    
    // MARK: ViewState
    struct ViewState {
        var todoList: [Todo] = []
        var loadingState: LoadingState = .idle
        var selectedDate: Date?
        var displayedTodoList: [Todo] = []
        
        // UI Triggers
        var showAddTodoView: Bool = false
    }
    
    // MARK: Action
    enum Action {
        case getTodoList
        case todoListSuccess(_ list: [Todo])
        case todoListFailure
        case newDateSelected(_ date: DateComponents?)
        case showAddTodoView
    }
}
