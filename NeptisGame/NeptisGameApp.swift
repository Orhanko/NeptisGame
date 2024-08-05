//
//  NeptisGameApp.swift
//  NeptisGame
//
//  Created by Orhan Pojskic on 05.08.2024..
//

import SwiftUI

@main
struct NeptisGameApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.isAuthenticated {
                HomeView()
                    .environmentObject(appState)
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut(duration: 0.5))
                    
            } else {
                LoginView().environmentObject(appState)
                    .transition(.push(from: .leading))
                    .animation(.easeInOut)
            }
        }
    }
}
