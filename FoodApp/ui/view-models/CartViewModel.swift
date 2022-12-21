//
//  CartViewModel.swift
//  FoodApp
//
//  Created by Nihad Allahveranov on 20.12.22.
//

import Foundation
import RxSwift

class CartViewModel {
    
    var foodsCart = BehaviorSubject<[FoodCart]>(value: [FoodCart]())
    var frepo = FoodsDaoRepo()
    
    init() {
        loadFoodsCart(username: "nihadallahveranov")
        foodsCart = frepo.foodsCart
    }
    
    func loadFoodsCart(username: String) {
        frepo.loadFoodsCart(username: username)
    }
}
