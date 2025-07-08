//
//  OnboardingView2.swift
//  Freelancing
//
//  Created by Yaduraj Singh on 07/07/25.
//

import SwiftUI
import Lottie

struct OnboardingView2: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToNext = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Upper half with gradient background
                ZStack {
                    // Gradient background
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.76, green: 0.31, blue: 0.96), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.93, green: 0.64, blue: 0.81), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 1, y: 1),
                        endPoint: UnitPoint(x: -0.24, y: -0.31)
                    )
                    
                    // Lottie animation - man showing muscles
                    LottieView(animation: .named("man-showing-muscles"))
                        .playing(loopMode: .loop)
                        .frame(width: 350, height: 350)
                }
                .frame(height: geometry.size.height * 0.55)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 150,
                        topTrailingRadius: 0
                    )
                )
                
                // Lower half with content
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Content section
                    VStack(spacing: 20) {
                        // Title
                        Text("Get Burn")
                            .font(Font.custom("Poppins", size: 28).weight(.bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        // Description
                        Text("Let's keep burning, to achieve yours goals, it hurts only temporarily, if you give up now you will be in pain forever")
                            .font(Font.custom("Poppins", size: 14).weight(.regular))
                            .foregroundColor(Color.gray.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                    
                    // Next button
                    HStack {
                        Spacer()
                        
                        CircularButton(icon: "chevron.right") {
                            // Navigate to next screen (to be implemented)
                            navigateToNext = true
                        }
                        .padding(.trailing, 30)
                        .padding(.bottom, 50)
                    }
                }
                .frame(height: geometry.size.height * 0.45)
                .background(Color.white)
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

#Preview {
    OnboardingView2()
} 