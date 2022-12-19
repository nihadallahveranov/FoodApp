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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
    }

}
