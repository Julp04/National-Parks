//
//  RootViewController.swift
//  NationalParks
//
//  Created by Julian Panucci on 10/12/16.
//  Copyright © 2016 Julian Panucci. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var previousLabel: UILabel!
    var pageViewController : UIPageViewController?
    let pageViewModel = PageViewModel()
    var imageName = ""
    var currentIndex = 0
    var isPortrait = true
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create & initialize the pageView Controller
        pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
        pageViewController!.dataSource = self
        pageViewController?.delegate = self
        self.pageViewController!.setViewControllers([viewControllerAtIndex(0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        
        //Set RootView as container controller
        pageViewController!.view.frame = self.view.bounds
        self.addChildViewController(pageViewController!)
        pageViewController!.didMoveToParentViewController(self)
        self.view.addSubview(pageViewController!.view)
        
        pageControl.numberOfPages = pageViewModel.numberOfPages()
       
        
    }
    
    
    func viewControllerAtIndex(index:Int) -> UIViewController {
        let contentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        
        imageName = pageViewModel.imageNameAtIndex(index)
        
     
        //If it is the last page of the pageview controller then show the button so that the user can continue to the rest of the app
        var buttonHidden:Bool
        if index == pageViewModel.numberOfPages() - 1 {
            buttonHidden = false
        }else {
            buttonHidden = true
        }
        
        let description = pageViewModel.descriptionAtIndex(index)
        contentViewController.configureWithDescription(description, imageName: imageName, atIndex:index, buttonHidden: buttonHidden)
       
        return contentViewController
    }
    
    
    //MARK: PageView Controller Data Source
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let contentViewController = viewController as! ContentViewController
        
        var index = contentViewController.pageIndex

        if index == 0 {
            return nil
        } else {
            index -= 1
            return viewControllerAtIndex(index)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let contentViewController = viewController as! ContentViewController
        
        var index = contentViewController.pageIndex
        
        if index == pageViewModel.numberOfPages() - 1 {
            return nil
        }else {
            index += 1
            return viewControllerAtIndex(index)
        }
        
        
    }
    
    //Using delegate mehtod to get the current view controller that we are at when we have finished paging to set the pageControl index
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let contentVC = pageViewController.viewControllers?.last as? ContentViewController {
           pageControl.currentPage = contentVC.pageIndex
            
            switch contentVC.pageIndex {
            case 0:
                previousLabel.hidden = true
                nextLabel.hidden = false
            case pageViewModel.numberOfPages() - 1:
                previousLabel.hidden = false
                nextLabel.hidden = true
            default:
                previousLabel.hidden = false
                nextLabel.hidden = false
                
            }
        }
        
        
    }
    
 

    
}
