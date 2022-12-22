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
    @IBOutlet weak var lblDelivery: UILabel!
    
    @IBOutlet weak var foodCartTableView: UITableView!
    
    var viewModel = CartViewModel()
    var foodsCart = [FoodCart]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodCartTableView.delegate = self
        foodCartTableView.dataSource = self
        
        foodCartTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        background.layer.cornerRadius = 27
    
        btnOrder.frame.size = CGSize(width: background.frame.size.width - 32, height: btnOrder.frame.size.height)
        
        _ = viewModel.foodsCart.subscribe(onNext: { list in
            self.foodsCart = list
            DispatchQueue.main.async {
                self.foodCartTableView.reloadData()
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadFoodsCart(userName: "nihadallahveranov")
        updateOrderPrices()
    }
    
    @IBAction func btnOrder(_ sender: Any) {
    }
    
    func updateOrderPrices() {
        var subTotal = 0
        
        for food in foodsCart {
            if let price = food.price, let orderAmount = food.orderAmount {
                subTotal += price * orderAmount
            }
        }
        
        if subTotal == 0 {
            lblTotal.text = "$\(subTotal)"
            lblDelivery.text = "$0"
            
        } else {
            lblTotal.text = "$\(subTotal + 5)"
            lblDelivery.text = "$5"
        }
        
        lblSubTotal.text = "$\(subTotal)"
    }
}

extension CartScreen: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tabBarItem.badgeValue = "\(foodsCart.count)"
        updateOrderPrices()
        return foodsCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let foodCart = self.foodsCart[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCartCell") as! FoodViewCell
        
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 54
        cell.layer.masksToBounds = true
        
        cell.foodCartName.text = foodCart.name
        cell.foodCartCategory.text = foodCart.category
        cell.foodCartPrice.text = "$\(foodCart.price! * foodCart.orderAmount!)"
        cell.foodCartQuantity.text = "\(foodCart.orderAmount!)"
        
        if let url = URL(string: "http://kasimadalan.pe.hu/foods/images/\(foodCart.image!)") {
            cell.foodCartImg.kf.setImage(with: url)
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let foodCart = foodsCart[indexPath.row]
//        let food = Food(id: 5, name: foodCart.name!, image: foodCart.image!, price: foodCart.price!, category: foodCart.category!)
//        performSegue(withIdentifier: "toDetail", sender: food)
//        foodCartTableView.deselectRow(at: indexPath, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .normal, title: nil) {
            (action, view, bool) in
            
            let foodCart = self.foodsCart[indexPath.row]

            let alert = UIAlertController(title: "Deletion Process", message: "Do you want to delete \(foodCart.name!) ?", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancelAction)

            let yesAction = UIAlertAction(title: "Yes", style: .destructive) { action in
                self.viewModel.delete(cartId: foodCart.cartId!, userName: "nihadallahveranov")
            }
            
            alert.addAction(yesAction)
            self.present(alert, animated: true)
            
        }

        deleteAction.backgroundColor = UIColor(named: "pinkColor")
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(UIColor(named: "redColor")!, renderingMode: .alwaysOriginal)

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

