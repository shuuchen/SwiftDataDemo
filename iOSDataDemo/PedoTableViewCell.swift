//
//  PedoTableViewCell.swift
//  iOSDataDemo
//
//  Created by Du Shuchen on 2016/06/14.
//  Copyright © 2016年 Du Shuchen. All rights reserved.
//

import UIKit

class PedoTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
