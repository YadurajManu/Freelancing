//
//  RegistrationView.swift
//  Freelancing
//
//  Created by Yaduraj Singh on 07/07/25.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var authService: AuthenticationService
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var acceptTerms = false
    @State private var navigateToLogin = false
    @State private var showAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Section
                VStack(spacing: 16) {
                    Text("Hey there,")
                        .font(Font.custom("Poppins", size: 16).weight(.regular))
                        .foregroundColor(Color.gray)
                        .padding(.top, 40)
                    
                    Text("Create an Account")
                        .font(Font.custom("Poppins", size: 20).weight(.bold))
                        .foregroundColor(.black)
                }
                .padding(.bottom, 40)
                
                // Form Fields
                VStack(spacing: 20) {
                    // Full Name Field
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        TextField("Full Name", text: $fullName)
                            .font(Font.custom("Poppins", size: 14))
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Phone Number Field
                    HStack {
                        Image(systemName: "phone")
                            .foregroundColor(.gray)
                            .frame(width: 20)
                        
                        TextField("Phone Number", text: $phoneNumber)
                            .font(Font.custom("Poppins", size: 14))
                            .foregroundColor(.black)
                            .keyboardType(.phonePad)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
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
                .padding(.bottom, 30)
                
                // Terms and Conditions
                HStack(alignment: .top, spacing: 12) {
                    Button(action: {
                        acceptTerms.toggle()
                    }) {
                        Image(systemName: acceptTerms ? "checkmark.square.fill" : "square")
                            .foregroundColor(acceptTerms ? Color(red: 0.8, green: 0.56, blue: 0.93) : .gray)
                            .font(.system(size: 16))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("By continuing you accept our ")
                            .font(Font.custom("Poppins", size: 12))
                            .foregroundColor(.gray)
                        + Text("Privacy Policy")
                            .font(Font.custom("Poppins", size: 12))
                            .foregroundColor(Color(red: 0.8, green: 0.56, blue: 0.93))
                        + Text(" and ")
                            .font(Font.custom("Poppins", size: 12))
                            .foregroundColor(.gray)
                        + Text("Term of Use")
                            .font(Font.custom("Poppins", size: 12))
                            .foregroundColor(Color(red: 0.8, green: 0.56, blue: 0.93))
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
                
                // Register Button
                GradientButton(title: authService.isLoading ? "Creating Account..." : "Register") {
                    if !acceptTerms {
                        authService.errorMessage = "Please accept the terms and conditions"
                        showAlert = true
                        return
                    }
                    
                    if fullName.isEmpty || email.isEmpty || password.isEmpty {
                        authService.errorMessage = "Please fill in all required fields"
                        showAlert = true
                        return
                    }
                    
                    Task {
                        await authService.registerWithEmail(
                            email: email,
                            password: password,
                            fullName: fullName,
                            phoneNumber: phoneNumber
                        )
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
                
                // Already have account
                NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                    EmptyView()
                }
                
                Button(action: {
                    navigateToLogin = true
                }) {
                    Text("Already have an account? ")
                        .font(Font.custom("Poppins", size: 14))
                        .foregroundColor(Color(red: 0.12, green: 0.09, blue: 0.09))
                    + Text("Login")
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
    RegistrationView()
} 
