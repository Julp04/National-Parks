//
//  TableViewController.swift
//  NationalParks
//
//  Created by Julian Panucci on 10/2/16.
//  Copyright © 2016 Julian Panucci. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    
    let parkModel = ParkModel.sharedInstance
    
    var sectionCollapsed:[Bool] = []
   
    var scrollView:UIScrollView?
    var imageSelectedIndex:NSIndexPath?
    
    let kHeaderHeight:CGFloat = 50.0
    let kLabelYOffset:CGFloat = 10.0
    let kCellHeight:CGFloat = 175.0
    let kAnimationDuration = 0.5
    let kLabelXOffset:CGFloat = 5.0
    let kMinZoom:CGFloat = 1.0
    let kMaxZoom:CGFloat = 10.0
    let kBorderWidth:CGFloat = 1.0
    
    var cellImageViewFrame:CGRect?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionCollapsed = Array(count: parkModel.numberOfPhotos, repeatedValue: false)
        for i in 0..<sectionCollapsed.count {
            sectionCollapsed[i] = false
        }
        self.navigationController?.navigationBar.topItem?.title = "National Parks"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
    }
    
    override func viewDidLayoutSubviews() {
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return parkModel.numberOfAlbums
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //If the section should be collapsed do not display any, else display the number of photos in the album
        return sectionCollapsed[section] ? 0 : parkModel.lengthOfAlbumAtIndex(section)
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath) as! TableViewCell
        
        let photo = parkModel.photoInAlbumAtIndex(indexPath.section, photoIndex: indexPath.row)
        
        let image = UIImage(named: photo.imageName)!
        let caption = photo.caption
        
        
        cell.captionLabel.text = caption
        cell.parkImageView.image = image
        

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return kCellHeight

    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kHeaderHeight
    }
    
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0.0, width: self.view.frame.size.width, height: kHeaderHeight))
        headerView.autoresizingMask = [.FlexibleWidth , .FlexibleHeight , .FlexibleLeftMargin , .FlexibleRightMargin , .FlexibleTopMargin , .FlexibleBottomMargin]
        let headerLabel = UILabel(frame: CGRect(x: kLabelXOffset, y: kLabelYOffset, width: self.view.frame.size.width, height: kHeaderHeight))
        headerView.backgroundColor = UIColor.orangeColor()
        headerLabel.textColor = UIColor.whiteColor()
        headerView.tag = section
        headerView.layer.borderColor = UIColor.blackColor().CGColor
        headerView.layer.borderWidth = kBorderWidth
        headerLabel.text = parkModel.parkTitleAtIndex(section)
        headerLabel.textAlignment = .Left
        headerView.addSubview(headerLabel)
        let headerTapped = UITapGestureRecognizer(target: self, action: #selector(TableViewController.sectionHeaderTapped(_:)))
        headerView.addGestureRecognizer(headerTapped)
        return headerView
    }
    
    func sectionHeaderTapped(gestureRecognizer : UITapGestureRecognizer){
        let indexPath = NSIndexPath(forRow: 0, inSection: (gestureRecognizer.view?.tag)!)
        if indexPath.row == 0 {
            sectionCollapsed[indexPath.section] = !sectionCollapsed[indexPath.section]
            self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .Fade)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailVC: DetailViewController
        
        if let identifier = segue.identifier {
            switch identifier {
            case "DetailSegue":
                if let navController = segue.destinationViewController as? UINavigationController {
                    detailVC = navController.topViewController! as! DetailViewController
                }else {
                    detailVC = segue.destinationViewController as! DetailViewController
                }
                
                    if let cell = sender as? UITableViewCell {
                        let indexPath = tableView.indexPathForCell(cell)!
                        let photo = parkModel.photoInAlbumAtIndex(indexPath.section, photoIndex: indexPath.row)
                        let imageName = photo.imageName
                        let caption = photo.caption
                        let title = parkModel.parkTitleAtIndex(indexPath.section)
                        
                        detailVC.configureDetailView(imageName, caption: caption, title:title)
                    }
            default:
                assert(false, "Unhandled Segue")
            }
        }
    }
    
}
