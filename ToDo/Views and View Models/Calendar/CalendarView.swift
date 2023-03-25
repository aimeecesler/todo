//
//  CalendarView.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import SwiftUI

struct CalendarView: UIViewRepresentable {
    @ObservedObject var viewModel: CalendarContainerView.ViewModel
    
    let interval: DateInterval = .init(start: .distantPast, end: .distantFuture)
    
    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.delegate = context.coordinator
        view.calendar = .current
        view.availableDateRange = interval
        let dateSelectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.selectionBehavior = dateSelectionBehavior
        return view
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        return
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        
        var parent: CalendarView
        
        init(_ parent: CalendarView) {
            self.parent = parent
        }
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let currentDateTodos = parent.viewModel.state.todoList.filter { $0.dueDate?.startOfDay == dateComponents.date?.startOfDay
            }
            
            guard !currentDateTodos.isEmpty else { return nil }
            
            return .image(UIImage(systemName: "star.fill"),
                          color: .systemPink,
                          size: .large)
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            parent.viewModel.onAction(.newDateSelected(dateComponents))
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
            return true
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(viewModel: .init())
    }
}
