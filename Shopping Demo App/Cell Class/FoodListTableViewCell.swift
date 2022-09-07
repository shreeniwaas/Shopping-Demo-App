//
//  FoodListTableView.swift
//  Shopping Demo App
//
//  Created by Srinivas Katta on 07/09/22.
//

import UIKit

class FoodListTableViewCell: UITableViewCell {

    @IBOutlet var foodListImage : UIImageView!
    @IBOutlet var foodListName : UILabel!
    @IBOutlet var foodListSize : UILabel!
    @IBOutlet var foodListPriz : UILabel!
    
    var quantitySelectDropDownButtonClicked : (() -> ())?


    override func awakeFromNib() {
        super.awakeFromNib()
        foodListImage.layer.cornerRadius = 20
        foodListImage.layer.masksToBounds = true
    }
    
    @IBAction func dropDownFilterAction(_sender: UIButton){
        quantitySelectDropDownButtonClicked?()
    }
}


