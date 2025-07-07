//
//  ContentView.swift
//  Freelancing
//
//  Created by Yaduraj Singh on 07/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            WelcomeView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
