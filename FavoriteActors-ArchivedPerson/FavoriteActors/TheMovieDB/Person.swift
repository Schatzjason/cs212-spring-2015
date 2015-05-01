//
//  Person.swift
//  TheMovieDB
//
//  Created by Jason on 1/11/15.
//

import UIKit

class Person: NSObject, NSCoding  {
 
    struct Keys {
        static let Name = "name"
        static let ProfilePath = "profile_path"
        static let Movies = "movies"
        static let ID = "id"
    }
    
    var name = ""
    var id = 0
    var imagePath = ""
    var movies = [Movie]()
    
    init(dictionary: [String : AnyObject]) {
        name = dictionary[Keys.Name] as! String
        id = dictionary[TheMovieDB.Keys.ID] as! Int
        
        if var pathForImgage = dictionary[Keys.ProfilePath] as? String {
            imagePath = pathForImgage
        }
    }
    
    // MARK: - NSCoding
    
    func encodeWithCoder(archiver: NSCoder) {
        archiver.encodeObject(name, forKey: Keys.Name)
        archiver.encodeInteger(id, forKey: Keys.ID)
        archiver.encodeObject(imagePath, forKey: Keys.ProfilePath)
    }
    
    required init(coder unarchiver: NSCoder) {
        super.init()
        
        name = unarchiver.decodeObjectForKey(Keys.Name) as! String
        id = unarchiver.decodeIntegerForKey(Keys.ID)
        imagePath = unarchiver.decodeObjectForKey(Keys.ProfilePath) as! String
    }
   
    /**
      image is a computed property. From outside of the class is should look like objects
      have a direct handle to their image. In fact, they store them in an imageCache. The
      cache stores the images into the documents directory, and keeps a resonable number of
      them in memory.
    */
    
    var image: UIImage? {
        get {
            return TheMovieDB.Caches.imageCache.imageWithIdentifier(imagePath)
        }
        
        set {
            TheMovieDB.Caches.imageCache.storeImage(image, withIdentifier: imagePath)
        }
    }
}


