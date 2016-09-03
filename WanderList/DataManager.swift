//
//  DataManager.swift
//  WanderList
//
//  Created by HaoBoji on 2/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit
import CoreData

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


}
