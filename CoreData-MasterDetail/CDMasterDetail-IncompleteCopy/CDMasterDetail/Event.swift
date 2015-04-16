//
//  Event.swift
//  CDMasterDetail
//
//  Created by jschatz on 4/14/15.
//  Copyright (c) 2015 jschatz. All rights reserved.
//

import Foundation
import CoreData

// 1. Write @objc(Event) below to make sure that Core Data can find this class

// 2. Make the event class extend NSMangedObject
class Event {

    // 3. Put @NSManaged in front of the timeStamp var
    var timeStamp: NSDate
    
    // 4. Uncomment the following init method
    //override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
    //    super.init(entity: entity, insertIntoManagedObjectContext: context)
    //
    //    // Add the current date as the timestamp
    //    timeStamp = NSDate()
    //}
    
    // 5. Uncpomment this convenience init method that finds the entity description for "Event"
    //convenience init(insertIntoManagedObjectContext context: NSManagedObjectContext) {
    //    let entityDescription = NSEntityDescription.entityForName("Event", inManagedObjectContext: context)!
    //
    //    self.init(entity: entityDescription, insertIntoManagedObjectContext: context)
    //}

}
