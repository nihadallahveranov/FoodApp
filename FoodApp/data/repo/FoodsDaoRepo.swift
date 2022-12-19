//
//  FoodsDaoRepo.swift
//  FoodApp
//
//  Created by Nihad Allahveranov on 15.12.22.
//

import Foundation
import Alamofire
import RxSwift

class FoodsDaoRepo {
    var foods = BehaviorSubject<[Food]>(value: [Food]())
    
    func loadFoods() {
        AF.request("http://kasimadalan.pe.hu/foods/getAllFoods.php", method: .get).response { response in
            if let data = response.data {
                do {
                    let result = try JSONDecoder().decode(FoodResponse.self, from: data)
                    if let list = result.foods {
                        self.foods.onNext(list)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func search(searchText: String, foods: [Food]) {
        var list = [Food]()
        for food in foods {
            if food.name!.lowercased().contains(searchText.lowercased()) {
                list.append(food)
            }
        }
        self.foods.onNext(list)
    }
    
    func loadFilteredFoods(isLowToHigh: Bool?, maxPrice: Int, minPrice: Int, category: String) {
        AF.request("http://kasimadalan.pe.hu/foods/getAllFoods.php", method: .get).response { response in
            if let data = response.data {
                do {
                    let result = try JSONDecoder().decode(FoodResponse.self, from: data)
                    if let list = result.foods {
                        var filteredList = [Food]()
                        
                        for item in list {
                            if item.price! >= minPrice && item.price! <= maxPrice {
                                if category == "None" {
                                    filteredList.append(item)
                                } else {
                                    if item.category! == category {
                                        filteredList.append(item)
                                    }
                                }
                            }
                        }
                        
                        if let isLToH = isLowToHigh {
                            filteredList = isLToH ? filteredList.sorted(by: { $0.price! < $1.price!}) : filteredList.sorted(by: { $0.price! > $1.price!})
                        }
                        
                        print(filteredList)
                        
                        self.foods.onNext(filteredList)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
