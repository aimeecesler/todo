//
//  AddEditTodoView+ViewModel.swift
//  todo
//
//  Created by Aimee Esler on 3/24/23.
//

import Foundation

extension AddEditTodoView {
    class ViewModel: ObservableObject {
        @Published var state: ViewState
        var todoService: TodoService
        let todoCache = TodoListCache.shared

        var isNew: Bool
        
        var disableInputs: Bool {
            state.loadingState != .idle
        }
        
        init(_ todo: Todo? = nil, todoService: TodoService = .init()) {
            self.isNew = todo == nil
            self.state = .init(todo: todo ?? .init(id: UUID().uuidString,
                                                   title: "",
                                                   details: "",
                                                   categories: [],
                                                   createdOn: Date.now),
                               validationState: .init(titleIsValid: todo?.title.isEmpty ?? false,
                                                      detailIsValid: todo?.details.isEmpty ?? false),
                               showDueDatePicker: todo?.dueDate != nil)
            self.todoService = todoService
        }
        
        func onAction(_ action: Action) {
            switch action {
            case .saveTask:
                validateTask()
                if state.validationState.isValid {
                    saveTask()
                }
            case .saveTaskSuccess:
                saveTaskSuccess()
            case .saveTaskFailure:
                saveTaskFailure()
            case .addRemoveTodoCategory(let category):
                addRemoveTodoCategory(category)
            case .toggleDueDatePicker:
                toggleDueDatePicker()
            }
        }
        
        private func saveTask() {
            state.loadingState = .loading
            // If a due date has been selected, set the time to the last minute of the day
            if let date = state.todo.dueDate {
                state.todo.dueDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)
            }
            
            todoService.upsertTodo(state.todo) { error in
                guard error == nil else {
                    self.onAction(.saveTaskFailure)
                    return
                }
                
                self.onAction(.saveTaskSuccess)
            }
        }
        
        private func saveTaskSuccess() {
            state.loadingState = .loaded
            // Mark cache as dirty on successful save to reload list from server on next list view
            todoCache.markAsDirty()
        }
        
        private func saveTaskFailure() {
            state.loadingState = .error
            state.showErrorAlert = true
        }
        
        private func validateTask() {
            state.validationState.titleIsValid = !state.todo.title.isEmpty
            state.validationState.detailIsValid = !state.todo.details.isEmpty
        }
        
        private func addRemoveTodoCategory(_ category: TodoCategory) {
            if state.todo.categories.contains(category) {
                state.todo.categories.removeAll(where: { $0 == category })
            } else {
                state.todo.categories.append(category)
            }
        }
        
        private func toggleDueDatePicker() {
            state.showDueDatePicker.toggle()
            if state.showDueDatePicker == false {
                // Clear out the due date when hiding the picker
                state.todo.dueDate = nil
            }
        }
    }
    
    struct ViewState {
        var todo: Todo
        var loadingState: LoadingState = .idle
        var validationState: ValidationState
        
        // UI Triggers
        var showDueDatePicker: Bool
        var showErrorAlert: Bool = false
    }
    
    struct ValidationState {
        var titleIsValid: Bool
        var detailIsValid: Bool
        
        var isValid: Bool {
            titleIsValid && detailIsValid
        }
    }
    
    enum Action {
        case saveTask
        case saveTaskSuccess
        case saveTaskFailure
        case addRemoveTodoCategory(_ category: TodoCategory)
        case toggleDueDatePicker
    }
}
