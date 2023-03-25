//
//  CalendarContainerView+ViewModel.swift
//  todo
//
//  Created by Aimee Esler on 3/25/23.
//

import Foundation

extension CalendarContainerView {
    class ViewModel: ObservableObject {
        @Published var state: ViewState
        let todoCache = TodoListCache.shared
        
        init() {
            self.state = .init()
        }
        
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
            }
        }
        
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
            // GET TODOS FROM SERVER
            let fakeTodoResponse: [Todo] = [
                .init(id: UUID().uuidString,
                      title: "Task 1",
                      details: "Task 1 Details",
                      categories: [.home],
                      dueDate: Date.now,
                      createdOn: Date.now),
                .init(id: UUID().uuidString,
                      title: "Task 2",
                      details: "Task 2 Details",
                      categories: [.work],
                      createdOn: Date.now),
                .init(id: UUID().uuidString,
                      title: "Task 3",
                      details: "Task 3 Details",
                      categories: [.home, .pets],
                      dueDate: Date.distantPast,
                      createdOn: Date.now),
                .init(id: UUID().uuidString,
                      title: "Task 4",
                      details: "Task 4 Details",
                      categories: [.shopping, .kids],
                      completedOn: Date.distantPast,
                      createdOn: Date.now),
                .init(id: UUID().uuidString,
                      title: "Task 5",
                      details: "Task 5 Details",
                      categories: [.pets],
                      dueDate: Date.distantFuture,
                      createdOn: Date.now),
                .init(id: UUID().uuidString,
                      title: "Task 6",
                      details: "Task 6 Details",
                      categories: [.shopping, .pets],
                      dueDate: Date.distantPast,
                      completedOn: Date.now,
                      createdOn: Date.now)
            ]
            
            onAction(.todoListSuccess(fakeTodoResponse))
            todoCache.setTodoList(fakeTodoResponse)
        }
        
        private func showTodosForNewDate(_ date: DateComponents?) {
            guard let date = date else {
                state.selectedDate = nil
                state.displayedTodoList = []
                return
            }
            
            let selectedDateTodos = state.todoList.filter {
                $0.dueDate?.startOfDay == date.date?.startOfDay
            }
            state.displayedTodoList = selectedDateTodos
            state.selectedDate = date.date
        }
    }
    
    struct ViewState {
        var todoList: [Todo] = []
        var loadingState: LoadingState = .idle
        var selectedDate: Date?
        var displayedTodoList: [Todo] = []
    }
    
    enum Action {
        case getTodoList
        case todoListSuccess(_ list: [Todo])
        case todoListFailure
        case newDateSelected(_ date: DateComponents?)
    }
}
