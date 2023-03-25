//
//  AddEditTodoView.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import SwiftUI

struct AddEditTodoView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel
    
    // Allows for optional due date in DatePicker
    var passthroughDueDate: Binding<Date> {
        Binding<Date>(
            get: { viewModel.state.todo.dueDate ?? Date()},
            set: { viewModel.state.todo.dueDate = $0 }
        )
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Title (required)") {
                    TextField("Title",
                              text: $viewModel.state.todo.title,
                              prompt: Text("Enter Title..."))
                }
                
                Section("Details (required)") {
                    TextEditor(text: $viewModel.state.todo.details)
                        .frame(height: 200)
                }
                
                Section("Due Date") {
                    Button(action: {
                        viewModel.onAction(.toggleDueDatePicker)
                    }) {
                        Label(viewModel.state.showDueDatePicker ? "Remove Due Date" : "Add a Due Date",
                              systemImage: viewModel.state.showDueDatePicker ? "minus" : "plus")
                    }.buttonStyle(.plain)
                    
                    if viewModel.state.showDueDatePicker {
                        DatePicker("",
                                   selection: passthroughDueDate,
                                   displayedComponents: .date)
                        .datePickerStyle(.graphical)
                    }
                }
                
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
                
                Button(action: {
                    viewModel.onAction(.saveTask)
                }, label: {
                    Text("SAVE")
                        .padding(.vertical, 16)
                        .padding(.horizontal, 32)
                        .font(.title3)
                        .kerning(2)
                })
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .frame(maxWidth: .infinity)
            }
            .disabled(viewModel.disableInputs)
            .navigationTitle(viewModel.isNew ? "Add New To Do" : "Edit To Do")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }.buttonStyle(.plain)
                }
            }
        }
    }
}

struct AddEditTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditTodoView(viewModel: .init(nil))
    }
}
