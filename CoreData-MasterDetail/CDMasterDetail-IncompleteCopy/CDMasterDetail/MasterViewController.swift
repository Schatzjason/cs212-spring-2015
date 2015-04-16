//
//  MasterViewController.swift
//  CDMasterDetail
//
//  Created by jschatz on 4/14/15.
//  Copyright (c) 2015 jschatz. All rights reserved.
//

import UIKit

// import CoreData here

class MasterViewController: UITableViewController {

    // This array holds the Event objects fetched from Core Data
    var events: [Event]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        
        // Fetch the events
        events = fetchAllEvents()
    }

    func insertNewObject(sender: AnyObject) {
        
        // Use the init method that accepts the shared context here
        let event = Event()
        
        // Save the context here
        
        // Put the event into the array
        events.insert(event, atIndex: 0)

        // Add a row to the table, so that we can see the new event
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    
    // MARK: - Core Data Helper Functions
    
    func fetchAllEvents() -> [Event] {
    }
    
    func saveContext() {
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                (segue.destinationViewController as DetailViewController).detailItem = events[indexPath.row]
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let event = events[indexPath.row]

        cell.textLabel!.text = event.timeStamp.description
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            events.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}

