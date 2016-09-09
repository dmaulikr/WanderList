//
//  NotificationController.swift
//  WanderList
//
//  Created by HaoBoji on 7/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//
//  Recieve location updates and Send system notification
//

import UIKit
import CoreLocation

class NotificationManager: NSObject {

    static let shared = NotificationManager()
    var lastLocation: CLLocation?
    var delegate: AlertDelegate?

    // Schedule time based notification
    func rescheduleReminders() {
        // Clear up notifications
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let reminders = DataManager.shared.getReminderList()
        for item in reminders {
            let reminder = item as! Reminder
            // Notification is not enabled
            if (!(reminder.dueIsEnabled!.boolValue)) {
                continue
            }
            // Overdue
            if (reminder.dueDate!.timeIntervalSinceNow < 0) {
                continue
            }
            // Done
            if (reminder.isCompleted!.boolValue) {
                continue
            }
            // Schedule notification
            let notification = UILocalNotification()
            var body: String = "Things to do in " + reminder.category!.title! + ":\n"
            body += reminder.title!
            notification.alertTitle = reminder.title
            notification.alertBody = body
            notification.alertAction = "Show"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.fireDate = reminder.dueDate!
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }

    // Recieve location updates
    func didUpdateLocation(currentLocation: CLLocation) {
        if (lastLocation == nil) {
            lastLocation = currentLocation
            return
        }
        // Determine whether notification should be enabled for the category
        let categories = DataManager.shared.getCategoryList()
        for item in categories {
            // init
            let category = item as! Category
            let targetLocation = CLLocation(latitude: category.latitude!.doubleValue, longitude: category.longitude!.doubleValue)
            let radius = Double(Config.radius[category.notificationRadius!.integerValue])
            // compare whether a location is within radius, true if yes
            let compareLastLocation = lastLocation!.distanceFromLocation(targetLocation) <= radius
            let compateCurrentLocation = currentLocation.distanceFromLocation(targetLocation) <= radius
            // Filter arriving
            if (category.notificationArriving!.boolValue) {
                if (!compareLastLocation && compateCurrentLocation) {
                    sendCategoryNotification(category)
                    print("arriving " + category.title!)
                }
            }
            // Filter leaving
            if (category.notificationLeaving!.boolValue) {
                if (compareLastLocation && !compateCurrentLocation) {
                    sendCategoryNotification(category)
                    print("leaving " + category.title!)
                }
            }
        }
        lastLocation = currentLocation
    }

    // Check and send category notification based on completion of reminders
    func sendCategoryNotification(category: Category) {
        // Check whether notified in recent minute
        if (category.notificationTimestamp!.timeIntervalSinceNow > -60) {
            print("notified: " + category.title!)
            return
        }
        category.notificationTimestamp = NSDate()
        DataManager.shared.saveContext()
        // Check reminders state
        let reminders = NSMutableArray(array: (category.reminders!.allObjects as! [Reminder]))
        var remindersToNotify: [Reminder] = []
        for item in reminders {
            let reminder = item as! Reminder
            if (!reminder.isCompleted!.boolValue) {
                remindersToNotify += [reminder]
            }
        }
        if (remindersToNotify.count == 0) {
            return
        }
        // Notify user
        let notification = UILocalNotification()
        var body: String = "Things to do in " + category.title! + ":\n"
        body += remindersToNotify[0].title!
        for i in 1..<remindersToNotify.count {
            body += "\n" + remindersToNotify[i].title!
        }
        if (UIApplication.sharedApplication().applicationState == .Active) {
            let alert = UIAlertController(title: category.title, message: body, preferredStyle: .Alert)
            let action = UIAlertAction(title: "Close", style: .Default, handler: nil)
            alert.addAction(action)
            delegate?.presentAlert(alert)
        } else {
            notification.alertTitle = category.title
            notification.alertBody = body
            notification.alertAction = "Show"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.fireDate = NSDate()
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
}
