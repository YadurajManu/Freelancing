//
//  WelcomeView.swift
//  Freelancing
//
//  Created by Yaduraj Singh on 07/07/25.
//

import SwiftUI

struct WelcomeView: View {
    @State private var navigateToOnboarding = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Logo and Title Section
                    VStack(spacing: 16) {
                        // Main Title
                        HStack(spacing: 0) {
                            Text("DIDPOOL")
                                .font(Font.custom("Poppins", size: 36).weight(.bold))
                                .foregroundColor(Color(red: 0.8, green: 0.56, blue: 0.93))
                            
                            Text("Fit")
                                .font(Font.custom("Poppins", size: 36).weight(.bold))
                                .foregroundColor(.black)
                        }
                        
                        // Tagline
                        Text("Everybody Can Train")
                            .font(Font.custom("Poppins", size: 16).weight(.regular))
                            .foregroundColor(Color.gray.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    // Get Started Button
                    NavigationLink(destination: OnboardingView(), isActive: $navigateToOnboarding) {
                        EmptyView()
                    }
                    
                    GradientButton(title: "Get Started") {
                        navigateToOnboarding = true
                    }
                    .padding(.bottom, 50)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    WelcomeView()
} 