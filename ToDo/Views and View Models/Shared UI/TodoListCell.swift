//
//  TodoListCell.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import SwiftUI

struct TodoListCell: View {
    var todo: Todo
    
    private let dateFormatter = CustomDateFormatter()
    
    // MARK: Body
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(todo.title)
                Text("Created: \(dateFormatter.getShortDateString(todo.createdOn))")
                Text("Due: \(dateFormatter.getShortDateString(todo.dueDate))")
                
                HStack {
                    ForEach(todo.categories, id: \.hashValue) { category in
                        CategoryIconView(category: category)
                    }
                }
            }
            Spacer()
            displayedFlag
        }
        .foregroundColor(todo.isCompleted ? .red : .black)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: Flags
    @ViewBuilder
    private var displayedFlag: some View {
        if todo.isCompleted {
            completedFlag
        } else if todo.dueToday {
            dueTodayFlag
        } else if todo.isOverdue {
            overdueFlag
        }
    }
    
    private var completedFlag: some View {
        buildFlag(text: "Completed", color: .black)
    }
    
    private var overdueFlag: some View {
        buildFlag(text: "Overdue", color: .red)
    }
    
    private var dueTodayFlag: some View {
        buildFlag(text: "Due Today", color: .mint)
    }
    
    private func buildFlag(text: String, color: Color) -> some View {
        Text(text)
            .bold()
            .foregroundColor(.white)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(Capsule().foregroundColor(color))
    }
}

struct TodoListCell_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            TodoListCell(todo: .init(id: "12345",
                                     title: "Test",
                                     details: "Details",
                                     categories: [.home, .work, .kids, .shopping, .pets],
                                     dueDate: Date.now,
                                     createdOn: Date.now))
            TodoListCell(todo: .init(id: "12345",
                                     title: "Test",
                                     details: "Details",
                                     categories: [.home, .work, .kids, .shopping, .pets],
                                     dueDate: Date.distantPast,
                                     createdOn: Date.now))
            TodoListCell(todo: .init(id: "12345",
                                     title: "Test",
                                     details: "Details",
                                     categories: [.home, .work, .kids, .shopping, .pets],
                                     dueDate: Date.distantFuture,
                                     createdOn: Date.now))
            TodoListCell(todo: .init(id: "12345",
                                     title: "Test",
                                     details: "Details",
                                     categories: [.home, .work, .kids, .shopping, .pets],
                                     dueDate: Date.distantFuture,
                                     completedOn: Date.now,
                                     createdOn: Date.now))
            TodoListCell(todo: .init(id: "12345",
                                     title: "Test",
                                     details: "Details",
                                     categories: [.home, .work, .kids, .shopping, .pets],
                                     dueDate: Date.now,
                                     createdOn: Date.now))
        }.padding(.horizontal, 16)
    }
}
