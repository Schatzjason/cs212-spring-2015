//
//  BlueViewController.swift
//  Homework3
//
//  Created by Jason on 1/25/15.
//  Copyright (c) 2015 CCSF. All rights reserved.
//

import UIKit

class BlueViewController : UIViewController {
 
    // This is the method that is invoked when the button is pressed
    // in the blue view. We will discuss the @IBAction annotation
    // In the fourth lecture. 
    @IBAction func returnToOrangeController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
