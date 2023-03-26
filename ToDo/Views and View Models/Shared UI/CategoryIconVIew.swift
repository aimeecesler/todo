//
//  CategoryIconView.swift
//  todo
//
//  Created by Aimee Esler on 3/24/23.
//

import SwiftUI

struct CategoryIconView: View {
    var category: TodoCategory
    var size: CGFloat = 30
    
    private var color: Color {
        switch category {
        case .home:
            return .darkPink
        case .work:
            return .darkGold
        case .kids:
            return .darkBlue
        case .shopping:
            return .sageGreen
        case .pets:
            return .gold
        }
    }
    
    private var icon: String {
        switch category {
        case .home:
            return "house"
        case .work:
            return "briefcase"
        case .kids:
            return "figure.and.child.holdinghands"
        case .shopping:
            return "dollarsign"
        case .pets:
            return "pawprint"
        }
    }
    
    var body: some View {
        Circle()
            .foregroundColor(color)
            .frame(width: size)
            .overlay {
                Image(systemName: icon)
                    .font(.system(size: size/2))
                    .foregroundColor(.white)
            }
    }
}

struct CategoryIconView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CategoryIconView(category: .work)
            CategoryIconView(category: .shopping)
            CategoryIconView(category: .pets)
            CategoryIconView(category: .kids)
            CategoryIconView(category: .home)
        }
    }
}
