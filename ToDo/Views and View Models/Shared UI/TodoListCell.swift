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
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(todo.title)
                Text("Created: \(dateFormatter.getShortDateString(todo.createdOn))")
                if let dueDate = todo.dueDate, !todo.isCompleted, !todo.dueToday {
                    Text("Due: \(dateFormatter.getShortDateString(dueDate))")
                }
                
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
    
    @ViewBuilder
    var displayedFlag: some View {
        if todo.isCompleted {
            completedFlag
        } else if todo.dueToday {
            dueTodayFlag
        } else if todo.isOverdue {
            overdueFlag
        }
    }
    
    var completedFlag: some View {
        flag(text: "Completed", color: .black)
    }
    
    var overdueFlag: some View {
        flag(text: "Overdue", color: .red)
    }
    
    var dueTodayFlag: some View {
        flag(text: "Due Today", color: .mint)
    }
    
    func flag(text: String, color: Color) -> some View {
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
