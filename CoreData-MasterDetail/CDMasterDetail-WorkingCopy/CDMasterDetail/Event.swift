//
//  Event.swift
//  CDMasterDetail
//
//  Created by jschatz on 4/14/15.
//  Copyright (c) 2015 jschatz. All rights reserved.
//

import Foundation
import CoreData

// We include this to make sure that Core Data can find this class
@objc(Event)

// All classes that Core Data keeps track of must extend NSMangedObject
class Event: NSManagedObject {

    // The whole purpose of this class is to store a timestamp
    @NSManaged var timeStamp: NSDate
    
    // Here we override the init method from NSManagedObject
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Add the current date as the timestamp
        timeStamp = NSDate()
    }
    
    // This is a convenience init method that finds the entity description for "Event"
    convenience init(insertIntoManagedObjectContext context: NSManagedObjectContext) {
        let entityDescription = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)!
        
        self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    }

}
