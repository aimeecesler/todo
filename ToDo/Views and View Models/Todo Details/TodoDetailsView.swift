//
//  TodoDetailsView.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import SwiftUI

struct TodoDetailsView: View {
    @Environment(\.presentationMode) private var presentationMode
    @StateObject var viewModel: ViewModel
    
    // UI Shortcut Reference
    private var todo: Todo {
        viewModel.state.todo
    }
    
    // MARK: Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                titleView
                detailsView
                categoriesView
                
                if !todo.isCompleted {
                    dueDateCard
                }
                
                if todo.isCompleted {
                    completedCard
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
                editButton
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                backButton
            }
        }
    }
    
    // MARK: Title
    private var titleView: some View {
        Text(todo.title)
            .bold()
            .kerning(2)
            .font(.largeTitle)
            .foregroundColor(todo.isCompleted ? .red : .black)
    }
    
    // MARK: Details
    private var detailsView: some View {
        Text(todo.details)
            .font(.title2)
            .foregroundColor(.gray)
    }
    
    // MARK: Categories
    private var categoriesView: some View {
        HStack {
            ForEach(todo.categories, id: \.hashValue) {
                CategoryIconView(category: $0, size: 60)
            }
        }
        .padding(.vertical, 26)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: Cards
    private var dueDateCard: some View {
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
    }
    
    private var completedCard: some View {
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
    
    // MARK: Toolbar Buttons
    private var editButton: some View {
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
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
        }.foregroundColor(.black)
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
