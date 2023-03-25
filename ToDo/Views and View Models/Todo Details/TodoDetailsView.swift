//
//  TodoDetailsView.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import SwiftUI

struct TodoDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel
    
    // UI Shortcut Reference
    var todo: Todo {
        viewModel.state.todo
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(todo.title)
                    .bold()
                    .kerning(2)
                    .font(.largeTitle)
                    .foregroundColor(todo.isCompleted ? .red : .black)
                Text(todo.details)
                    .font(.title2)
                    .foregroundColor(.gray)
                
                HStack {
                    ForEach(todo.categories, id: \.hashValue) {
                        CategoryIconView(category: $0, size: 60)
                    }
                }
                .padding(.vertical, 26)
                .frame(maxWidth: .infinity)
                
                if todo.dueDate != nil, !todo.isCompleted {
                    CardView(backgroundColor: .mint) {
                        HStack(spacing: 16) {
                            Image(systemName: "clock.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            VStack(alignment: .leading) {
                                Text(viewModel.dueDateString)
                                    .font(.title)
                                    .bold()
                                Text(viewModel.dueDateMessage)
                                    .font(.title2)
                            }
                        }
                        .padding(16)
                        .foregroundColor(.white)
                    }
                    .frame(height: 150)
                }
                
                if todo.isCompleted {
                    CardView(backgroundColor: .pink) {
                        HStack(spacing: 16) {
                            Image(systemName: "party.popper")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            Text("Completed!")
                                .font(.title)
                                .bold()
                        }
                        .padding(16)
                        .foregroundColor(.white)
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 16)
            .sheet(isPresented: $viewModel.state.showEditTodoView, onDismiss: {
                viewModel.onAction(.refreshDetails)
            }) {
                AddEditTodoView(viewModel: .init(todo))
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.onAction(.showEditDetailsView)
                }) {
                    Text("EDIT")
                        .kerning(2)
                }
                .disabled(viewModel.editButtonIsDisabled)
                .foregroundColor(.black)
                .buttonStyle(.bordered)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                }.foregroundColor(.black)
            }
        }
    }
}

struct TodoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetailsView(viewModel: .init(.init(id: "12345",
                                               title: "Test",
                                               details: "Details about this task, they're long details to show lots of text wrapping.",
                                               categories: [.home, .work, .kids, .shopping, .pets],
                                               dueDate: Date.now,
                                               completedOn: Date.now,
                                               createdOn: Date.distantPast)))
    }
}
