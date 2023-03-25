//
//  CalendarContainerView.swift
//  todo
//
//  Created by Aimee Esler on 3/25/23.
//

import SwiftUI

struct CalendarContainerView: View {
    @StateObject var viewModel: ViewModel = .init()
    let dateFormatter = CustomDateFormatter()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                CalendarView(viewModel: viewModel)
                
                if let selectedDate = viewModel.state.selectedDate {
                    VStack(alignment: .leading) {
                        Text(dateFormatter.getShortDateString(selectedDate))
                            .font(.title)
                        ForEach(viewModel.state.displayedTodoList) { todo in
                            NavigationLink(destination: {
                                TodoDetailsView(viewModel: .init(todo))
                            }, label: {
                                TodoListCell(todo: todo)
                            })
                        }
                    }.padding(.horizontal, 16)
                }
            }
            .onAppear {
                viewModel.onAction(.getTodoList)
            }
            .navigationTitle("My Calendar")
        }
    }
}

struct CalendarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarContainerView()
    }
}
