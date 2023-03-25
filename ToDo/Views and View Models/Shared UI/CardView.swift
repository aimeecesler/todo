//
//  CardView.swift
//  todo
//
//  Created by Aimee Esler on 3/22/23.
//

import SwiftUI

struct CardView<Content: View>: View {
    var backgroundColor: Color
    var content: () -> Content
    
    var body: some View {
        content()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(backgroundColor)
            }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(backgroundColor: .yellow) {
            Text("This is a Yellow Card.")
                .padding(16)
        }
    }
}
