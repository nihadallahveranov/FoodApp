//
//  DetailScreen.swift
//  FoodApp
//
//  Created by Nihad Allahveranov on 20.12.22.
//

import UIKit
import Kingfisher

class DetailScreen: UIViewController {

    @IBOutlet weak var foodImg: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodCategory: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    @IBOutlet weak var foodQuantity: UILabel!
    
    var food: Food?
    var foodsCart = [FoodCart]()
    
    var viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(named: "redColor")
        
        if let food = self.food, let url = URL(string: "http://kasimadalan.pe.hu/foods/images/\(food.image!)") {
            foodImg.kf.setImage(with: url)
            foodName.text = food.name!
            foodCategory.text = food.category!
            foodPrice.text = "$\(food.price!)"
        }
        
        _ = viewModel.foodsCart.subscribe(onNext: { list in
            self.foodsCart = list
        })
    }
    
    @IBAction func btnDecreaseQuantity(_ sender: Any) {
        guard let text = foodQuantity.text else {
            return
        }
        guard let quantity = Int(text) else {
            return
        }
        if quantity > 1 {
            foodQuantity.text = "\(quantity - 1)"
            if let food = self.food {
                foodPrice.text = "$\((quantity - 1) * food.price!)"
            }
        }
    }
    
    @IBAction func btnIncreaseQuantity(_ sender: Any) {
        guard let text = foodQuantity.text else {
            return
        }
        guard let quantity = Int(text) else {
            return
        }
        foodQuantity.text = "\(quantity + 1)"
        if let food = self.food {
            foodPrice.text = "$\((quantity + 1) * food.price!)"
        }
    }
    
    @IBAction func addToCart(_ sender: Any) {
        if let orderAmount = Int(foodQuantity.text!), let food = self.food {

            var orderAmountInCart = 0
            
            for foodCart in foodsCart {
                if foodCart.name == food.name {
                    orderAmountInCart += foodCart.orderAmount!
                    viewModel.delete(cartId: foodCart.cartId!, userName: "nihadallahveranov")
                }
            }
            
            viewModel.insertFood(food: food, orderAmount: orderAmount + orderAmountInCart, userName: "nihadallahveranov")
            
            let alert = UIAlertController(title: "\(food.name!)", message: "Added to your cart", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .destructive)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
}
