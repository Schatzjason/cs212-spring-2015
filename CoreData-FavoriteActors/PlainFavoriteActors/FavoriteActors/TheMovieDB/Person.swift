//
//  Person.swift
//  TheMovieDB
//
//  Created by Jason on 1/11/15.
//

import UIKit

class Person {
    
    struct Keys {
        static let Name = "name"
        static let ProfilePath = "profile_path"
        static let Movies = "movies"
        static let ID = "id"
    }
    
    var name: String
    var id: Int
    var imagePath: String?
    var movies: [Movie] = [Movie]()
    
    init(dictionary: [String : AnyObject]) {
        
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


