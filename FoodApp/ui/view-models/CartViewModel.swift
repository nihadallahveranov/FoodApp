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
        loadFoodsCart(userName: "nihadallahveranov")
        foodsCart = frepo.foodsCart
    }
    
    func loadFoodsCart(userName: String) {
        frepo.loadFoodsCart(userName: userName)
    }
    
    func delete(cartId: Int, userName: String) {
        frepo.delete(cartId: cartId, userName: userName)
    }
}
