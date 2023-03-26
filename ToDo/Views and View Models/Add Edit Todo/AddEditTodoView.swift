//
//  AddEditTodoView.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import SwiftUI

struct AddEditTodoView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject var viewModel: ViewModel
    
    // MARK: Body
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    titleSection
                    detailsSection
                    dueDateSection
                    categoriesSection
                }
                .disabled(viewModel.disableInputs)
                
                saveButton
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    dismissButton
                }
            }
            .alert("Whoops!", isPresented: $viewModel.state.showErrorAlert, actions: {
                alertActions
            }, message: {
                alertMessage
            })
            .onChange(of: viewModel.state.loadingState) { state in
                if state == .loaded {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    // MARK: Title
    private var titleSection: some View {
        Section(content: {
            TextField("Title",
                      text: $viewModel.state.todo.title,
                      prompt: Text("Enter Title..."))
        }, header: {
            Text("Title*")
        }, footer: {
            Text(viewModel.state.validationState.titleIsValid ? "" : "Title is required.")
                .foregroundColor(.red)
        })
        .onChange(of: viewModel.state.todo.title) { _ in
            viewModel.onAction(.validateTitle)
        }
    }
    
    // MARK: Details
    private var detailsSection: some View {
        Section(content: {
            TextEditor(text: $viewModel.state.todo.details)
                .frame(height: 200)
        }, header: {
            Text("Details*")
        }, footer: {
            Text(viewModel.state.validationState.detailIsValid ? "" : "Details are required.")
                .foregroundColor(.red)
        })
        .onChange(of: viewModel.state.todo.details) { _ in
            viewModel.onAction(.validateDetails)
        }
    }
    
    // MARK: Due Date
    private var dueDateSection: some View {
        Section("Due Date*") {
            DatePicker("",
                       selection: $viewModel.state.todo.dueDate,
                       displayedComponents: .date)
            .datePickerStyle(.graphical)
        }
    }
    
    // MARK: Categories
    private var categoriesSection: some View {
        Section("Categories") {
            ForEach(TodoCategory.allCases, id: \.hashValue) { category in
                HStack {
                    Text(category.rawValue)
                    Spacer()
                    Image(systemName: viewModel.state.todo.categories.contains(category) ? "checkmark.square" : "square")
                        .onTapGesture {
                            viewModel.onAction(.addRemoveTodoCategory(category))
                        }
                }
            }
        }
    }
    
    // MARK: Save Button
    private var saveButton: some View {
        Button(action: {
            viewModel.onAction(.saveTodo)
        }, label: {
            Text("SAVE")
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .font(.title3)
                .bold()
                .kerning(2)
        })
        .buttonBorderShape(.capsule)
        .buttonStyle(.borderedProminent)
        .tint(.darkTeal)
        .frame(maxWidth: .infinity)
        .padding(.bottom, 8)
    }
    
    // MARK: Toolbar Buttons
    private var dismissButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image.xmark
        }.buttonStyle(.plain)
    }
    
    // MARK: Alert
    private var alertMessage: some View {
        Text("Something seems to have gone wrong saving your todo.")
            .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    private var alertActions: some View {
        Button("Cancel",
               role: .cancel,
               action: {
            presentationMode.wrappedValue.dismiss()
        })
        
        Button(action: {
            viewModel.onAction(.saveTodo)
        }) {
            Text("Try Again")
                .foregroundColor(.red)
        }
    }
}

struct AddEditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditTodoView(viewModel: .init(nil))
    }
}
