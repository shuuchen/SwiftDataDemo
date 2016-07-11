//
//  ViewController.swift
//  iOSDataDemo
//
//  Created by Du Shuchen on 2016/06/14.
//  Copyright © 2016年 Du Shuchen. All rights reserved.
//

import UIKit
import CoreMotion

class PedometerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateTable: UITableView!
    
    var pedoItems = [PedoItem]()
    let itemName = ["start date", "end date", "steps", "distance", "floors ascended", "floors descended", "current secondes per meter", "current steps per second"]
    var itemValue = [AnyObject?]()
    
    var pedo: CMPedometer!
    var fromDate: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pedo = CMPedometer()
        
        dateTable.delegate = self
        dateTable.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        pedo.stopPedometerUpdates()
    }
    
    @IBAction func dateChanged(sender: AnyObject) {
        
        fromDate = datePicker.date
    }

    @IBAction func searchFromDate(sender: AnyObject) {
        
        guard fromDate != nil else {
        
            print("error: from date is nil")
            
            return
        }
        
        pedo.startPedometerUpdatesFromDate(fromDate, withHandler: { data, error in
        
            guard error == nil else {
                
                print("error occurs in pedometer: \(error?.description)")
                return
            }
        
            self.itemValue.removeAll()
            self.pedoItems.removeAll()
            
            if let _data = data {
                
                self.itemValue.append(_data.startDate)
                self.itemValue.append(_data.endDate)
                self.itemValue.append(_data.numberOfSteps)
                self.itemValue.append(_data.distance)
                self.itemValue.append(_data.floorsAscended)
                self.itemValue.append(_data.floorsDescended)
                self.itemValue.append(_data.currentPace)
                self.itemValue.append(_data.currentCadence)
            }
            
            for i in 0..<self.itemName.count {
                
                let pedoItem = PedoItem(itemName: self.itemName[i], itemValue: self.itemValue[i])
                self.pedoItems.append(pedoItem)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
            
                self.dateTable.reloadData()
            })
        })
    }

}

extension PedometerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pedoItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PEDO-ITEM", forIndexPath: indexPath) as! PedoTableViewCell
        
        cell.itemName.text = self.itemName[indexPath.row]
        
        cell.itemValue.textColor = UIColor.purpleColor()
        
        if let value = self.itemValue[indexPath.row] {
            
            cell.itemValue.text = value.description
        } else {
            
            cell.itemValue.text = "nil"
        }
        
        return cell
    }
}

struct PedoItem {
    
    var itemName: String
    var itemValue: AnyObject?
    
    init(itemName: String, itemValue: AnyObject?) {
        
        self.itemName = itemName
        self.itemValue = itemValue
    }
}