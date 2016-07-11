//
//  CalendarTableViewController.swift
//  iOSDataDemo
//
//  Created by Du Shuchen on 2016/06/17.
//  Copyright © 2016年 Du Shuchen. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class CalendarTableViewController: UITableViewController {

    var eventStore: EKEventStore!
    
    var calendars: [EKCalendar]!
    var events: [EKEvent]!
    
    func getCalendarsAndEvents() {
        
        let startDate = NSDate().dateByAddingTimeInterval(-1209600.0)
        let endDate = NSDate()
        
        let defaultCalendar = eventStore.defaultCalendarForNewEvents
        
        let predicate = eventStore.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: [defaultCalendar])
        
        events = eventStore.eventsMatchingPredicate(predicate)
        
        calendars = eventStore.calendarsForEntityType(.Event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventStore = EKEventStore()
        
        if EKEventStore.authorizationStatusForEntityType(.Event) != .Authorized {
            
            eventStore.requestAccessToEntityType(.Event, completion: { granted, error in
                
                guard granted == true else {
                    
                    print("cannot access event in calendar")
                    return
                }
            })
        }
        
        getCalendarsAndEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return events == nil ? 0 : events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CLD-ITEM", forIndexPath: indexPath) as! CalendarTableViewCell

        let event = events[indexPath.row]
        
        cell.startDate.text = event.startDate.description
        cell.endDate.text = event.endDate.description
        cell.organizer.text = event.location
        cell.id.text = event.title
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
