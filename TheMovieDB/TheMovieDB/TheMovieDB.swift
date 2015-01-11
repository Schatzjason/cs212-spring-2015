//
//  TheMovieDB.swift
//  TheMovieDB
//
//  Created by Jason Schatz on 1/10/15.
//

import Foundation

private let ApiKey = "3c534dc71a2f9d28e9594e5773abcc93"

private let BaseUrl = "http://api.themoviedb.org/3/"
private let SearchMovies = "search/movie"


class TheMovieDB : NSObject {
    
    typealias CompletionHander = (result: AnyObject!, error: NSError?) -> Void
    
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    
    // MARK: - Shared Instance

    class func sharedInstance() -> TheMovieDB {
        
        struct Singleton {
            static var sharedInstance = TheMovieDB()
        }
        
        return Singleton.sharedInstance
    }
    
    
    // MARK: - Resource Methods
    
    func moviesForSearchString(searchString: String, completionHandler: CompletionHander) {

        var parameters = ["query" : searchString]
        
        taskForResource(SearchMovies, parameters: parameters, completionHandler: completionHandler)
    }
    
    
    // MARK: - All purpose task method
    
    func taskForResource(resource: String, parameters: [String : AnyObject], completionHandler: CompletionHander) {
        
        var mutableParameters = parameters
        
        mutableParameters["api_key"] = ApiKey
        
        let urlString = BaseUrl + resource + TheMovieDB.escapedParameterss(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        println(url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in

            if let error = downloadError? {
                completionHandler(result: nil, error: downloadError)
            } else {
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
            completionHandler(result: parsedResult, error: nil)
        }
    }
    
    class func escapedParameterss(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()

        for (key, value) in parameters {
            let escapedValue = value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            urlVars += [key + "=" + "\(value)"]
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
}