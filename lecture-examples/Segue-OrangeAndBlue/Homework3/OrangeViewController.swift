//
//  OrangeViewController.swift
//  Homework3
//
//  Created by Jason on 1/25/15.
//  Copyright (c) 2015 CCSF. All rights reserved.
//

import UIKit

class OrangeViewController : UIViewController {
   
    @IBAction func flipToBlue() {
        performSegueWithIdentifier("FlipToBlue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "FlipToBlue" {
            var blueViewController = segue.destinationViewController as BlueViewController
            
            // generate a random number and set the value property
            blueViewController.value = 1 + Int(arc4random() % 6)
        }
    }
}
