//
//  FoodViewCell.swift
//  FoodApp
//
//  Created by Nihad Allahveranov on 15.12.22.
//

import UIKit

class FoodViewCell: UITableViewCell {

    @IBOutlet weak var foodImg: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodCategory: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    

    @IBOutlet weak var foodCartImg: UIImageView!
    @IBOutlet weak var foodCartName: UILabel!
    @IBOutlet weak var foodCartCategory: UILabel!
    @IBOutlet weak var foodCartPrice: UILabel!
    @IBOutlet weak var foodCartQuantity: UILabel!
    
    var foodsCart = [FoodCart]()
    var viewModel = DetailViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        _ = viewModel.foodsCart.subscribe(onNext: { list in
            self.foodsCart = list
        })
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
        
        contentView.layer.cornerRadius = 10
    }

    @IBAction func btnDecreaseQuantity(_ sender: Any) {
        let quantity = changeOrderAmount(value: -1)
        if quantity != 0 {
            foodCartQuantity.text = "\(quantity - 1)"
        }
        
    }
    
    @IBAction func btnIncreaseQuantity(_ sender: Any) {
        let quantity = changeOrderAmount(value: 1)
        foodCartQuantity.text = "\(quantity + 1)"
    }
    
    func changeOrderAmount(value: Int) -> Int {
        
        guard let text = foodCartQuantity.text else {
            return 0
        }
        guard let quantity = Int(text) else {
            return 0
        }
        if quantity <= 1 && value == -1 {
            return 0
        }

        var orderAmountInCart = 0
        var food: Food?
        
        for (index, foodCart) in foodsCart.enumerated() {
            if index == 0 {
                food = Food(id: Int(),
                            name: foodCart.name!,
                            image: foodCart.image!,
                            price: foodCart.price!,
                            category: foodCart.category!)
            }
            if foodCart.name == food?.name! {
                orderAmountInCart += foodCart.orderAmount!
                viewModel.delete(cartId: foodCart.cartId!,
                                 userName: "nihadallahveranov")
            }
        }
        
        if let price = food?.price {
            foodCartPrice.text = "$\(price * (orderAmountInCart + value))"
        }
        
        viewModel.insertFood(food: food!,
                             orderAmount: orderAmountInCart + value,
                             userName: "nihadallahveranov")
        
        return quantity
    }
    
    weak var delegate: CustomCellUpdater?

    func yourFunctionWhichDoesNotHaveASender () {
        
    }
}

protocol CustomCellUpdater: class { // f
    func updateTableView()
}
