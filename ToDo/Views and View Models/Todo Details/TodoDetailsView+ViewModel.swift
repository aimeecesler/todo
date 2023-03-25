//
//  TodoDetailsView+ViewModel.swift
//  todo
//
//  Created by Aimee Esler on 3/24/23.
//

import Foundation

extension TodoDetailsView {
    class ViewModel: ObservableObject {
        @Published var state: ViewState
        
        private let dateFormatter = CustomDateFormatter()
        
        var dueDateString: String {
            guard let dueDate = state.todo.dueDate else { return "" }
            return dateFormatter.getShortDateString(dueDate)
        }
        
        var dueDateMessage: String {
            guard let dueDate = state.todo.dueDate else { return "" }
            
            let daysFromToday = dueDate.daysFromToday
            if state.todo.dueToday {
                return "Due Today!"
            } else if daysFromToday > 0 {
                let dayString = daysFromToday == 1 ? "Day" : "Days"
                return "Due in \(daysFromToday) \(dayString)"
            } else {
                let dayString = daysFromToday == -1 ? "Day" : "Days"
                return "\(daysFromToday * -1) \(dayString) Overdue"
            }
        }
        
        var editButtonIsDisabled: Bool {
            state.loadingState != .loaded
        }
        
        init(_ todo: Todo) {
            self.state = .init(todo: todo)
        }
        
        func onAction(_ action: Action) {
            switch action {
            case .refreshDetails:
                getTodoDetails()
            case .showEditDetailsView:
                state.showEditTodoView = true
            case .detailsRefreshSuccess:
                state.loadingState = .loaded
            case .detailsRefreshFailure:
                state.loadingState = .error
            }
        }
        
        private func getTodoDetails() {
            state.loadingState = .loading
            // TODO: ADD API LOGIC TO GET TODO DETAILS
        }
    }
    
    struct ViewState {
        var todo: Todo
        var loadingState: LoadingState = .loaded
        
        // UI Triggers
        var showEditTodoView: Bool = false
    }
    
    enum Action {
        case refreshDetails
        case detailsRefreshSuccess
        case detailsRefreshFailure
        case showEditDetailsView
    }
}
