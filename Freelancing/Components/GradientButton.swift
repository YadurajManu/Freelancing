//
//  GradientButton.swift
//  Freelancing
//
//  Created by Yaduraj Singh on 07/07/25.
//

import SwiftUI

struct GradientButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(title)
                    .font(Font.custom("Poppins", size: 18).weight(.semibold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.vertical, 18)
            .frame(width: 315)
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
            .cornerRadius(99)
            .shadow(color: Color(red: 0.58, green: 0.68, blue: 1).opacity(0.3), radius: 11, x: 0, y: 10)
        }
    }
}

#Preview {
    GradientButton(title: "Get Started") {
        print("Button tapped")
    }
} 