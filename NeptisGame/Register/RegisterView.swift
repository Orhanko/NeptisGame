//
//  RegisterView.swift
//  NeptisGame
//
//  Created by Orhan Pojskic on 05.08.2024..
//

import SwiftUI

struct RegisterView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var age: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @FocusState private var hideKeyboardButton: Bool
    @EnvironmentObject var appState: AppState

    var body: some View {
        
            VStack {
                VStack{
                    
                    Text("Neptis Game")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Text("Register Page")
                        .font(.title2)
                        .foregroundStyle(.gray)
                        .fontWeight(.bold)
                    
                    
                    
                    
                }.padding(.top, 60)
                
                VStack(spacing: 25){
                                TextField("First Name", text: $firstName)
                                    .focused($hideKeyboardButton)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .submitLabel(.done)
                                                

                                TextField("Last Name", text: $lastName)
                                    .focused($hideKeyboardButton)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .submitLabel(.done)

                                TextField("Age", text: $age)
                                    .focused($hideKeyboardButton)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .submitLabel(.done)

                                TextField("Username", text: $username)
                                    .focused($hideKeyboardButton)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .submitLabel(.done)

                                SecureField("Password", text: $password)
                                    .focused($hideKeyboardButton)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .submitLabel(.done)
                            }
                .padding(.top, 40)
                                            

                    
                    
                        
                    
                    Button(action: {
                        guard let ageInt = Int(age) else {
                            errorMessage = "Please enter a valid age."
                            return
                        }
                        APIService.shared.register(firstName: firstName, lastName: lastName, age: ageInt, username: username, password: password) { result in
                            switch result {
                            case .success(let user):
                                print("User registered: \(user.username)")
                                appState.isAuthenticated = true
                                errorMessage = nil
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    }) {
                        Text("Register")
                    }.padding(.top, 30)
                
                
                .padding(.horizontal)
                
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
                
                Spacer() // Održava prostor na dnu
                    //.padding(.top, 120)
            }
            
            
        
        
        .padding()
    }
}

#Preview {
    RegisterView()
}
