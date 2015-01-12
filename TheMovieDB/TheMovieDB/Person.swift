//
//  Person.swift
//  TheMovieDB
//
//  Created by Jason on 1/11/15.
//

import Foundation

struct Person {
 
    static let Name = "name"
    static let ID = "id"
    
    var name = ""
    var id = 0
    
    init(dictionary: [String : AnyObject]) {
        name = dictionary[Person.Name] as String
        id = dictionary[Person.ID] as Int
    }
    
    static func peopleFromResults(results: [[String : AnyObject]]) -> [Person] {
        
        var movies = results.map() { (dictionary: [String : AnyObject]) -> Person in
            return Person(dictionary: dictionary)
        }
        
        return movies
    }

}