//
//  AuthenticationService.swift
//  Freelancing
//
//  Created by Yaduraj Singh on 07/07/25.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import CryptoKit

class AuthenticationService: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    init() {
        user = Auth.auth().currentUser
    }
    
    // MARK: - Email/Password Registration
    func registerWithEmail(email: String, password: String, fullName: String, phoneNumber: String) async {
        isLoading = true
        errorMessage = ""
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Update user profile with display name
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = fullName
            try await changeRequest.commitChanges()
            
            // Save additional user data to Firestore
            await saveUserData(
                userId: result.user.uid,
                email: email,
                fullName: fullName,
                phoneNumber: phoneNumber
            )
            
            await MainActor.run {
                self.user = result.user
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Email/Password Login
    func loginWithEmail(email: String, password: String) async {
        isLoading = true
        errorMessage = ""
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            await MainActor.run {
                self.user = result.user
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Google Sign-In
    func signInWithGoogle() async {
        guard let presentingViewController = await MainActor.run(body: {
            return UIApplication.shared.windows.first?.rootViewController
        }) else {
            errorMessage = "Unable to find presenting view controller"
            return
        }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Unable to get client ID"
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        isLoading = true
        errorMessage = ""
        
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                errorMessage = "Unable to get ID token"
                isLoading = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )
            
            let authResult = try await Auth.auth().signIn(with: credential)
            
            // Save user data to Firestore
            await saveUserData(
                userId: authResult.user.uid,
                email: authResult.user.email ?? "",
                fullName: authResult.user.displayName ?? "",
                phoneNumber: authResult.user.phoneNumber ?? ""
            )
            
            await MainActor.run {
                self.user = authResult.user
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Apple Sign-In
    func signInWithApple() async {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        do {
            let authorization = try await withCheckedThrowingContinuation { continuation in
                let delegate = AppleSignInDelegate(continuation: continuation)
                authorizationController.delegate = delegate
                authorizationController.presentationContextProvider = delegate
                authorizationController.performRequests()
            }
            
            guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
                  let appleIDToken = appleIDCredential.identityToken,
                  let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                errorMessage = "Unable to get Apple ID token"
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                    idToken: idTokenString,
                                                    rawNonce: nonce)
            
            isLoading = true
            let authResult = try await Auth.auth().signIn(with: credential)
            
            // Save user data to Firestore
            let fullName = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")".trimmingCharacters(in: .whitespaces)
            
            await saveUserData(
                userId: authResult.user.uid,
                email: appleIDCredential.email ?? authResult.user.email ?? "",
                fullName: fullName.isEmpty ? authResult.user.displayName ?? "" : fullName,
                phoneNumber: ""
            )
            
            await MainActor.run {
                self.user = authResult.user
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            user = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Save User Data to Firestore
    private func saveUserData(userId: String, email: String, fullName: String, phoneNumber: String) async {
        let userData: [String: Any] = [
            "email": email,
            "fullName": fullName,
            "phoneNumber": phoneNumber,
            "createdAt": Timestamp(date: Date()),
            "lastUpdated": Timestamp(date: Date())
        ]
        
        do {
            try await Firestore.firestore().collection("users").document(userId).setData(userData, merge: true)
        } catch {
            print("Error saving user data: \(error)")
        }
    }
    
    // MARK: - Helper Functions for Apple Sign-In
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

// MARK: - Apple Sign-In Delegate
class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private let continuation: CheckedContinuation<ASAuthorization, Error>
    
    init(continuation: CheckedContinuation<ASAuthorization, Error>) {
        self.continuation = continuation
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        continuation.resume(returning: authorization)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation.resume(throwing: error)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? UIWindow()
    }
} 