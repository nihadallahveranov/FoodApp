//
//  DetailViewModel.swift
//  FoodApp
//
//  Created by Nihad Allahveranov on 20.12.22.
//

import Foundation
import RxSwift

class DetailViewModel {
    var frepo = FoodsDaoRepo()
    var foodsCart = BehaviorSubject<[FoodCart]>(value: [FoodCart]())
    
    init() {
        loadFoodsCart(userName: "nihadallahveranov")
        foodsCart = frepo.foodsCart
    }
    
    func insertFood(food: Food, orderAmount: Int, userName: String) {
        frepo.insertFood(food: food, orderAmount: orderAmount, userName: userName)
    }
    
    func loadFoodsCart(userName: String) {
        frepo.loadFoodsCart(userName: userName)
    }
    
    func delete(cartId: Int, userName: String) {
        frepo.delete(cartId: cartId, userName: userName)
    }
}
