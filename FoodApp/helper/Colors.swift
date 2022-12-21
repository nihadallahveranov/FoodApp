//
//  Colors.swift
//  FoodApp
//
//  Created by Nihad Allahveranov on 20.12.22.
//

import Foundation
import UIKit

class Colors {
    var gl:CAGradientLayer!

    init() {
        let colorTop = UIColor(named: "redColor")!.cgColor
        let colorBottom = UIColor(named: "pinkColor")!.cgColor

        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}
