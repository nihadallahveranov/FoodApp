//
//  HomeScreen.swift
//  FoodApp
//
//  Created by Nihad Allahveranov on 12.12.22.
//

import UIKit
import RxSwift
import Kingfisher

class HomeScreen: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    var foods = [Food]()
    var viewModel = HomeViewModel()
    var filterScreen = FilterScreen()
    var filter: Filter?
    var filters = [String]()
    var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.backgroundColor = UIColor(named: "mainColor")
        self.tabBarController?.tabBar.tintColor = UIColor(named: "redColor")
        
        foodTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        foodTableView.delegate = self
        foodTableView.dataSource = self
        searchBar.delegate = self
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 136, height: self.categoryCollectionView.frame.size.height)
        layout.scrollDirection = .horizontal
        
        categoryCollectionView.collectionViewLayout = layout
        
        _ = viewModel.foods.subscribe(onNext: { list in
            self.foods = list
            DispatchQueue.main.async {
                self.foodTableView.reloadData()
            }
        })
        
        _ = viewModel.foodsCart.subscribe(onNext: { list in
            DispatchQueue.main.async {
                if let tabsItem = self.tabBarController?.tabBar.items {
                    let item = tabsItem[1]
                    item.badgeValue = "\(list.count)"
                }
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        viewModel.loadFoodsCart(userName: "nihadallahveranov")
        
        filters.removeAll()
        
        filters.append("All")
        
        if let filter = filterScreen.filter {
            if let isLowToHigh = filter.isLowToHigh {
                filters.append(isLowToHigh ? "Low to High ✕" : "High to Low ✕")
            }
            if filter.sliderValue! < 15 {
                filters.append("< \(filter.sliderValue!) ✕")
            }
            if filter.category != "None" {
                filters.append("\(filter.category!) ✕")
            }
        }
    
        categoryCollectionView.reloadData()
        
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        if let filter = filterScreen.filter {
            viewModel.loadFilteredFoods(
                isLowToHigh: filter.isLowToHigh,
                maxPrice: filter.sliderValue!,
                minPrice: filter.minPrice!,
                category: filter.category!)
            
            self.filter = Filter(
                isFiltered: filter.isFiltered!,
                isLowToHigh: filter.isLowToHigh,
                sliderValue: filter.sliderValue!,
                minPrice: filter.minPrice!,
                maxPrice: filter.maxPrice!,
                category: filter.category!)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFilter" {
            let filterScreen = segue.destination as! FilterScreen
            self.filterScreen = filterScreen
            
            filterScreen.categories = categories
            if let filter = self.filter {
                filterScreen.filter = Filter(
                    isFiltered: filter.isFiltered!,
                    isLowToHigh: filter.isLowToHigh,
                    sliderValue: filter.sliderValue!,
                    minPrice: filter.minPrice!,
                    maxPrice: filter.maxPrice!,
                    category: filter.category!)
            }
        } else if segue.identifier == "toDetail" {
            let detailScreen = segue.destination as! DetailScreen
            if let food = sender as? Food {
                detailScreen.food = food
            }
        }
    }
    
    @IBAction func btnShowFilterScreen(_ sender: Any) {
        
        if let filter = filterScreen.filter {
            self.filter = Filter(
                isFiltered: true,
                isLowToHigh: filter.isLowToHigh,
                sliderValue: filter.sliderValue!,
                minPrice: filter.minPrice!,
                maxPrice: filter.maxPrice!,
                category: "None")
        } else {
            // initialize filter
            
            var minPrice = foods[0].price ?? 0
            var maxPrice = foods[0].price ?? 0
            
            for item in foods {
                if let category = item.category {
                    if !self.categories.contains(category) {
                        self.categories.append(category)
                    }
                }
                if minPrice > item.price! {
                    minPrice = item.price!
                }
                if maxPrice < item.price! {
                    maxPrice = item.price!
                }
            }
            
            self.filter = Filter(isFiltered: true, isLowToHigh: nil, sliderValue: maxPrice, minPrice: minPrice, maxPrice: maxPrice, category: "None")
        }
    }
    
    func runLoadFilteredFoods(isLowToHigh: Bool, maxPrice: Int, minPrice: Int, category: String) {
        viewModel.loadFilteredFoods(isLowToHigh: isLowToHigh, maxPrice: maxPrice, minPrice: minPrice, category: category)
    }
    
}

extension HomeScreen : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespaces) == "" {
            if let filter = filterScreen.filter {
                viewModel.loadFilteredFoods(
                    isLowToHigh: filter.isLowToHigh,
                    maxPrice: filter.sliderValue!,
                    minPrice: filter.minPrice!,
                    category: filter.category!)
            } else {
                viewModel.loadFoods()
            }
        } else {
            viewModel.search(searchText: searchText, foods: self.foods)
        }
    }
}

extension HomeScreen: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let food = self.foods[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell") as! FoodViewCell
        
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 54
        cell.layer.masksToBounds = true
        
        cell.foodName.text = food.name
        cell.foodCategory.text = food.category
        cell.foodPrice.text = "$\(food.price!)"
        if let url = URL(string: "http://kasimadalan.pe.hu/foods/images/\(food.image!)") {
            cell.foodImg.kf.setImage(with: url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = foods[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: food)
        foodTableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension HomeScreen: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filter = filters[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        
        cell.lblCategory.text = filter
        
        cell.backgroundColor = UIColor(named: "redColor")
        cell.layer.cornerRadius = 15
        
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        
        return cell
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.categoryCollectionView)
        let indexPath = self.categoryCollectionView.indexPathForItem(at: location)
        
        if let index = indexPath {
            let lblText = (self.categoryCollectionView.cellForItem(at: index)?.viewWithTag(9) as? UILabel)?.text
            let text = lblText?.split(separator: "✕")[0]
            
            for (index, item) in filters.enumerated() {
                if lblText == "All" {
                    filters.removeAll()
                    filters.append("All")
                    break
                }
                if item == lblText {
                    filters.remove(at: index)
                }
            }
            
            categoryCollectionView.reloadData()
            
            if let filter = self.filter {
                if index.item == 0 {
                    filter.isLowToHigh = nil
                    filter.sliderValue = filter.maxPrice!
                    filter.category = "None"
                    viewModel.loadFoods()
                } else if text == "High to Low " || text == "Low to High " {
                    filter.isLowToHigh = nil
                } else if text! == "\(filter.category!) " {
                    filter.category = "None"
                } else if text! == "< \(filter.sliderValue!) " {
                    filter.sliderValue = filter.maxPrice!
                }
                
                viewModel.loadFilteredFoods(isLowToHigh: filter.isLowToHigh, maxPrice: filter.sliderValue!, minPrice: filter.minPrice!, category: filter.category!)
                filterScreen.filter = Filter(
                    isFiltered: filter.isFiltered!,
                    isLowToHigh: filter.isLowToHigh,
                    sliderValue: filter.sliderValue!,
                    minPrice: filter.minPrice!,
                    maxPrice: filter.maxPrice!,
                    category: filter.category!)
            }
        }
    }

}
