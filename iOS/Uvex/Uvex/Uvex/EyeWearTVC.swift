//
//  MainTVC.swift
//  Test
//
//  Created by Alphamicron on 8/2/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit

class EyeWearTVCell: UITableViewCell
{
    @IBOutlet weak var serviceView: UIView!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var serviceDescription: UILabel!
}

class EyeWearTVC: UITableViewController
{
    var eyeWearServices: [Service] = [Service]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView(frame: .zero)
        
        let tempObject: Services = Services.sharedInstance
        eyeWearServices = tempObject.getAllServices(under: ServiceType.Eyewear)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return eyeWearServices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! EyeWearTVCell
        
        cell.serviceIcon.image = eyeWearServices[indexPath.row].serviceIcon
        cell.serviceDescription.text = eyeWearServices[indexPath.row].serviceName
        
        cell.selectionStyle = .None
        cell.serviceView.layer.borderColor = UIColor(red: 0.796, green: 0.800, blue: 0.796, alpha: 1.00).CGColor
        
        return cell
    }
}