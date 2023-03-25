//
//  DateFormatter.swift
//  todo
//
//  Created by Aimee Esler on 3/24/23.
//

import Foundation

class CustomDateFormatter {
    let shortDateFormat: String = "M/d/yy"
    
    func getShortDateString(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let df = DateFormatter()
        df.dateFormat = shortDateFormat
        
        return df.string(from: date)
    }
}
