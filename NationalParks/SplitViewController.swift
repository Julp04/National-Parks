//
//  SplitViewController.swift
//  NationalParks
//
//  Created by Julian Panucci on 10/12/16.
//  Copyright © 2016 Julian Panucci. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
    
    //Used so that table view appears first
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
      
        return true
    }


}
