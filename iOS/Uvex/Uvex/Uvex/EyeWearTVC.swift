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
    var stupidArray: [String] = ["Battery Level", "Manual", "Automatic"]
    var stupidImages: [UIImage] = [UIImage]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        stupidImages.append(UIImage(named: "Battery")!)
        stupidImages.append(UIImage(named: "ManualBtn")!)
        stupidImages.append(UIImage(named: "AutomaticBtn")!)
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .None
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
        return stupidArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! EyeWearTVCell
        
        cell.selectionStyle = .None
        
        cell.serviceIcon.image = stupidImages[indexPath.row]
        cell.serviceDescription.text = stupidArray[indexPath.row]
        cell.serviceView.layer.borderColor = UIColor(red: 0.796, green: 0.800, blue: 0.796, alpha: 1.00).CGColor
        
        return cell
    }
}