//
//  HealthTVC.swift
//  Uvex
//
//  Created by Alphamicron on 8/4/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit

class HealthTVCell: UITableViewCell
{
    @IBOutlet weak var serviceView: UIView!
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var serviceDescription: UILabel!
}

class HealthTVC: UITableViewController
{
    var healthServices: [Service] = [Service]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView(frame: .zero)
        
        let tempObject: Services = Services.sharedInstance
        healthServices = tempObject.getAllServices(under: ServiceType.Health)
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
        return healthServices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! HealthTVCell
        
        cell.serviceIcon.image = healthServices[indexPath.row].serviceIcon
        cell.serviceDescription.text = healthServices[indexPath.row].serviceName
        
        cell.selectionStyle = .None
        cell.serviceView.layer.borderColor = UIColor(red: 0.796, green: 0.800, blue: 0.796, alpha: 1.00).CGColor
        
        return cell
    }
}
