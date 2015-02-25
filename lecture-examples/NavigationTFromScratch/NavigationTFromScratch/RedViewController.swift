//
//  RedViewController.swift
//  NavigationTFromScratch
//
//  Created by jschatz on 2/24/15.
//  Copyright (c) 2015 jschatz. All rights reserved.
//

import UIKit

class RedViewController : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.navigationItem.title = "Red"
        
        let bookmarkButton =  UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Bookmarks,
            target: self,
            action: "popOffOfNavigation")
        
        let popButton = UIBarButtonItem(title: "Pop", style:
            UIBarButtonItemStyle.Plain,
            target: self,
            action: "popOffOfNavigation")
        
        self.navigationItem.rightBarButtonItems = [bookmarkButton, popButton]
        
        self.navigationItem.prompt = "The reddest controller"
    }
    
    func popOffOfNavigation() {
        self.navigationController!.popViewControllerAnimated(true)
    }
}

