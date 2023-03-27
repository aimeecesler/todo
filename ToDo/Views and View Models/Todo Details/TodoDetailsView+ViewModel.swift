//
//  TodoDetailsView+ViewModel.swift
//  todo
//
//  Created by Aimee Esler on 3/24/23.
//

import Foundation

extension TodoDetailsView {
    class ViewModel: ViewModelProtocol {
        @Published var state: ViewState
        private var todoService: TodoService
        
        private let dateFormatter = CustomDateFormatter()
        
        // MARK: Computed Vars
        var dueDateString: String {
            dateFormatter.getShortDateString(state.todo.dueDate)
        }
        
        var dueDateMessage: String {
            let daysFromToday = state.todo.dueDate.daysFromToday
            if state.todo.dueToday {
                return Constants.dueToday
            } else if daysFromToday > 0 {
                let dayString = daysFromToday == 1 ? Constants.day : Constants.days
                return "\(Constants.dueIn) \(daysFromToday) \(dayString)"
            } else {
                let dayString = daysFromToday == -1 ? Constants.day : Constants.days
                return "\(daysFromToday * -1) \(dayString) \(Constants.overdue)"
            }
        }
        
        var editButtonIsDisabled: Bool {
            state.loadingState != .loaded
        }
        
        // MARK: Init
        init(_ todo: Todo, todoService: TodoService = .init()) {
            self.state = .init(todo: todo)
            self.todoService = todoService
        }
        
        // MARK: OnAction
        func onAction(_ action: Action) {
            switch action {
            case .refreshDetails:
                getTodoDetails()
            case .showEditDetailsView:
                state.showEditTodoView = true
            case .detailsRefreshSuccess(let todo):
                state.todo = todo
                state.loadingState = .loaded
            case .detailsRefreshFailure:
                state.loadingState = .error
            }
        }
        
        // MARK: GET Actions
        private func getTodoDetails() {
            state.loadingState = .loading
            todoService.getTodoDetails(for: state.todo.id) { error, todo in
                guard let todo = todo else {
                    self.onAction(.detailsRefreshFailure)
                    return
                }
                
                self.onAction(.detailsRefreshSuccess(todo))
            }
        }
    }
    
    // MARK: ViewState
    struct ViewState {
        var todo: Todo
        var loadingState: LoadingState = .loaded
        
        // UI Triggers
        var showEditTodoView: Bool = false
    }
    
    // MARK: Action
    enum Action {
        case refreshDetails
        case detailsRefreshSuccess(_ todo: Todo)
        case detailsRefreshFailure
        case showEditDetailsView
    }
}
