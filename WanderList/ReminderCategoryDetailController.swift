//
//  ReminderCategoryDetailController.swift
//  WanderList
//
//  Created by HaoBoji on 4/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

class ReminderCategoryDetailController: UITableViewController, ReminderListDelegate {

    var category: Category?
    var reminders: NSMutableArray?
    var dateFormatter: NSDateFormatter = NSDateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        self.title = category?.title
        if (category != nil) {
            refresh()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (reminders == nil) {
            return 0
        }
        return reminders!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reminderCell", forIndexPath: indexPath)
        // Configure the cell...
        let reminder = reminders![indexPath.row] as! Reminder
        cell.textLabel?.text = reminder.title
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(reminder.dueDate!)
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("viewReminder", sender: reminders![indexPath.row])
    }

    // MARK: - Navigation

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == "addReminder") {
            if (category == nil) {
                let alert = UIAlertController(title: "Oops", message: "Please select a category before adding a reminder", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == nil) {
            return
        }
        switch segue.identifier! {
        case "addReminder":
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! ReminderController
            controller.category = category
            controller.delegate = self
            break
        case "viewReminder":
            let controller = segue.destinationViewController as! ReminderController
            controller.category = category
            controller.reminder = sender as? Reminder
            controller.delegate = self
            break
        default:
            break
        }
    }

    func refresh() {
        reminders = NSMutableArray(array: (category!.reminders!.allObjects as! [Reminder]))
        tableView.reloadData()
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

}
