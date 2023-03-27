//
//  AddEditTodoView+ViewModel.swift
//  todo
//
//  Created by Aimee Esler on 3/24/23.
//

import Foundation
import SwiftUI

extension AddEditTodoView {
    class ViewModel: ViewModelProtocol {
        @Published var state: ViewState
        var todoService: TodoService
        let todoCache = TodoListCache.shared

        var isNew: Bool
        
        // MARK: Computed Vars
        var disableInputs: Bool {
            state.loadingState != .idle
        }
        
        var navigationTitle: String {
            isNew ? Constants.addNewTodo : Constants.editTodo
        }
        
        // MARK: Init
        init(_ todo: Todo? = nil, todoService: TodoService = .init()) {
            self.isNew = todo == nil
            self.state = .init(todo: todo ?? .init(id: UUID().uuidString,
                                                   dueDate: Date.now,
                                                   createdOn: Date.now))
            self.todoService = todoService
        }
        
        // MARK: On Action
        func onAction(_ action: Action) {
            switch action {
            case .validateTitle:
                state.validationState.titleIsValid = !state.todo.title.isEmpty
            case .validateDetails:
                state.validationState.detailIsValid = !state.todo.details.isEmpty
            case .saveTodo:
                validateTask()
                if state.validationState.isValid {
                    saveTask()
                }
            case .saveTodoSuccess:
                saveTaskSuccess()
            case .saveTodoFailure:
                saveTaskFailure()
            case .addRemoveTodoCategory(let category):
                addRemoveTodoCategory(category)
            }
        }
        
        // MARK: Save
        private func saveTask() {
            // Resigning the first responder
            UIApplication.shared.sendAction(
                  #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
            )
            state.loadingState = .loading
            
            // Setting due date to start of day for consistency
            state.todo.dueDate = state.todo.dueDate.startOfDay
            
            todoService.upsertTodo(state.todo) { error in
                guard error == nil else {
                    self.onAction(.saveTodoFailure)
                    return
                }
                
                self.onAction(.saveTodoSuccess)
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
        
        // MARK: Validation Actions
        private func validateTask() {
            state.validationState.titleIsValid = !state.todo.title.isEmpty
            state.validationState.detailIsValid = !state.todo.details.isEmpty
        }
        
        // MARK: Data Actions
        private func addRemoveTodoCategory(_ category: TodoCategory) {
            if state.todo.categories.contains(category) {
                state.todo.categories.removeAll(where: { $0 == category })
            } else {
                state.todo.categories.append(category)
            }
        }
    }
    
    // MARK: View State
    struct ViewState {
        var todo: Todo
        var loadingState: LoadingState = .idle
        var validationState: ValidationState = .init()
        
        // UI Triggers
        var showErrorAlert: Bool = false
    }
    
    // MARK: Validation State
    struct ValidationState {
        var titleIsValid: Bool = true
        var detailIsValid: Bool = true
        
        var isValid: Bool {
            titleIsValid && detailIsValid
        }
    }
    
    // MARK: Action
    enum Action {
        case validateTitle
        case validateDetails
        case saveTodo
        case saveTodoSuccess
        case saveTodoFailure
        case addRemoveTodoCategory(_ category: TodoCategory)
    }
}
