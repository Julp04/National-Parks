//
//  PageViewModel.swift
//  NationalParks
//
//  Created by Julian Panucci on 10/12/16.
//  Copyright © 2016 Julian Panucci. All rights reserved.
//

import Foundation

class PageViewModel {
    
    private let imageNames = ["image0", "image1", "image2"]
    private let descriptions = ["Touch the sections to hide images!", "Select cells to transition to full image view!", "A full image view with caption and park title is displayed!"]
    
    func imageNameAtIndex(index:Int) -> String {
        return imageNames[index]
    }
    
    func descriptionAtIndex(index:Int) -> String {
        return descriptions[index]
    }
    
    func numberOfPages() -> Int {
        return imageNames.count
    }
    
    
    
}