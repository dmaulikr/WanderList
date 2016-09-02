//
//  Reminder+CoreDataProperties.swift
//  WanderList
//
//  Created by HaoBoji on 2/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Reminder {

    @NSManaged var isCompleted: NSNumber?
    @NSManaged var title: String?
    @NSManaged var note: String?
    @NSManaged var dueDate: NSDate?
    @NSManaged var category: Category?

}
