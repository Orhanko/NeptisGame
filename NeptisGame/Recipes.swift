//
//  Recipes.swift
//  NeptisGame
//
//  Created by Orhan Pojskic on 05.08.2024..
//

import Foundation

struct Recipe: Identifiable, Codable {
    let id: Int
    let name: String
    let tags: [String]
}
