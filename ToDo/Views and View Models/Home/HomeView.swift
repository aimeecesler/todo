//
//  HomeView.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: ViewModel = .init()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
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
                    .multilineTextAlignment(.center)
                    .frame(height: 200)
                    .deleteDisabled(true)
                }.listSectionSeparator(.hidden)
                
                Section("My To Do List") {
                    ForEach(viewModel.state.todoList) { todo in
                        NavigationLink(destination: TodoDetailsView(viewModel: .init(todo))) {
                            TodoListCell(todo: todo)
                        }
                        .swipeActions {
                            Button(action: {
                                viewModel.onAction(.completeTodo(todo))
                            }) {
                                Image(systemName: "checkmark")
                            }
                            
                            Button(role: .destructive, action: {
                                viewModel.onAction(.removeTodo(todo))
                            }) {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.onAction(.getTodoList)
            }
            .listStyle(.plain)
            .navigationTitle(Text("To Do App"))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
