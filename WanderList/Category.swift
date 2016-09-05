//
//  Category.swift
//  WanderList
//
//  Created by HaoBoji on 2/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import Foundation
import CoreData

class Category: NSManagedObject {

    // Insert code here to add functionality to your managed object subclass
    func addReminder(reminder: Reminder) {
        let mon = self.mutableSetValueForKey("reminders")
        mon.addObject(reminder)
    }
}
