//
//  FitnessTVC.swift
//  Uvex
//
//  Created by Alphamicron on 8/4/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit

class FitnessTVCell: UITableViewCell
{
    @IBOutlet weak var serviceIcon: UIImageView!
    @IBOutlet weak var serviceData: UILabel!
}

class FitnessTVC: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}

extension FitnessTVC: UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! FitnessTVCell
        
        cell.serviceIcon.image = UIImage(named: "AutomaticBtn")
        cell.serviceData.text = "6554"
        
        cell.selectionStyle = .None
        cell.contentView.layer.borderColor = UIColor(red: 0.796, green: 0.800, blue: 0.796, alpha: 1.00).CGColor
        
        return cell
    }
}

extension FitnessTVC: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("Cell \(indexPath.row) selected")
    }
}