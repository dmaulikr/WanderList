//
//  DataManager.swift
//  WanderList
//
//  Created by HaoBoji on 2/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class DataManager: NSObject {

    static let shared = DataManager()

    // Mark: CoreData
    var moc: NSManagedObjectContext?
    func saveContext () {
        if moc!.hasChanges {
            do {
                try moc!.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    // Get categories
    func getCategoryList() -> NSMutableArray {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Category", inManagedObjectContext: self.moc!)
        let sortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.entity = entityDescription
        fetchRequest.sortDescriptors = [sortDescriptor]
        let categories = try? self.moc!.executeFetchRequest(fetchRequest)
        if (categories == nil) {
            return NSMutableArray()
        } else {
            return NSMutableArray(array: categories!)
        }
    }

    // Get reminders
    func getReminderList() -> NSMutableArray {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Reminder", inManagedObjectContext: self.moc!)
        fetchRequest.entity = entityDescription
        let categories = try? self.moc!.executeFetchRequest(fetchRequest)
        if (categories == nil) {
            return NSMutableArray()
        } else {
            return NSMutableArray(array: categories!)
        }
    }
}
