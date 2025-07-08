//
//  CircularButton.swift
//  Freelancing
//
//  Created by Yaduraj Singh on 07/07/25.
//

import SwiftUI

struct CircularButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.8, green: 0.56, blue: 0.93), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.42, green: 0.31, blue: 0.96), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 1.83, y: 1.93),
                        endPoint: UnitPoint(x: -0.42, y: -0.44)
                    )
                )
                .clipShape(Circle())
                .shadow(color: Color(red: 0.58, green: 0.68, blue: 1).opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    CircularButton(icon: "chevron.right") {
        print("Button tapped")
    }
} 