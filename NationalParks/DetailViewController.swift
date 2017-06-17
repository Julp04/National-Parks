//
//  DetailViewController.swift
//  NationalParks
//
//  Created by Julian Panucci on 10/12/16.
//  Copyright © 2016 Julian Panucci. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    let parkModel = ParkModel.sharedInstance
    
    var imageName = ""
    var caption = ""
    var parkName = ""
    
    @IBOutlet weak var captionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //If it is the first thing loaded when we have not yet touched on a cell(normally the case with iPad, then make the image the first image of the park albums)
        if imageName == "" {
            let photo = parkModel.photoInAlbumAtIndex(0, photoIndex: 0)
            imageName = photo.imageName
            caption = photo.caption
            parkName = parkModel.parkTitleAtIndex(0)
        }

        imageView.image = UIImage(named: imageName)
        captionLabel.text = caption
        self.navigationController?.navigationBar.topItem?.title = parkName
        
    }
    
    func configureDetailView(imageName:String, caption:String, title:String)
    {
        self.imageName = imageName
        self.caption = caption
        self.parkName = title
    }



}
