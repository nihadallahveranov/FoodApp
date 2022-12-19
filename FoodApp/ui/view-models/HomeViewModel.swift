//
//  HomeViewModel.swift
//  FoodApp
//
//  Created by Nihad Allahveranov on 15.12.22.
//

import Foundation
import RxSwift

class HomeViewModel {
    var foods = BehaviorSubject<[Food]>(value: [Food]())
    var frepo = FoodsDaoRepo()
    
    init() {
        loadFoods()
        foods = frepo.foods
    }
    
    func loadFoods() {
        frepo.loadFoods()
    }
    
    func search(searchText: String, foods: [Food]) {
        frepo.search(searchText: searchText, foods: foods)
    }
    
    func loadFilteredFoods(isLowToHigh: Bool?, maxPrice: Int, minPrice: Int, category: String) {
        frepo.loadFilteredFoods(isLowToHigh: isLowToHigh, maxPrice: maxPrice, minPrice: minPrice, category: category)
    }
}
