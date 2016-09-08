//
//  ReminderCategoryDetailController.swift
//  WanderList
//
//  Created by HaoBoji on 4/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//
//  Master controller for category list
//

import UIKit
import CoreData

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

    // Refresh reminder list
    func refresh() {
        reminders = NSMutableArray(array: (category!.reminders!.allObjects as! [Reminder]))
        // Sort reminders
        sortReminders()
        tableView.reloadData()
    }

    // Sort reminder list
    func sortReminders() {
        reminders!.sortUsingComparator({ (obj1: AnyObject!, obj2: AnyObject!) -> NSComparisonResult in
            let reminder1 = obj1 as! Reminder
            let reminder2 = obj2 as! Reminder
            // Check Completion
            if (reminder1.isCompleted!.boolValue && !reminder2.isCompleted!.boolValue) {
                return .OrderedDescending
            }
            if (!reminder1.isCompleted!.boolValue && reminder2.isCompleted!.boolValue) {
                return .OrderedAscending
            }
            // Check whether due is enabled
            if (reminder1.dueIsEnabled!.boolValue && !reminder2.dueIsEnabled!.boolValue) {
                return .OrderedAscending
            }
            if (!reminder1.dueIsEnabled!.boolValue && reminder2.dueIsEnabled!.boolValue) {
                return .OrderedDescending
            }
            // Compare due dates
            return reminder1.dueDate!.compare(reminder2.dueDate!)
        })
    }

    // Configure cell
    func configureCell(cell: UITableViewCell, reminder: Reminder) {
        // Title
        cell.textLabel?.text = reminder.title
        // Display due date
        if (reminder.isCompleted!.boolValue) {
            cell.detailTextLabel!.text = "Done"
        } else if (reminder.dueIsEnabled!.boolValue) {
            cell.detailTextLabel?.text = dateFormatter.stringFromDate(reminder.dueDate!)
        } else {
            cell.detailTextLabel?.text = "Todo"
        }
        // Change color if overdue
        if (reminder.dueIsEnabled!.boolValue && reminder.dueDate!.timeIntervalSinceNow < 0) {
            cell.textLabel?.textColor = UIColor.redColor()
            cell.detailTextLabel?.textColor = UIColor.redColor()
        } else {
            cell.textLabel?.textColor = UIColor.blackColor()
            cell.detailTextLabel?.textColor = UIColor.grayColor()
        }
        // Change color if complete
        if (reminder.isCompleted!.boolValue) {
            cell.textLabel?.textColor = UIColor.grayColor()
            cell.detailTextLabel?.textColor = UIColor.grayColor()
        }
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
        configureCell(cell, reminder: reminder)
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("viewReminder", sender: reminders![indexPath.row])
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // Add delete action
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { action, index in
            DataManager.shared.moc?.deleteObject(self.reminders![indexPath.row] as! NSManagedObject)
            DataManager.shared.saveContext()
            self.reminders?.removeObjectAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        delete.backgroundColor = UIColor.redColor()
        // Add mark action
        let reminder = reminders![indexPath.row] as! Reminder
        let title: String
        if (reminder.isCompleted!.boolValue) {
            title = "Mark Todo"
        } else {
            title = "Mark Done"
        }
        let mark = UITableViewRowAction(style: .Destructive, title: title) { action, index in
            // Close swipe view
            tableView.setEditing(false, animated: true)
            // Save action result
            reminder.isCompleted = !(reminder.isCompleted!.boolValue)
            DataManager.shared.saveContext()
            // Configure appearance of this cell
            let cell = tableView.cellForRowAtIndexPath(indexPath)!
            self.configureCell(cell, reminder: reminder)
            // Reorder reminders
            self.sortReminders()
            // Move reminder
            let targetRow = self.reminders!.indexOfObject(reminder)
            let targetIndexPath = NSIndexPath(forRow: targetRow, inSection: 0)
            tableView.moveRowAtIndexPath(indexPath, toIndexPath: targetIndexPath)
        }
        mark.backgroundColor = UIColor.blueColor()
        return [delete, mark]
    }

    // MARK: - Navigation

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        // Add reminder
        if (identifier == "addReminder") {
            // Category must be set
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
}
