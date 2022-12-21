//
//  CartScreen.swift
//  FoodApp
//
//  Created by Nihad Allahveranov on 20.12.22.
//

import UIKit

class CartScreen: UIViewController {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var btnOrder: UIButton!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    var viewModel = CartViewModel()
    var foodsCart = [FoodCart]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background.layer.cornerRadius = 27
    
        btnOrder.frame.size = CGSize(width: background.frame.size.width - 32, height: btnOrder.frame.size.height)
        
        _ = viewModel.foodsCart.subscribe(onNext: { list in
            self.foodsCart = list
            DispatchQueue.main.async {
//                self.foodTableView.reloadData()
            }
        })
    }

    @IBAction func btnOrder(_ sender: Any) {
        viewModel.loadFoodsCart(username: "nihadallahveranov")
        
//        print(self.foodsCart)
    }
}
