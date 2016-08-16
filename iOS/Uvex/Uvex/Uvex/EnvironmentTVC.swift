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
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        BMP280Barometer.periodicPressure.stopNotificationsAsync()
        BMP280Barometer.periodicAltitude.stopNotificationsAsync()
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
        var start: Int = 0, end: Int = 100
        
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! EnvironmentTVCell
        
        cell.serviceIcon.image = environmentServices[indexPath.row].serviceIcon
        cell.serviceName.text = environmentServices[indexPath.row].serviceName
        
        switch indexPath.row
        {
        case 0: // Humidity
            cell.serviceData.text = String(FitnessTVC.randomNumber(from: &start, to: &end))
        case 1: // Pressure
            readPressure(thenUpdateOn: cell.serviceData)
        case 2: // Temperature
            readTemperature(thenUpdateOn: cell.serviceData)
        case 3: // Altitude
            readAltitude(thenUpdateOn: cell.serviceData)
        default:
            break
        }
        
        cell.selectionStyle = .None
        cell.serviceView.layer.borderColor = UIColor(red: 0.718, green: 0.722, blue: 0.702, alpha: 1.00).CGColor
        
        return cell
    }
    
    func readPressure(thenUpdateOn dataLabel: UILabel)
    {
        BMP280Barometer.periodicPressure.startNotificationsWithHandlerAsync { (result: AnyObject?, error: NSError?) in
            
            if let pressureError = error
            {
                Constants.defaultErrorAlert(self, errorTitle: "Sensor Error", errorMessage: pressureError.localizedDescription, errorPriority: AlertPriority.Medium)
            }
            
            let currentPressure: MBLNumericData = result as! MBLNumericData
            dataLabel.text = String(currentPressure.value.integerValue)
        }
    }
    
    func readTemperature(thenUpdateOn dataLabel: UILabel)
    {
        ConnectionVC.currentlySelectedDevice.temperature?.onboardThermistor?.readAsync().success({ (result: AnyObject) in
            
            let currentTemperature: MBLNumericData = result as! MBLNumericData
            dataLabel.text = String(Int(self.convertToFahrenheit(currentTemperature.value.floatValue)))
        })
    }
    
    func readAltitude(thenUpdateOn dataLabel: UILabel)
    {
        BMP280Barometer.periodicAltitude.startNotificationsWithHandlerAsync { (result: AnyObject?, error: NSError?) in
            
            if let altitudeError = error
            {
                Constants.defaultErrorAlert(self, errorTitle: "Sensor Error", errorMessage: altitudeError.localizedDescription, errorPriority: AlertPriority.Medium)
            }
            
            let currentAltitude: MBLNumericData = result as! MBLNumericData
            print(currentAltitude.value.floatValue)
            dataLabel.text = String(currentAltitude.value.integerValue)
        }
    }
    
    func convertToFahrenheit(temperature: Float)->Float
    {
        return (1.8 * temperature) + 32.0
    }
}