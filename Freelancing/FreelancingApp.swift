//
//  FreelancingApp.swift
//  Freelancing
//
//  Created by Yaduraj Singh on 07/07/25.
//

import SwiftUI
import Firebase

@main
struct FreelancingApp: App {
    @StateObject private var authService = AuthenticationService()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService)
        }
    }
}
