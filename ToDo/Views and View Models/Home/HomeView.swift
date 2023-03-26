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
            List {
                completionStatusSection
                todoListSection
            }
            .onAppear {
                viewModel.onAction(.getTodoList)
            }
            .listStyle(.plain)
            .navigationTitle(Text("To Do App"))
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
        CardView(backgroundColor: .mint) {
            VStack(alignment: .center) {
                Image(systemName: "flag.checkered.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 50)
                Text("\(viewModel.completionRate, specifier: "%.1f")%")
                    .bold()
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("Completed!")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .padding(16)
        }
    }
    
    private var onTimeCompletedTasksCard: some View {
        CardView(backgroundColor: .pink) {
            VStack(alignment: .center) {
                Image(systemName: "face.smiling.inverse")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 50)
                Text("\(viewModel.onTimeCompletionRate, specifier: "%.1f")%")
                    .bold()
                    .font(.title)
                    .foregroundColor(.white)
                
                Text("Completed on time!")
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
                Text("My Todo List")
                Spacer()
                Button(action: {
                    viewModel.onAction(.showAddTodoView)
                }) {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .foregroundColor(.pink)
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
                        Image(systemName: "checkmark")
                    }.tint(.mint)
                }
                
                Button(role: .destructive, action: {
                    viewModel.onAction(.removeTodo(todo))
                }) {
                    Image(systemName: "trash")
                }
            }
        }.tint(.none)
    }
    
    // MARK: List States (error, loading, empty)
    var errorView: some View {
        VStack {
            Text("Well this is embarassing...")
                .font(.title2)
            Button(action: {
                viewModel.onAction(.getTodoList)
            }) {
                Label("RETRY", systemImage: "arrow.counterclockwise")
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
            .padding(.top, 24)
    }
    
    var emptyListView: some View {
        VStack {
            Image("EmptyListImg")
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
