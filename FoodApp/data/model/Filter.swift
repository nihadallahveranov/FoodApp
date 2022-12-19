//
//  Filter.swift
//  FoodApp
//
//  Created by Nihad Allahveranov on 16.12.22.
//

import Foundation

class Filter {
    var isFiltered: Bool?
    var isLowToHigh: Bool?
    var sliderValue: Int?
    var minPrice: Int?
    var maxPrice: Int?
    var category: String?
    
    init(isFiltered: Bool, isLowToHigh: Bool?, sliderValue: Int, minPrice: Int, maxPrice: Int, category: String) {
        self.isFiltered = isFiltered
        self.isLowToHigh = isLowToHigh
        self.sliderValue = sliderValue
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.category = category
    }
}
