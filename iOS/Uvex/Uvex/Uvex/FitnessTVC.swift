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
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceData: UILabel!
}

class FitnessTVC: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var fitnessServices: [Service] = [Service]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView(frame: .zero)
        
        let tempObject = Services.sharedInstance
        fitnessServices = tempObject.getAllServices(under: ServiceType.Fitness)
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
        return fitnessServices.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var first: Int = 0, second: Int = 99999
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! FitnessTVCell
        
        cell.serviceIcon.image = fitnessServices[indexPath.row].serviceIcon
        cell.serviceName.text = fitnessServices[indexPath.row].serviceName
        cell.serviceData.text = String(randomNumber(from: &first, to: &second))
        
        cell.selectionStyle = .None
        cell.contentView.layer.borderColor = UIColor(red: 0.796, green: 0.800, blue: 0.796, alpha: 1.00).CGColor
        
        return cell
    }
    
    func randomNumber(inout from start: Int, inout to end: Int)-> Int
    {
        if start > end
        {
            swap(&start, &end)
        }
        
        return Int(arc4random_uniform(UInt32(end - start + 1))) + start
    }
}

extension FitnessTVC: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("Cell \(indexPath.row) selected")
    }
}