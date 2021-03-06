//
//  Category+CoreDataProperties.swift
//  WanderList
//
//  Created by HaoBoji on 7/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Category {

    @NSManaged var address: String?
    @NSManaged var color: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var notificationArriving: NSNumber?
    @NSManaged var notificationLeaving: NSNumber?
    @NSManaged var notificationRadius: NSNumber?
    @NSManaged var order: NSNumber?
    @NSManaged var title: String?
    @NSManaged var notificationTimestamp: NSDate?
    @NSManaged var reminders: NSSet?

}
