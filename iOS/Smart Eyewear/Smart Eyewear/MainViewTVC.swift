//
//  MainViewTVC.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 6/7/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class MainViewCell: UITableViewCell
{
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var serviceTitle: UILabel!
}

class MainViewTVC: UITableViewController
{
    var allServices: [Services] = [Services]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        allServices = Services.getServices()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return allServices.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! MainViewCell
        
        cell.serviceTitle.text = allServices[indexPath.row].serviceName
        cell.serviceIcon.image = allServices[indexPath.row].serviceIcons[0]
        
        cell.accessoryView = UIImageView(image: UIImage(named: "Arrow"))
        
        let selectedBackground = UIView()
        selectedBackground.backgroundColor = Constants.themeRedColour
        cell.selectedBackgroundView = selectedBackground
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        // grab the currently selected cell
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! MainViewCell
        
        selectedCell.serviceIcon.image = allServices[indexPath.row].serviceIcons[1] // change its icon original image to its corresponding white one
        selectedCell.serviceTitle.textColor = UIColor.whiteColor() // change text colour to white
        selectedCell.accessoryView = UIImageView(image: UIImage(named: "ArrowWhite")!) // change the arrow to a white-coloured one
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
    {
        // grab the formerly selected cell
        let deSelectedCell = tableView.cellForRowAtIndexPath(indexPath) as! MainViewCell
        
        deSelectedCell.serviceIcon.image = allServices[indexPath.row].serviceIcons[0] // change its icon back its original image
        deSelectedCell.serviceTitle.textColor = Constants.themeRedColour // change text colour to default red
        deSelectedCell.accessoryView = UIImageView(image: UIImage(named: "Arrow")!) // change its arrow image back to the default red one
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
