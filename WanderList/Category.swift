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

    // Add reminder relationship in category
    func addReminder(reminder: Reminder) {
        self.mutableSetValueForKey("reminders").addObject(reminder)
    }
}
