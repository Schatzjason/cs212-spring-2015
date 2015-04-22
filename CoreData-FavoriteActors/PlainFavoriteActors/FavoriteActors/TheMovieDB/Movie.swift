//
//  Movie.swift
//  TheMovieDB
//
//  Created by Jason on 1/11/15.
//

import UIKit
import CoreData

class Movie {
    
    struct Keys {
        static let Title = "title"
        static let PosterPath = "poster_path"
        static let ReleaseDate = "release_date"
    }
    
    var title: String
    var id: Int
    var posterPath: String?
    var releaseDate: NSDate?
    
    init(dictionary: [String : AnyObject]) {
        
        // Dictionary
        title = dictionary[Keys.Title] as String
        id = dictionary[TheMovieDB.Keys.ID] as Int
        posterPath = dictionary[Keys.PosterPath] as? String
        
        if let dateString = dictionary[Keys.ReleaseDate] as? String {
            if let date = TheMovieDB.sharedDateFormatter.dateFromString(dateString) {
                releaseDate = date
            }
        }
    }
    
    var posterImage: UIImage? {
        
        get {
            return TheMovieDB.Caches.imageCache.imageWithIdentifier(posterPath)
        }
        
        set {
            TheMovieDB.Caches.imageCache.storeImage(newValue, withIdentifier: posterPath!)
        }
    }
}



