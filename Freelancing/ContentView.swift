//
//  ContentView.swift
//  Freelancing
//
//  Created by Yaduraj Singh on 07/07/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authService: AuthenticationService
    
    var body: some View {
        NavigationView {
            if authService.user != nil {
                HomeView()
            } else {
                WelcomeView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
