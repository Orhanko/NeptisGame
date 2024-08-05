//
//  LoginView.swift
//  NeptisGame
//
//  Created by Orhan Pojskic on 05.08.2024..
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isAuthenticated: Bool = false
    @State private var errorMessage: String?
    @FocusState private var hideKeyboardButton: Bool
    @State private var showRegisterView: Bool = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack{
            
            VStack{
                
                Text("Neptis Game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                Text("Login Page")
                    .font(.title2)
                    .foregroundStyle(.gray)
                    .fontWeight(.bold)
                
                
                
                
            }.padding(.top, 35)
            
            VStack {
                
                
                VStack(spacing: 25) {
                    TextField("Username", text: $username)
                        .focused($hideKeyboardButton)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .submitLabel(.done)
                    SecureField("Password", text: $password)
                        .focused($hideKeyboardButton)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .submitLabel(.done)
                }
                .padding(.horizontal)
                Button(action: {
                    withAnimation{
                        APIService.shared.login(username: username, password: password) { result in
                            switch result {
                            case .success(let user):
                                isAuthenticated = true
                                hideKeyboardButton = false
                                appState.isAuthenticated = true
                                errorMessage = nil // Resetovanje greške
                                print("User logged in: \(user.username)")
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
                    }) {
                    Text("Login")
                }.padding(.top, 30)
                
                
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .padding(.top)
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    // Prazan prostor koji čuva prostor za poruku o grešci
                    Text(" ")
                        .padding(.horizontal)
                        .padding(.top)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                HStack(spacing: 5){
                    Text("Don't have an account?")
                        .foregroundStyle(.placeholder)
                    Button(action: {
                        showRegisterView = true
                    }) {
                        Text("Register")
                            .foregroundColor(.blue)
                            .underline()
                    }
                    .sheet(isPresented: $showRegisterView) {
                        RegisterView()
                    }
                }.padding(.bottom, 10)
                //Spacer()
                
            }
            
            
            .padding(.top, 120)
        }
        
    
        
        .padding()
    }
}

#Preview {
    LoginView()
}
