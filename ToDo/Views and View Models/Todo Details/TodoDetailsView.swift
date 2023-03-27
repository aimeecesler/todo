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
            .padding(16)
            .sheet(isPresented: $viewModel.state.showEditTodoView, onDismiss: {
                viewModel.onAction(.refreshDetails)
            }) {
                AddEditTodoView(viewModel: .init(todo))
            }
        }
        .navigationBarBackButtonHidden()
        .toolbarBackground(Color.beige, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.beige, for: .tabBar)
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
    }
    
    // MARK: Details
    private var detailsView: some View {
        Text(todo.details)
            .font(.title2)
            .foregroundColor(.secondary)
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
        CardView(backgroundColor: .darkTeal) {
            HStack(spacing: 16) {
                Image.clockCircleFill
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
        CardView(backgroundColor: .darkPink) {
            HStack(spacing: 16) {
                Image.partyPopper
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text("\(Constants.completed)!")
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
            Text(Constants.edit)
                .kerning(2)
        }
        .disabled(viewModel.editButtonIsDisabled)
        .buttonStyle(.bordered)
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image.chevronLeft
        }.foregroundColor(.primary)
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
