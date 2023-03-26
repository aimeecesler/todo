//
//  TabContentView.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import SwiftUI

struct TabContentView: View {
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image.house
                }
            CalendarContainerView()
                .tabItem {
                    Image.calendar
                }
        }
        .tint(.darkTeal)
        .buttonBorderShape(.capsule)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabContentView()
    }
}
