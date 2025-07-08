//
//  OnboardingView.swift
//  Freelancing
//
//  Created by Yaduraj Singh on 07/07/25.
//

import SwiftUI
import Lottie

struct OnboardingView: View {
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
                    
                    // Lottie animation
                    LottieView(animation: .named("girl-doing-yoga"))
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
                        Text("Track Your Goal")
                            .font(Font.custom("Poppins", size: 28).weight(.bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        // Description
                        Text("Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals")
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
                        
                        NavigationLink(destination: OnboardingView2(), isActive: $navigateToNext) {
                            EmptyView()
                        }
                        
                        CircularButton(icon: "chevron.right") {
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
    OnboardingView()
} 
