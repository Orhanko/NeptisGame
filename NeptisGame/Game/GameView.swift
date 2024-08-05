//
//  GameView.swift
//  NeptisGame
//
//  Created by Orhan Pojskic on 05.08.2024..
//

import SwiftUI

struct GameView: View {
    @State private var recipes: [Recipe] = []
    @State private var currentRecipeIndex: Int = 0
    @State private var userScore: Int = 0
    @State private var opponentScore: Int = 0
    @State private var attempts: Int = 1
    @State private var userGuess: String = ""
    @State private var allTags: [String] = []
    @State private var showResultAlert: Bool = false
    @State private var resultMessage: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("You vs your opponent")
                .font(.largeTitle)
                .padding()

            Text("Your score: \(userScore)")
            Text("Opponent's score: \(opponentScore)")
            Text("Attempts: \(attempts)/10")
                .padding()

            if !recipes.isEmpty {
                Text("Recipe: \(recipes[currentRecipeIndex].name)")
                    .font(.title)
                    .padding()

                TextField("Enter your guess", text: $userGuess)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: submitGuess) {
                    Text("Submit")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            } else {
                Text("Loading recipes...")
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
        .onAppear {
            fetchRecipes()
            fetchAllTags()
        }
        .alert(isPresented: $showResultAlert) {
            Alert(
                title: Text("Game Over"),
                message: Text(resultMessage),
                dismissButton: .default(Text("OK")) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }

    private func fetchRecipes() {
        APIService.shared.getAllRecipes { result in
            switch result {
            case .success(let recipes):
                self.recipes = recipes
            case .failure(let error):
                print("Error fetching recipes: \(error.localizedDescription)")
            }
        }
    }

    private func fetchAllTags() {
        APIService.shared.getAllTags { result in
            switch result {
            case .success(let tags):
                self.allTags = tags
                print("Fetched tags: \(tags)")
            case .failure(let error):
                print("Error fetching tags: \(error.localizedDescription)")
            }
        }
    }

    private func submitGuess() {
        guard !recipes.isEmpty else { return }

        let currentRecipe = recipes[currentRecipeIndex]
        if currentRecipe.tags.contains(userGuess.capitalized) {
            userScore += 1
        }

        // Simulate opponent's guess
        if let opponentGuess = allTags.randomElement() {
            print(opponentGuess)
            if currentRecipe.tags.contains(opponentGuess) {
                opponentScore += 1
            }
        }

        userGuess = ""
        attempts += 1

        if attempts > 10 {
            showResultAlert = true
            resultMessage = userScore > opponentScore ? "You won! Congrats!" : "You lost! More luck next time…"
        } else {
            currentRecipeIndex = (currentRecipeIndex + 1) % recipes.count
        }
    }
}

#Preview {
    GameView()
}
