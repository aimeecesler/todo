//
//  ContentView.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                }
            AddEditTodoView(viewModel: .init())
                .tabItem {
                    Image(systemName: "plus.circle")
                }
            CalendarContainerView()
                .tabItem {
                    Image(systemName: "calendar")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
