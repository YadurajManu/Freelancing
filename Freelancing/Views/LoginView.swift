//
//  LoginView.swift
//  Freelancing
//
//  Created by Yaduraj Singh on 07/07/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authService: AuthenticationService
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var showAlert = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Section
                VStack(spacing: 16) {
                    Text("Hey there,")
                        .font(Font.custom("Poppins", size: 16).weight(.regular))
                        .foregroundColor(Color.gray)
                        .padding(.top, 40)
                    
                    Text("Welcome Back")
                        .font(Font.custom("Poppins", size: 20).weight(.bold))
                        .foregroundColor(.black)
                }
                .padding(.bottom, 40)
                
                // Form Fields
                VStack(spacing: 20) {
                    // Email Field
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        TextField("Email", text: $email)
                            .font(Font.custom("Poppins", size: 14))
                            .foregroundColor(.black)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Password Field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                                .font(Font.custom("Poppins", size: 14))
                                .foregroundColor(.black)
                        } else {
                            SecureField("Password", text: $password)
                                .font(Font.custom("Poppins", size: 14))
                                .foregroundColor(.black)
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
                
                // Forgot Password
                HStack {
                    Spacer()
                    Button("Forgot your password?") {
                        // Handle forgot password
                    }
                    .font(Font.custom("Poppins", size: 12))
                    .foregroundColor(Color.gray)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
                
                // Login Button
                GradientButton(title: authService.isLoading ? "Signing In..." : "Login") {
                    if email.isEmpty || password.isEmpty {
                        authService.errorMessage = "Please fill in all fields"
                        showAlert = true
                        return
                    }
                    
                    Task {
                        await authService.loginWithEmail(email: email, password: password)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
                
                // Or Divider
                HStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                    
                    Text("Or")
                        .font(Font.custom("Poppins", size: 14))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1)
                }
                .padding(.horizontal, 50)
                .padding(.bottom, 30)
                
                // Social Login Buttons
                HStack(spacing: 20) {
                    // Google Button
                    Button(action: {
                        Task {
                            await authService.signInWithGoogle()
                        }
                    }) {
                        Image("google-logo-png-suite-everything-you-need-know-about-google-newest-0 2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .frame(width: 60, height: 60)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .cornerRadius(12)
                    }
                    
                    // Apple Button
                    Button(action: {
                        Task {
                            await authService.signInWithApple()
                        }
                    }) {
                        Image(systemName: "apple.logo")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                            .frame(width: 60, height: 60)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .cornerRadius(12)
                    }
                }
                .padding(.bottom, 40)
                
                // Don't have account
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Don't have an account yet? ")
                        .font(Font.custom("Poppins", size: 14))
                        .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))
                    + Text("Register")
                        .font(Font.custom("Poppins", size: 14))
                        .foregroundColor(Color(red: 0.8, green: 0.56, blue: 0.93))
                }
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .background(Color.white)
        .alert("Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(authService.errorMessage)
        }
        .onChange(of: authService.errorMessage) { errorMessage in
            if !errorMessage.isEmpty {
                showAlert = true
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationService())
} 