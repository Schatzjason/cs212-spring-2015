//
//  TheMovieDB-Convenience.swift
//  MovieLists
//
//  Created by Jason on 1/23/15.
//  Copyright (c) 2015 CCSF. All rights reserved.
//

import Foundation

// MARK: - Convenient Resource Methods

extension TheMovieDB {
        
    // Movies For Search String
    
    func getMoviesForSearchString(searchString: String, completionHandler: (result: [Movie]?, error: NSError?) -> Void) {
        
        var parameters = ["query" : searchString]
        
        taskForResource(Resources.SearchMovie, parameters: parameters) { JSONResult, error in
            
            if let error = error? {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = JSONResult.valueForKey("results") as? [[String : AnyObject]] {

                    var movies = results.map() { (dictionary: [String : AnyObject]) -> Movie in
                        return Movie(dictionary: dictionary)
                    }
                    
                    completionHandler(result: movies, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "Movie Parsing", code: 0, userInfo: nil))
                }
            }
        }
    }
    
    // Movies for Genre
    
    func getMoviesForGenreID(genre: String, completionHandler: (result: [Movie]?, error: NSError?) -> Void) {
        
        var parameters = [Keys.ID : genre]

        taskForResource(Resources.GenreIDMovies, parameters: parameters) {JSONResult, error in
            
            if let error = error? {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = JSONResult.valueForKey("results") as? [[String : AnyObject]] {
                    var movies = results.map() { (dictionary: [String : AnyObject]) -> Movie in
                        return Movie(dictionary: dictionary)
                    }
                    
                    completionHandler(result: movies, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "Movie for Genre Parsing. Cant find results in \(JSONResult)", code: 0, userInfo: nil))
                }
            }
        }
    }
    
    // Movies for Person
    
    func fetchPersonIDMovieCredits(person: Person, completionHandler: (result: [Movie]?, error: NSError?) -> Void) {
        
        var parameters = [Keys.ID : person.id]
        
        println("Step 2 - The moviesForPerson convenience method invokes taskForResource creating URL: ")
        
        taskForResource(Resources.PersonIDMovieCredits, parameters: parameters) {JSONResult, error in
            
            if let error = error? {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = JSONResult.valueForKey("cast") as? [[String : AnyObject]] {
                    println("Step 5 - moviesForPerson's completion handler is invoked.")
                    
                    var movies = results.map() { (dictionary: [String : AnyObject]) -> Movie in
                        return Movie(dictionary: dictionary)
                    }
                    
                    completionHandler(result: movies, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "Movie for Person Parsing. Cant find cast in \(JSONResult)", code: 0, userInfo: nil))
                }
            }
        }
    }
    
    // Movies for Kevin Bacon
    
    func fetchKevinBaconsMovieCredits(completionHandler: (result: [Movie]?, error: NSError?) -> Void) {
        let person = Person(dictionary: [Keys.ID : Values.KevinBaconIDValue, Person.Keys.Name : ""])
        
        fetchPersonIDMovieCredits(person, completionHandler: completionHandler)
    }
    
    // Cast for Movie
    
    func fetchMovieIDCredits(movie: Movie, completionHandler: (results: [Person]?, error: NSError?) -> Void) {
        
        var parameters = [Keys.ID : movie.id]
        
        println("Step 2 - The castForMovie convenience method invokes taskForResource creating URL: ")
        
        taskForResource(Resources.MovieIDCredits, parameters: parameters) { JSONResult, error in
            
            if let error = error? {
                completionHandler(results: nil, error: error)
            } else {
                
                if let results = JSONResult.valueForKey("cast") as? [[String : AnyObject]] {
                    println("Step 5 - castForMovie's completion handler is invoked.")
                    
                    let people = results.map() {Person(dictionary: $0)}
                    
                    completionHandler(results: people, error: nil)
                } else {
                    completionHandler(results: nil, error: NSError(domain: "Movie for Person Parsing. Cant find cast in \(JSONResult)", code: 0, userInfo: nil))
                }
            }
        }
    }
    
    func updateConfig(completionHandler: (didSucceed: Bool, error: NSError?) -> Void) {
        
        var parameters = [String: AnyObject]()
        
        taskForResource(Resources.Config, parameters: parameters) { JSONResult, error in
            
            if let error = error? {
                completionHandler(didSucceed: false, error: error)
            } else if let newConfig = Config(dictionary: JSONResult as [String : AnyObject]) {
                self.config = newConfig
                completionHandler(didSucceed: true, error: nil)
            } else {
                completionHandler(didSucceed: false, error: NSError(domain: "Config", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse config"]))
            }
        }
    }
}



















