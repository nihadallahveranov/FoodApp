//
//  FoodCartResponse.swift
//  FoodApp
//
//  Created by Nihad Allahveranov on 20.12.22.
//

import Foundation

class FoodCartResponse: Codable {
    var foodsCart: [FoodCart]?
    
    enum CodingKeys: String, CodingKey {
        case foodsCart = "foods_cart"
    }
}
