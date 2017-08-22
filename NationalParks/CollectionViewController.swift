//
//  CollectionViewController.swift
//  NationalParks
//
//  Created by Julian Panucci on 10/2/16.
//  Copyright © 2016 Julian Panucci. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CollectionViewCell"

class CollectionViewController: UICollectionViewController {

    let parkModel = ParkModel.sharedInstance
    
    var currentImageIndexPath:IndexPath?
    var imageSelected = false
    var scrollView:UIScrollView?
    var cellImageViewFrame:CGRect?
    
    fileprivate let insets = UIEdgeInsetsMake(50.0, 20.0, 50.0, 20.0)
    let kBorderWidth:CGFloat = 1.0
    let kMinZoom:CGFloat = 1.0
    let kMaxZoom:CGFloat = 10.0
    let kAnimationDuration = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        //Image has been zoomed into scrollView and then rotated. Want to reset scrollView for orientation
        if imageSelected{
            scrollView?.removeFromSuperview()
            configureScrollView(currentImageIndexPath!)
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return parkModel.numberOfAlbums
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return parkModel.lengthOfAlbumAtIndex(section)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        let photo = parkModel.photoInAlbumAtIndex(indexPath.section, photoIndex: indexPath.row)
        
        let image = UIImage(named: photo.imageName)!
        cell.parkImageView.image = image
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderReusableView
            headerView.headerLabel.text! = parkModel.parkTitleAtIndex(indexPath.section)
            headerView.backgroundColor = UIColor.orange
            headerView.layer.borderColor = UIColor.black.cgColor
            headerView.layer.borderWidth = kBorderWidth
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return insets
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        configureScrollView(indexPath)
        currentImageIndexPath = indexPath
        imageSelected = true
        self.collectionView!.isScrollEnabled = false
    }
    
    func configureScrollView(_ indexPath:IndexPath)
    {
        let tabVC = self.parent as! UITabBarController
        let tabBarSize = tabVC.tabBar.bounds
        let viewSize = self.view.bounds.size
        
        //Get offset of imageView so we can animate from current position to new position
        
        let collectionView = self.collectionView!
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)!
        let collectionViewFrame = attributes.frame
        let offSet = collectionView.convert(collectionViewFrame.origin, from: collectionView)
        let collectionViewOffset = collectionView.contentOffset
        
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        let cellImageView = cell.parkImageView
        
        
        cellImageViewFrame = CGRect(x: (cellImageView?.frame.origin.x)! + offSet.x, y: offSet.y - collectionViewOffset.y, width: (cellImageView?.frame.size.width)!, height: (cellImageView?.frame.size.height)!)
        
        let imageView = UIImageView(frame: cellImageViewFrame!)
        let photo = parkModel.photoInAlbumAtIndex(indexPath.section, photoIndex: indexPath.row)
        let image = UIImage(named:photo.imageName)
        imageView.image = image
        
        let scrollViewFrame = CGRect(x: 0.0, y: 0.0, width: viewSize.width, height: viewSize.height)
        scrollView = UIScrollView(frame: scrollViewFrame)
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth , .flexibleHeight , .flexibleLeftMargin , .flexibleRightMargin , .flexibleTopMargin , .flexibleBottomMargin]
        
        scrollView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollectionViewController.imageTapped(_:))))
        //Add imageView to new scrollView. It will be at same position it is relative to the collectionView
        scrollView!.addSubview(imageView)
        scrollView!.contentSize = imageView.bounds.size
        scrollView!.delegate = self
        scrollView!.minimumZoomScale = kMinZoom
        scrollView!.maximumZoomScale = kMaxZoom
        scrollView!.zoomScale = kMinZoom
        
        self.view.addSubview(scrollView!)
        self.view.bringSubview(toFront: scrollView!)
        
        //From that position it is now we will animate into a new position and bigger frame creating the expanding effect
        UIView.animate(withDuration: kAnimationDuration, animations: {
            imageView.frame = CGRect(x: 0.0 , y: 0.0 ,width: viewSize.width, height: viewSize.height - tabBarSize.height)
        }) 
        scrollView!.backgroundColor = UIColor.white
        
    }
    
    
    /**
     Bringing the image back to its original frame. We have the previous imageFrame as a global variable so now we can just get the scrollView's imageView and animate back to original frame in cell and then remove the superview.
     */
    func imageTapped(_ gesture: UITapGestureRecognizer){
        if scrollView?.zoomScale == 1{
            UIView.animate(withDuration: kAnimationDuration, animations: {
                let imageView = self.scrollView!.subviews[0] as! UIImageView
                imageView.frame = self.cellImageViewFrame!
                
                }, completion: { (succeeded) in
                    self.scrollView?.removeFromSuperview()
                    self.collectionView?.isScrollEnabled = true
            })
            
            imageSelected = false
        }
    }
    
    //MARK: - Scroll View Delegate
    
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if let imageView = scrollView.subviews[0] as? UIImageView {
            return imageView
        }else {
            return nil
        }
    }
    
    
    
    

 

}
