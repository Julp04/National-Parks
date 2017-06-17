//
//  ViewController.swift
//  NationalParks
//
//  Created by Julian Panucci on 9/25/16.
//  Copyright © 2016 Julian Panucci. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var arrowLeft: UIImageView!
    @IBOutlet weak var arrowDown: UIImageView!
    @IBOutlet weak var arrowRight: UIImageView!
    @IBOutlet weak var arrowUp: UIImageView!
    @IBOutlet var arrows: [UIImageView]!
    var parkModel = ParkModel.sharedInstance
    var xOffSetToStayAt:CGFloat = 0.0
    var horizontalPageNumber = 0
    var verticalPageNumber = 0
    
    let kAnimationDuration = 0.5
    let kLabelFontSize:CGFloat = 30.0
    let kLabelYOffset:CGFloat = 25.0
    let kLabelHeight:CGFloat = 50.0
    let kImageViewYOffset:CGFloat = 130.0
    let kMinZoomScale:CGFloat = 1.0
    let kMaxZoomScale:CGFloat = 10.0
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScrollView()
        addImagesToScrollView()
        self.scrollView.tag = 1
        
        //Initially hide all arrows from view
        for arrow in arrows {
            arrow.alpha = 0.0
        }
        
    }
    
    func configureScrollView() {
        let horizontalPageCount = parkModel.numberOfPhotos
        
        let size = view.bounds.size
        let contentSize = CGSize(width: size.width * CGFloat(horizontalPageCount), height: size.height)
        
        scrollView.contentSize = contentSize
        scrollView.pagingEnabled = true
        scrollView.directionalLockEnabled = true
        scrollView.tag = 1 //Set to distinguish which scrollView you are using in delegate
        
        scrollView.delegate = self
    }
    
    func addImagesToScrollView()
    {
        
        
        let size = view.bounds.size
        
        //Loop through the number of photos in the the gallery. This is just the number of different national parks. Each park has a subset of other photos. Looping here handles the horizontal part of the scroll view
        for albumIndex in 0..<parkModel.numberOfAlbums {
            let xOffset = size.width*CGFloat(albumIndex)
            let origin = CGPoint(x: xOffset,y: 0.0)
            let frame = CGRect(origin: origin, size: size)
            let pageView = UIView(frame: frame)
            pageView.backgroundColor = UIColor.random()
            
            let firstPhoto = parkModel.photoInAlbumAtIndex(albumIndex, photoIndex: 0)
            let name = firstPhoto.imageName
            let image = UIImage(named:name)
            let title = parkModel.parkTitleAtIndex(albumIndex)

            addScrollViewToPageView(pageView, withImage: image!)
            
            let labelFrame = CGRect(x: 0.0, y: kLabelYOffset, width: size.width, height: kLabelHeight)
            let label = UILabel(frame: labelFrame)
            label.font = UIFont(name: "Georgia", size: kLabelFontSize)
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
        
            label.text = title
            pageView.addSubview(label)
            
            self.scrollView.addSubview(pageView)
            
           
            //Now we will handle the vertical part of the scrollview and loop through number of photos in a particular album. Note an album has one national park in it.
            for i in 0..<parkModel.lengthOfAlbumAtIndex(albumIndex) - 1 {
                let yOffset = size.height*CGFloat(i + 1)
                let origin2 = CGPoint(x: xOffset,y: yOffset)
                let frame2 = CGRect(origin: origin2, size: size)
                let pageView2 = UIView(frame: frame2)
                pageView2.backgroundColor = UIColor.random()
                
            
                let photo = parkModel.photoInAlbumAtIndex(albumIndex, photoIndex: i + 1)
                let name = photo.imageName
                let image = UIImage(named:name)
                let imageView = UIImageView(image: image)
                imageView.frame = CGRectMake(0.0, kImageViewYOffset, size.width, size.height/2)
                imageView.contentMode = .ScaleAspectFit
                
                addScrollViewToPageView(pageView2, withImage: image!)
                
                self.scrollView.addSubview(pageView2)
                
            }
            
        }
        
    }
    
    
    /**
     For each pageView we created for each photo, we will add a separate scrollView that each photo will be on on top of the main scroll View. This will allow the photo to be zoomed in an out and pan as well.
     
     - parameter pageView: current pageView that is adding the scroll view
     - parameter image:    image to be added onto scrollView
     */
    func addScrollViewToPageView(pageView:UIView, withImage image:UIImage)
    {
        let size = view.bounds.size
        
        
        let imageView = UIImageView(image: image)
        imageView.frame = CGRectMake(0.0, 0.0, size.width, size.height/2) 
        imageView.contentMode = .ScaleAspectFit
        
        imageView.center = view.center
        
        let scrollViewFrame = CGRectMake(0.0, 0.0, view.bounds.size.width, view.bounds.size.height)
        let photoScrollView = UIScrollView(frame: scrollViewFrame)
        photoScrollView.minimumZoomScale = kMinZoomScale
        photoScrollView.maximumZoomScale = kMaxZoomScale
        photoScrollView.zoomScale = 1.0
        photoScrollView.addSubview(imageView)
        photoScrollView.delegate = self
        pageView.addSubview(photoScrollView)
        
    }
    

    
    //MARK:- ScrollView Delegates
    
    //Note in scrollView deleagates we check the tag of the scrollView first to determine if it is the main scrollView of a sub scrollView used for zooming in and out. This helps us handle different effects for different situations
    
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        
        if scrollView.tag == 1 || scrollView.zoomScale == 1{
            //Used so you cannot scroll horizontally when you have scrolled vertically on a photo
            self.xOffSetToStayAt = scrollView.contentOffset.x
            
            let allPhotos = parkModel.allPhotos
            let currentAlbum = allPhotos[horizontalPageNumber]
            let numberOfPhotos  = currentAlbum.count
            setVerticalContentSizeForPhotos(numberOfPhotos)
            
            configureArrows(numberOfPhotos)
            showArrows()
        }
      
 
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if scrollView.tag == 1 || scrollView.zoomScale == 1 {
            if scrollView.contentOffset.y > 0 {
                //If you are in a subset of photos(you have vertically scrolled down on an album) you cannot move to the right or left, so we keep the xoffset where it is and only allow to scroll up or down until yoffset is back to 0.
                scrollView.contentOffset.x = xOffSetToStayAt
            }
        }
        
    }
        
        
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        if scrollView.tag == 1 || scrollView.zoomScale == 1{
            hideArrows()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        
        if scrollView.tag == 1 || scrollView.zoomScale != 1{
            (horizontalPageNumber, verticalPageNumber) = pageNumbersAtOffset(scrollView.contentOffset)
        }
       

    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        if scrollView.tag == 1 || scrollView.zoomScale == 1{
            
        }else {
            if scrollView.zoomScale < 1 {
                //When we are zooming in a scroll view that is not the main view, and the zoom scale is less than one, that means we can page between different photos
                self.scrollView.pagingEnabled = true
                
            }
            if scrollView.zoomScale > 1 {
                 //When we are zooming in a scroll view that is not the main view, and the zoom scale is greater than one. We are currently zoomed in on a photo and we want to pan on that photo and not page to another one so we set it to false
                self.scrollView.pagingEnabled = false
//                
//                let imageView = scrollView.subviews[0] as! UIImageView
//                scrollView.contentSize = imageView.bounds.size
            }
            hideArrows()
            
        }
        
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        if scrollView.tag == 1 {
            return nil
        }else{
            
            if let image = scrollView.subviews[0] as? UIImageView {
                return image
            }else {
                return nil
            }
        }
    }
    
    
    //MARK:-Useful Functions
    
    
    func pageNumbersAtOffset(offset:CGPoint) -> (Int,Int) {
        let pageWidth = view.bounds.size.width
        let horizontalPageNumber = Int(offset.x/pageWidth)
        
        let pageHeight = view.bounds.size.height
        let verticalPageNumber = Int(offset.y/pageHeight)
        
        return (horizontalPageNumber, verticalPageNumber)
    }
    
    func horizonalPageNumberAtOffset(offset:CGPoint) -> Int {
        let pageWidth = view.bounds.size.width
        let pageNumber = Int(offset.x/pageWidth)
        return pageNumber
    }
    
    func verticalPageNumberAtOffset(offset:CGPoint) -> Int {
        let pageHeight = view.bounds.size.height
        let pageNumber = Int(offset.y/pageHeight)
        return pageNumber
    }
    
    /**
     This sets the the content size for each album so that you can scroll down only for the number of photos that are in each album
     
     - parameter numberOfPhotos: number of photos per national park/album
     */
    func setVerticalContentSizeForPhotos(numberOfPhotos:Int)
    {
        let size = self.view.bounds.size
        let y = size.height * CGFloat(numberOfPhotos)
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: y)
    }
    
    /**
     Determines when the arrows should be hidden or not based on various situations
     
     - parameter numberOfPhotos: number of photos in album. Used for down arrow.
     */
    func configureArrows(numberOfPhotos:Int)
    {
        if scrollView.contentOffset.y > 0 {
            arrowRight.hidden = true
            arrowLeft.hidden = true
        }else {
            arrowRight.hidden = false
            arrowLeft.hidden = false
            if horizontalPageNumber == 0 {
                arrowLeft.hidden = true
            }
            
            if horizontalPageNumber == parkModel.numberOfPhotos - 1 {
                arrowRight.hidden = true
            }
        }
        
        
        if verticalPageNumber == 0 {
            arrowUp.hidden = true
        }else {
            arrowUp.hidden = false
        }
        
        if verticalPageNumber == numberOfPhotos - 1 {
            arrowDown.hidden = true
        }else {
            arrowDown.hidden = false
        }
    }
    
    func hideArrows()
    {
        UIView.animateWithDuration(kAnimationDuration) {
            for arrow in self.arrows {
                arrow.alpha = 0.0
            }
        }
    }
    
    func showArrows()
    {
        UIView.animateWithDuration(kAnimationDuration) {
            for arrow in self.arrows {
                arrow.alpha = 1.0
            }
        }
    }
    

}


extension UIColor {
    static  func random() -> UIColor {
        let color = UIColor(red: CGFloat(arc4random() % 256)/255.0, green: CGFloat(arc4random() % 256)/255.0, blue: CGFloat(arc4random() % 256)/255.0, alpha: 1.0)
        return color
    }
}

