//
//  ViewController.swift
//  ClickCount-Storyboard
//
//  Created by jschatz on 2/3/15.
//  Copyright (c) 2015 jschatz. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet var label: UILabel!
    
    var count = 0
    
    @IBAction func buttonClicked() {
        label.text = "\(++count)"
    }
}

