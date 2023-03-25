//
//  Date+Utils.swift
//  todo
//
//  Created by Aimee Esler on 3/24/23.
//

import Foundation

extension Date {
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }
    
    var isPast: Bool {
        self < Date.now
    }
    
    var daysFromToday: Int {
        let currentCalendar = Calendar.current
        let today = currentCalendar.startOfDay(for: Date.now)
        let givenDate = currentCalendar.startOfDay(for: self)
        
        let numberOfDays = currentCalendar.dateComponents([.day], from: today, to: givenDate)
        
        return numberOfDays.day ?? 0
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}
