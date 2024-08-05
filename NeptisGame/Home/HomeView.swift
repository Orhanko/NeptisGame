//
//  HomeView.swift
//  NeptisGame
//
//  Created by Orhan Pojskic on 05.08.2024..
//

import SwiftUI

struct HomeView: View {
    @State private var users: [User] = []
    @State private var errorMessage: String?
    @EnvironmentObject var appState: AppState
    @State private var showGameView: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                List(users) { user in
                    VStack(alignment: .leading) {
                        Text("\(user.firstName) \(user.lastName)")
                        //.font(.headline)
                        //                        Text("Username: \(user.username)")
                        //                            .font(.subheadline)
                    }
                    .onTapGesture {
                        showPlayGamePrompt(for: user)
                    }
                }
            }
            .navigationBarTitle("Users")
            .onAppear {
                fetchUsers()
            }
            .navigationBarItems(trailing: Button(action: {
                withAnimation{
                    appState.isAuthenticated = false
                }
            }) {
                Text("Logout")
            })
            .sheet(isPresented: $showGameView) {
                GameView()
            }
        }
        
        
    }

    private func fetchUsers() {
        APIService.shared.getAllUsers { result in
            switch result {
            case .success(let users):
                self.users = users
                self.errorMessage = nil
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    private func showPlayGamePrompt(for user: User) {
            let alert = UIAlertController(title: "Play Game", message: "Do you want to play guess name with \(user.username)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yay!", style: .default, handler: { _ in
                showGameView = true
            }))
            alert.addAction(UIAlertAction(title: "Naah", style: .cancel, handler: nil))

            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
}

#Preview {
    HomeView()
}
