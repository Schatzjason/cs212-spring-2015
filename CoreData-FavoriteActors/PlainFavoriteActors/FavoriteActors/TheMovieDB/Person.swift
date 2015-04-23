//
//  Person.swift
//  TheMovieDB
//
//  Created by Jason on 1/11/15.
//

import UIKit

// Step 1: Add import for core data
import CoreData

// Step 2: add this strange @objc(Person) line. An annotation that allows Objective-C code
// in core data to "see" this class.
@objc(Person)

// Step 3: Make Person a subclass of NSManagedObject
class Person: NSManagedObject {
    
    struct Keys {
        static let Name = "name"
        static let ProfilePath = "profile_path"
        static let Movies = "movies"
        static let ID = "id"
    }
    
    // Step 4: Put the NSManaged annotation in front of each property
    @NSManaged var name: String
    @NSManaged var id: Int
    @NSManaged var imagePath: String?
    @NSManaged var movies: [Movie]
    
    // Step 6: Override  the two argument init method
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    // Step 7: Create the convenience init that accepts a context and a dictionary
    convenience init(context: NSManagedObjectContext, dictionary: [String : AnyObject]) {
    
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: context)!
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        name = dictionary[Keys.Name] as String
        id = dictionary[Keys.ID] as Int
        imagePath = dictionary[Keys.ProfilePath] as? String
    }
    
    var image: UIImage? {
        get {
            return TheMovieDB.Caches.imageCache.imageWithIdentifier(imagePath)
        }
        
        set {
            TheMovieDB.Caches.imageCache.storeImage(image, withIdentifier: imagePath!)
        }
    }
}


