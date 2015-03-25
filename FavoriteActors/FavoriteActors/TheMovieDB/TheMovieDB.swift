//
//  TheMovieDB.swift
//  TheMovieDB
//
//  Created by Jason Schatz on 1/10/15.
//

import Foundation

class TheMovieDB : NSObject {
    
    typealias CompletionHander = (result: AnyObject!, error: NSError?) -> Void
    
    var session: NSURLSession
    
    var config = Config.unarchivedInstance() ?? Config()
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()        
    }

    
    // MARK: - All purpose task method for data
    
    func taskForResource(resource: String, parameters: [String : AnyObject], completionHandler: CompletionHander) -> NSURLSessionDataTask {
        
        var mutableParameters = parameters
        var mutableResource = resource
        
        // Add in the API Key
        mutableParameters["api_key"] = Constants.ApiKey
        
        // Substitute the id parameter into the resource
        if resource.rangeOfString(":id") != nil {
            assert(parameters[Keys.ID] != nil)
            
            mutableResource = mutableResource.stringByReplacingOccurrencesOfString(":id", withString: "\(parameters[Keys.ID]!)")
            mutableParameters.removeValueForKey(Keys.ID)
        }
        
        let urlString = Constants.BaseUrl + mutableResource + TheMovieDB.escapedParameters(mutableParameters)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        println(url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in

            if let error = downloadError? {
                let newError = TheMovieDB.errorForData(data, response: response, error: error)
                completionHandler(result: nil, error: downloadError)
            } else {
                println("Step 3 - taskForResource's completionHandler is invoked.")
                TheMovieDB.parseJSONWithCompletionHandler(data, completionHandler)
            }
        }
        
        task.resume()
        
        return task
    }
    
    // MARK: - All purpose task method for images
    
    func taskForImageWithSize(size: String, filePath: String, completionHandler: (imageData: NSData?, error: NSError?) ->  Void) -> NSURLSessionTask {
        
        let urlComponents = [size, filePath]
        let baseURL = NSURL(string: config.baseImageURLString)!
        let url = baseURL.URLByAppendingPathComponent(size).URLByAppendingPathComponent(filePath)
        
        println(url)
        
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            if let error = downloadError? {
                let newError = TheMovieDB.errorForData(data, response: response, error: downloadError)
                completionHandler(imageData: nil, error: newError)
            } else {
                completionHandler(imageData: data, error: nil)
            }
        }
        
        task.resume()
        
        return task
    }
    
    
    // MARK: - Helpers
    
    
    // Try to make a better error, based on the status_message from TheMovieDB. If we cant then return the previous error

    class func errorForData(data: NSData?, response: NSURLResponse?, error: NSError) -> NSError {
        
        if let parsedResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject] {
            if let errorMessage = parsedResult[TheMovieDB.Keys.ErrorStatusMessage] as? String {

                let userInfo = [NSLocalizedDescriptionKey : errorMessage]
                
                return NSError(domain: "TMDB Error", code: 1, userInfo: userInfo)
            }
        }
        
        return error
    }
    
    // Parsing the JSON
    
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
    
    // URL Encoding a dictionary into a parameter string
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()

        for (key, value) in parameters {
            
            // make sure that it is a string value
            let stringValue = "\(value)"
            
            // Escape it
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            // Append it
            
            if let unwrappedEscapedValue = escapedValue? {
                urlVars += [key + "=" + "\(unwrappedEscapedValue)"]
            } else {
                println("Warning: trouble excaping string \"\(stringValue)\"")
            }
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
    
    // MARK: - Shared Image Cache

    struct Caches {
        static let imageCache = ImageCache()
    }

}