//
//  CalendarContainerView.swift
//  todo
//
//  Created by Aimee Esler on 3/25/23.
//

import SwiftUI

struct CalendarContainerView: View {
    @StateObject private var viewModel: ViewModel = .init()
    
    // MARK: Body
    var body: some View {
        NavigationStack {
            ScrollView {
                CalendarView(viewModel: viewModel)
                
                if viewModel.state.selectedDate != nil {
                    selectedDateTodoList
                }
            }
            .onAppear {
                viewModel.onAction(.getTodoList)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
            .navigationTitle("My Calendar")
            .sheet(isPresented: $viewModel.state.showAddTodoView, onDismiss: {
                viewModel.onAction(.getTodoList)
            }) {
                AddEditTodoView(viewModel: .init())
            }
        }
    }
    
    // MARK: List
    private var selectedDateTodoList: some View {
        VStack(alignment: .leading) {
            Text(viewModel.selectedDateTitle)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            if viewModel.state.displayedTodoList.isEmpty {
                Text("No events for this date")
            } else {
                ForEach(viewModel.state.displayedTodoList) { todo in
                    NavigationLink(destination: {
                        TodoDetailsView(viewModel: .init(todo))
                    }, label: {
                        TodoListCell(todo: todo)
                    })
                }
            }
        }.padding(.horizontal, 16)
    }
    
    // MARK: Add Button
    private var addButton: some View {
        Button(action: {
            viewModel.onAction(.showAddTodoView)
        }) {
            Image(systemName: "plus.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .foregroundColor(.pink)
        }
    }
}

struct CalendarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarContainerView()
    }
}
