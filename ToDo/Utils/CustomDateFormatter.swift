//
//  CustomDateFormatter.swift
//  todo
//
//  Created by Aimee Esler on 3/24/23.
//

import Foundation

class CustomDateFormatter {
    private let shortDateFormat: String = "M/d/yy" // 03/25/23
    private let longDateFormat: String = "EEEE, MMMM dd, yyyy" // Saturday, March 25, 2023
    
    func getShortDateString(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let df = DateFormatter()
        df.dateFormat = shortDateFormat
        
        return df.string(from: date)
    }
    
    func getLongDateString(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let df = DateFormatter()
        df.dateFormat = longDateFormat
        
        return df.string(from: date)
    }
}
