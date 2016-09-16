//
//  ReminderController.swift
//  WanderList
//
//  Created by HaoBoji on 4/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//
//  Display, add, edit reminder
//

import UIKit
import DatePickerDialog
import CoreData

protocol ReminderListDelegate {
    func refresh()
}

class ReminderController: UITableViewController, UITextViewDelegate {

    var category: Category?
    var reminder: Reminder?
    var delegate: ReminderListDelegate?
    var dateFormatter = NSDateFormatter()
    var currentDue: NSDate = NSDate()

    @IBOutlet var titleInput: UITextField!
    @IBOutlet var noteInput: UITextView!
    @IBOutlet var dueSwitch: UISwitch!
    @IBOutlet var dueDate: UITableViewCell!
    @IBOutlet var completeSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        // For resizing note cell
        noteInput.delegate = self
        // Check new or edit reminder
        if (reminder == nil) {
            self.title = "New"
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(cancel(_:)))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(saveNew(_:)))
        } else {
            self.title = reminder?.title
            titleInput.text = reminder?.title
            noteInput.text = reminder?.note
            dueSwitch.on = (reminder?.dueIsEnabled == 1)
            currentDue = reminder!.dueDate!
            completeSwitch.on = (reminder?.isCompleted == 1)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(saveEdit(_:)))
        }
        self.dueDate.detailTextLabel?.text = dateFormatter.stringFromDate(currentDue)
    }

    // Save reminder action
    func save() -> Bool {
        // Empty title
        if (titleInput.text == nil || titleInput.text == "") {
            let alert = UIAlertController(title: "Oops", message: "Reminder title is required", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        // Create a reminder if needed
        if (reminder == nil) {
            reminder = (NSEntityDescription.insertNewObjectForEntityForName("Reminder", inManagedObjectContext: DataManager.shared.moc!) as? Reminder)!
        }
        reminder?.title = titleInput.text
        reminder?.dueDate = currentDue
        reminder?.dueIsEnabled = dueSwitch.on
        reminder?.note = noteInput.text
        reminder?.isCompleted = completeSwitch.on
        category?.addReminder(reminder!)
        DataManager.shared.saveContext()
        delegate?.refresh()
        return true
    }

    // Save new reminder
    func saveNew(controller: ReminderController) {
        if (save()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    // Save existing reminder
    func saveEdit(controller: ReminderController) {
        if (save()) {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    // Cancel reminder action
    func cancel(controller: ReminderController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // Auto resize note cell
    func textViewDidChange(textView: UITextView) {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 2
        case 3:
            return 1
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Dissmiss keyboard
        view.endEditing(true)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // Date pick dialog
        if (indexPath.section == 2 && indexPath.row == 1) {
            DatePickerDialog().show("Pick date and time", doneButtonTitle: "SET", cancelButtonTitle: "CANCEL", datePickerMode: .DateAndTime) {
                (date) -> Void in
                if (date == nil) {
                    return
                }
                self.currentDue = date!
                cell?.detailTextLabel?.text = self.dateFormatter.stringFromDate(date!)
            }
        }
    }
}
