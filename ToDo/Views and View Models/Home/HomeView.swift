//
//  HomeView.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: ViewModel = .init()
    
    // MARK: Body
    var body: some View {
        NavigationStack {
            VStack {
                Image.logo
                List {
                    completionStatusSection
                    todoListSection
                }
                .listStyle(.plain)
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color.beige, for: .tabBar)
            .background(Color.beige)
            .onAppear {
                viewModel.onAction(.getTodoList)
            }
            .sheet(isPresented: $viewModel.state.showAddTodoView, onDismiss: {
                viewModel.onAction(.getTodoList)
            }) {
                AddEditTodoView(viewModel: .init())
            }
        }
    }
    
    // MARK: Completion Status
    private var completionStatusSection: some View {
        Section {
            HStack {
                completedTasksCard
                onTimeCompletedTasksCard
            }
            .multilineTextAlignment(.center)
            .frame(height: 200)
            .deleteDisabled(true)
        }.listSectionSeparator(.hidden)
    }
    
    private var completedTasksCard: some View {
        CardView(backgroundColor: .lightPink) {
            VStack(alignment: .center) {
                Image.checkeredFlagCircleFill
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 50)
                Text("\(viewModel.completionRate, specifier: "%.1f")%")
                    .bold()
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("\(Constants.completed)!")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .padding(16)
        }
    }
    
    private var onTimeCompletedTasksCard: some View {
        CardView(backgroundColor: .lightTeal) {
            VStack(alignment: .center) {
                Image.faceSmiling
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 50)
                Text("\(viewModel.onTimeCompletionRate, specifier: "%.1f")%")
                    .bold()
                    .font(.title)
                    .foregroundColor(.white)
                
                Text(Constants.completedOnTime)
                    .font(.title2)
                    .foregroundColor(.white)
            }.padding(16)
        }
    }
    
    // MARK: Todo List
    private var todoListSection: some View {
        Section(content: {
            todoList
        },
                header: {
            HStack {
                Text(Constants.myTodoList)
                Spacer()
                Button(action: {
                    viewModel.onAction(.showAddTodoView)
                }) {
                    Image.plusCircle
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .foregroundColor(.darkPink)
                }
            }
        })
    }
    
    @ViewBuilder
    private var todoList: some View {
        switch viewModel.state.loadingState {
        case .error:
            errorView
        case .loading:
            loadingView
        default:
            if viewModel.state.todoList.isEmpty {
                emptyListView
            } else {
                list
            }
        }
    }
    
    @ViewBuilder
    var list: some View {
        ForEach(viewModel.state.todoList) { todo in
            NavigationLink(destination: TodoDetailsView(viewModel: .init(todo))) {
                TodoListCell(todo: todo)
            }
            .swipeActions {
                if !todo.isCompleted {
                    Button(action: {
                        viewModel.onAction(.completeTodo(todo))
                    }) {
                        Image.checkmark
                    }.tint(.darkTeal)
                }
                
                Button(role: .destructive, action: {
                    viewModel.onAction(.removeTodo(todo))
                }) {
                    Image.trash
                }
            }
        }.tint(.darkPink)
    }
    
    // MARK: List States (error, loading, empty)
    var errorView: some View {
        VStack {
            Text(Constants.wellThisIsEmbarrasing)
                .font(.title2)
            Button(action: {
                viewModel.onAction(.getTodoList)
            }) {
                Label(Constants.retry, systemImage: "arrow.counterclockwise")
                    .foregroundColor(.white)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 24)
        .listSectionSeparator(.hidden)
    }
    
    var loadingView: some View {
        ProgressView()
            .scaleEffect(3)
            .listSectionSeparator(.hidden)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
    }
    
    var emptyListView: some View {
        VStack {
            Image.emptyList
                .resizable()
                .scaledToFit()
                .frame(height: 300, alignment: .center)
                .listSectionSeparator(.hidden)
        }.frame(maxWidth: .infinity)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
