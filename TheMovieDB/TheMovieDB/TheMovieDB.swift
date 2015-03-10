//
//  TheMovieDB.swift
//  TheMovieDB
//
//  Created by Jason Schatz on 1/10/15.
//

import Foundation

private let ApiKey = "3c534dc71a2f9d28e9594e5773abcc93"
private let BaseUrl = "http://api.themoviedb.org/3/"

private let SearchMoviesResource = "search/movie"
private let MovieCreditsForPersonIDResource = "person/:id/movie_credits"
private let PersonCreditsForMovieIDResource = "movie/:id/credits"

private let ID = "id"
private let KevinBaconID = 4724

let fantasticMrFoxURL = "http://image.tmdb.org/t/p/w780/750pfEttsYAVmynRg2vmt1AXh4q.jpg"
let kevinBaconMoviesURL = "http://api.themoviedb.org/3/person/4724/movie_credits?api_key=3c534dc71a2f9d28e9594e5773abcc93"


class TheMovieDB : NSObject {
    
    typealias CompletionHander = (result: AnyObject!, error: NSError?) -> Void
    
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    
    // MARK: - All purpose task method
    
    func taskForResource(resource: String, parameters: [String : AnyObject], completionHandler: CompletionHander) {
        
        var mutableParameters = parameters
        var mutableResource = resource
        
        // Add in the API Key
        mutableParameters["api_key"] = ApiKey
        
        // Substitute the id parameter into the resource
        if resource.rangeOfString(":id") != nil {
            assert(parameters[ID] != nil)
            
            mutableResource = mutableResource.stringByReplacingOccurrencesOfString(":id", withString: "\(parameters[ID]!)")
            mutableParameters.removeValueForKey(ID)
        }
        
        let urlString = BaseUrl + mutableResource + TheMovieDB.escapedParameterss(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        println(url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in

            if let error = downloadError? {
                completionHandler(result: nil, error: downloadError)
            } else {
                println("Step 3 - taskForResource's completionHandler is invoked.")
                TheMovieDB.parseJSONWithCompletionHandler(data, completionHandler)
            }
        }
        
        task.resume()
    }
    
    
    // MARK: - Helpers
    
    var baseURL: NSURL = NSURL(string: BaseUrl)!
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: CompletionHander) {
        var parsingError: NSError? = nil
        
        let parsedResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError)
        
        if let error = parsingError? {
            completionHandler(result: nil, error: error)
        } else {
            println("Step 4 - parseJSONWithCompletionHandler is invoked.")
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    class func escapedParameterss(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()

        for (key, value) in parameters {
            
            // make sure that it is a string value
            let stringValue = "\(value)"
            
            // Escape it
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            // Append it
            urlVars += [key + "=" + "\(value)"]
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> TheMovieDB {
        
        struct Singleton {
            static var sharedInstance = TheMovieDB()
        }
        
        return Singleton.sharedInstance
    }
    
    
    
    // MARK: - Shared Date Formatter
    class var sharedDateFormatter: NSDateFormatter  {
        
        struct Singleton {
            static let dateFormatter = Singleton.generateDateFormatter()
            
            static func generateDateFormatter() -> NSDateFormatter {
                var formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-mm-dd"
                
                return formatter
            }
        }
        
        return Singleton.dateFormatter
    }
}


// MARK: - Convenient Resource Methods

extension TheMovieDB {
    
    // Movies For Search String
    
    func moviesForSearchString(searchString: String, completionHandler: (result: [Movie]?, error: NSError?) -> Void) {
        
        var parameters = ["query" : searchString]
        
        taskForResource(SearchMoviesResource, parameters: parameters) { JSONResult, error in
            
            if let error = error? {
                completionHandler(result: nil, error: error)
            } else {
                                
                if let results = JSONResult.valueForKey("results") as? [[String : AnyObject]] {
                    completionHandler(result: Movie.moviesFromResults(results), error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "Movie Parsing", code: 0, userInfo: nil))
                }
            }
        }
    }
    

    // Movies for Person
    
    func moviesForPerson(person: Person, completionHandler: (result: [Movie]?, error: NSError?) -> Void) {
        
        var parameters = [ID : person.id]
        
        println("Step 2 - The moviesForPerson convenience method invokes taskForResource creating URL: ")
        
        taskForResource(MovieCreditsForPersonIDResource, parameters: parameters) {JSONResult, error in
            
            if let error = error? {
                completionHandler(result: nil, error: error)
            } else {

                if let results = JSONResult.valueForKey("cast") as? [[String : AnyObject]] {
                    println("Step 5 - moviesForPerson's completion handler is invoked.")
                    completionHandler(result: Movie.moviesFromResults(results), error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "Movie for Person Parsing. Cant find cast in \(JSONResult)", code: 0, userInfo: nil))
                }
            }
        }
    }
    
    // Movies for Kevin Bacon

    func moviesForKevinBacon(completionHandler: (result: [Movie]?, error: NSError?) -> Void) {
        let person = Person(dictionary: [Person.ID : KevinBaconID, Person.Name : ""])
        
        moviesForPerson(person, completionHandler: completionHandler)
    }
    
    // Cast for Movie
    
    func castForMovie(movie: Movie, completionHandler: (results: [Person]?, error: NSError?) -> Void) {
       
        var parameters = [ID : movie.id]
        
        println("Step 2 - The castForMovie convenience method invokes taskForResource creating URL: ")
        
        taskForResource(PersonCreditsForMovieIDResource, parameters: parameters) { JSONResult, error in
            
            if let error = error? {
                completionHandler(results: nil, error: error)
            } else {
                
                if let results = JSONResult.valueForKey("cast") as? [[String : AnyObject]] {
                    println("Step 5 - castForMovie's completion handler is invoked.")
                    completionHandler(results: Person.peopleFromResults(results), error: nil)
                } else {
                    completionHandler(results: nil, error: NSError(domain: "Movie for Person Parsing. Cant find cast in \(JSONResult)", code: 0, userInfo: nil))
                }
            }
        }
    }
}