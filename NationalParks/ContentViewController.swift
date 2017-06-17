//
//  ContentViewController.swift
//  NationalParks
//
//  Created by Julian Panucci on 10/12/16.
//  Copyright © 2016 Julian Panucci. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
   
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    var imageName = ""
    var descriptionText = ""
    var pageIndex = 0
    var buttonHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clearColor()
        imageView.image = UIImage(named:imageName)
        descriptionLabel.text = descriptionText
        descriptionLabel.textColor = UIColor.whiteColor()
        
        
        descriptionLabel.textAlignment = .Center;
        if buttonHidden {
            doneButton.hidden = true
        }else {
            doneButton.hidden = false
        }
        
    }
    
    func configureWithDescription(description:String,imageName:String, atIndex index:Int, buttonHidden:Bool)
    {
        self.imageName = imageName
        self.descriptionText = description
        self.pageIndex = index
        self.buttonHidden = buttonHidden
    }


}
