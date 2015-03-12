//
//  Movie.swift
//  TheMovieDB
//
//  Created by Jason on 1/11/15.
//

import Foundation

struct Movie {
    
    static let Title = "title"
    static let ID = "id"
    static let PosterPath = "poster_path"
    static let ReleaseData = "release_date"
    
    var title = ""
    var id = 0
    var posterPath: String? = nil
    var releaseDate: NSDate? = nil
    
    init(dictionary: [String : AnyObject]) {
        title = dictionary[Movie.Title] as String
        id = dictionary[Movie.ID] as Int
        posterPath = dictionary[Movie.PosterPath] as? String
        
        if let releaseDateString = dictionary[Movie.ReleaseData] as? String {
            releaseDate = TheMovieDB.sharedDateFormatter.dateFromString(releaseDateString)
        }
    }
    
    static func moviesFromResults(results: [[String : AnyObject]]) -> [Movie] {
        
        var movies = results.map() { (dictionary: [String : AnyObject]) -> Movie in
            return Movie(dictionary: dictionary)
        }
        
        return movies
    }
}