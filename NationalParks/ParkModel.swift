//
//  ParkModel.swift
//  NationalParks
//
//  Created by Julian Panucci on 9/25/16.
//  Copyright © 2016 Julian Panucci. All rights reserved.
//

import Foundation

class ParkModel {
    
    var titles = [String]()
    var allPhotos = [[Photo]]()
    var numberOfPhotos = 0
    var numberOfAlbums = 0
    
    static let sharedInstance = ParkModel()
    
    private init() {
        let path = NSBundle.mainBundle().pathForResource("Photos", ofType: "plist")
        
        if let array = NSArray(contentsOfFile: path!) as? [AnyObject] {
            for element in array {
                let photos = element as! [String:AnyObject]
                
                for(key, value) in photos {
                    if key == "name" {
                        let nameOfPark = value as! String
                        titles.append(nameOfPark)
                        numberOfPhotos += 1
                    }
                    
                    if key == "photos" {
                        let photos = value as! NSArray
                        var photosArray =  [Photo]()
                        for element in photos {
                            let detailImageName = element["imageName"] as! String
                            let caption = element["caption"] as! String
                            let newPhoto = Photo(imageName: detailImageName, caption: caption)
                            photosArray.append(newPhoto)
                        }
                        allPhotos.append(photosArray)
                    }
            }
                
        }
        }
        
        self.numberOfAlbums = allPhotos.count

    }
    
    func photoInAlbumAtIndex(albumIndex:Int, photoIndex: Int) -> Photo {
        let album = allPhotos[albumIndex]
        let photo = album[photoIndex]
        return photo
    }
    
    func lengthOfAlbumAtIndex(albumIndex:Int) -> Int
    {
        let album = allPhotos[albumIndex]
        return album.count
    }
    
    func parkTitleAtIndex(index:Int) -> String {
        return titles[index]
    }
}
struct Photo {
    var caption:String
    var imageName:String
    
    init (imageName:String, caption: String) {
        self.imageName = imageName
        self.caption = caption
    }

}














