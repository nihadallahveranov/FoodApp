//
//  DetailViewModel.swift
//  FoodApp
//
//  Created by Nihad Allahveranov on 20.12.22.
//

import Foundation

class DetailViewModel {
    var frepo = FoodsDaoRepo()
    
    func insertFood(food: Food, orderAmount: Int, userName: String) {
        frepo.insertFood(food: food, orderAmount: orderAmount, userName: userName)
    }
}
