//
//  CalendarTableViewCell.swift
//  iOSDataDemo
//
//  Created by Du Shuchen on 2016/06/17.
//  Copyright © 2016年 Du Shuchen. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var organizer: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
