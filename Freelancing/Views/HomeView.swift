//
//  HomeView.swift
//  Freelancing
//
//  Created by Yaduraj Singh on 07/07/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authService: AuthenticationService
    
    var body: some View {
        VStack(spacing: 30) {
            // Welcome Section
            VStack(spacing: 16) {
                Text("Welcome to DIDPOOLFit!")
                    .font(Font.custom("Poppins", size: 24).weight(.bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                if let user = authService.user {
                    Text("Hello, \(user.displayName ?? user.email ?? "User")!")
                        .font(Font.custom("Poppins", size: 16).weight(.regular))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.top, 100)
            
            Spacer()
            
            // User Info Card
            if let user = authService.user {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Account Information")
                        .font(Font.custom("Poppins", size: 18).weight(.semibold))
                        .foregroundColor(.black)
                    
                    if let email = user.email {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.gray)
                            Text(email)
                                .font(Font.custom("Poppins", size: 14))
                                .foregroundColor(.black)
                        }
                    }
                    
                    if let displayName = user.displayName {
                        HStack {
                            Image(systemName: "person")
                                .foregroundColor(.gray)
                            Text(displayName)
                                .font(Font.custom("Poppins", size: 14))
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(20)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 30)
            }
            
            Spacer()
            
            // Sign Out Button
            Button(action: {
                authService.signOut()
            }) {
                Text("Sign Out")
                    .font(Font.custom("Poppins", size: 16).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.red)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
        }
        .navigationBarHidden(true)
        .background(Color.white)
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthenticationService())
} 