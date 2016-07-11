//
//  VisitTableViewCell.swift
//  iOSDataDemo
//
//  Created by Du Shuchen on 2016/06/16.
//  Copyright © 2016年 Du Shuchen. All rights reserved.
//

import UIKit

class VisitTableViewCell: UITableViewCell {

    @IBOutlet weak var coordinate: UILabel!
    @IBOutlet weak var arrival: UILabel!
    @IBOutlet weak var departure: UILabel!
    @IBOutlet weak var area: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
