//
//  FoodCart.swift
//  FoodApp
//
//  Created by Nihad Allahveranov on 20.12.22.
//

import Foundation

class FoodCart: Codable {
    var cartId: Int?
    var name: String?
    var image: String?
    var price: Int?
    var category: String?
    var orderAmount: Int?
    var userName: String?
    
    init(cartId: Int, name: String, image: String, price: Int, category: String, orderAmount: Int, userName: String) {
        self.cartId = cartId
        self.name = name
        self.image = image
        self.price = price
        self.category = category
        self.orderAmount = orderAmount
        self.userName = userName
    }
}
