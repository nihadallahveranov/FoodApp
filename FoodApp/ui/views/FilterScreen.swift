//
//  FilterScreen.swift
//  FoodApp
//
//  Created by Nihad Allahveranov on 15.12.22.
//

import UIKit

class FilterScreen: UIViewController {

    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    @IBOutlet weak var priceSegmentControl: UISegmentedControl!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lblMin: UILabel!
    @IBOutlet weak var lblMax: UILabel!
    
    var categories = [String]()
    var filter: Filter?
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        categorySegmentControl.removeAllSegments()
        
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.navigationBar.tintColor = UIColor(named: "redColor")
        
        for (index, item) in categories.enumerated() {
            categorySegmentControl.insertSegment(withTitle: item, at: index, animated: true)
        }
        
        if let filt = filter {
            lblMin.text = "$\(filt.minPrice!)"
            lblMax.text = "$\(filt.sliderValue!)"
            
            slider.value = Float(filt.sliderValue!)
            slider.minimumValue = Float(filt.minPrice!)
            slider.maximumValue = Float(filt.maxPrice!)
        }
        
        categorySegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "redColor")!], for: .selected)
        categorySegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        priceSegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(named: "redColor")!], for: .selected)
        priceSegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
    }
    
    @IBAction func slider(_ sender: Any) {
        lblMax.text = "$\(Int(slider.value))"
    }
    
    @IBAction func btnDone(_ sender: Any) {
        if let filt = filter {
            if priceSegmentControl.selectedSegmentIndex == 0 {
                filt.isLowToHigh = true
            } else if priceSegmentControl.selectedSegmentIndex == 1 {
                filt.isLowToHigh = false
            } else {
                filt.isLowToHigh = nil
            }
            filt.sliderValue = Int(slider.value)
            filt.category = categorySegmentControl.selectedSegmentIndex == -1 ? "None" : categorySegmentControl.titleForSegment(at: categorySegmentControl.selectedSegmentIndex)!
        }
        
        navigationController?.popViewController(animated: true)
    }
}

