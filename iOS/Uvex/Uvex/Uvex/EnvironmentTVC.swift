//
//  EnvironmentTVC.swift
//  Uvex
//
//  Created by Alphamicron on 8/5/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit

class EnvironmentTVCell: UITableViewCell
{
    @IBOutlet weak var serviceView: UIView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var serviceData: UILabel!
    @IBOutlet weak var serviceIcon: UIImageView!
}

class EnvironmentTVC: UITableViewController
{
    var environmentServices: [Service] = [Service]()
    
    let BMP280Barometer: MBLBarometerBMP280 = ConnectionVC.currentlySelectedDevice.barometer as! MBLBarometerBMP280
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView(frame: .zero)
        
        let tempObject: Services = Services.sharedInstance
        environmentServices = tempObject.getAllServices(under: ServiceType.Environment)
        
        readPressure()
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        BMP280Barometer.periodicPressure.stopNotificationsAsync()
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
        return environmentServices.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var start: Int = 0, end: Int = 500
        
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! EnvironmentTVCell
        
        cell.serviceIcon.image = environmentServices[indexPath.row].serviceIcon
        cell.serviceName.text = environmentServices[indexPath.row].serviceName
        cell.serviceData.text = String(FitnessTVC.randomNumber(from: &start, to: &end))
        
        cell.selectionStyle = .None
        cell.serviceView.layer.borderColor = UIColor(red: 0.718, green: 0.722, blue: 0.702, alpha: 1.00).CGColor
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        print("Cell \(indexPath.row) selected")
    }
    
    func readPressure()
    {
        BMP280Barometer.periodicPressure.startNotificationsWithHandlerAsync { (result: AnyObject?, error: NSError?) in
            let currentPressure: MBLNumericData = result as! MBLNumericData
            print(currentPressure.value.integerValue)
        }
    }
}