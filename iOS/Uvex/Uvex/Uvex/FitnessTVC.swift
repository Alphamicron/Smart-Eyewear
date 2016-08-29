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
    @IBOutlet weak var serviceView: UIView!
}

class FitnessTVC: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var totalCalories: Int = Int()
    var totalDistance: Double = Double()
    var totalNumberOfSteps: Int = Int()
    var graphPoints: GraphPoints = GraphPoints()
    var fitnessServices: [Service] = [Service]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.separatorStyle = .None
        tableView.tableFooterView = UIView(frame: .zero)
        
        let tempObject = Services.sharedInstance
        fitnessServices = tempObject.getAllServices(under: ServiceType.Fitness)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        ConnectionVC.currentlySelectedDevice.accelerometer?.dataReadyEvent.stopNotificationsAsync()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func startBtnAction(sender: UIButton)
    {
        sender.selected = !sender.selected
        
        if sender.selected // user wants to start logging their workout
        {
            sender.setTitle("STOP", forState: .Selected)
            
            getAccelerometerReading()
        }
        else // user stopped logging hence graph their results
        {
            sender.setTitle("START", forState: .Normal)
            
            ConnectionVC.currentlySelectedDevice.accelerometer?.dataReadyEvent.stopNotificationsAsync()
            
            let stepCounterObject: StepCounter = StepCounter(graphPoints: &self.graphPoints)
            let result = stepCounterObject.numberOfSteps()
            
            self.totalNumberOfSteps = result.totalSteps
            self.totalDistance = result.distanceInFeet
            tableView.reloadData()
            
            
            print("calculated data: \(result)")
        }
    }
    
    func getAccelerometerReading()
    {
        ConnectionVC.currentlySelectedDevice.accelerometer?.dataReadyEvent.startNotificationsWithHandlerAsync({ (result: AnyObject?, error: NSError?) in
            if error == nil
            {
                let accelData: MBLAccelerometerData = result as! MBLAccelerometerData
                
                self.graphPoints.xAxes.append(accelData.x)
                self.graphPoints.yAxes.append(accelData.y)
                self.graphPoints.zAxes.append(accelData.z)
                self.graphPoints.rmsValues.append(accelData.RMS)
                
                print(accelData)
            }
            else
            {
                print("Error getting accelerometer data")
                print(error?.localizedDescription)
                
                Constants.defaultErrorAlert(self, errorTitle: "Error", errorMessage: (error?.localizedDescription)!, buttonText: "Yap")
                
            }
        })
    }
    
    static func randomNumber(inout from start: Int, inout to end: Int)-> Int
    {
        if start > end
        {
            swap(&start, &end)
        }
        
        return Int(arc4random_uniform(UInt32(end - start + 1))) + start
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
        
        switch indexPath.row
        {
        case 0: cell.serviceData.text = String(self.totalNumberOfSteps)
        case 1: cell.serviceData.text = String(FitnessTVC.randomNumber(from: &first, to: &second))
        case 2: cell.serviceData.text = String(Int(self.totalDistance))
        default: break
        }
        
        //        cell.serviceData.text = String(FitnessTVC.randomNumber(from: &first, to: &second))
        
        cell.selectionStyle = .None
        cell.serviceView.layer.borderColor = UIColor(red: 0.796, green: 0.800, blue: 0.796, alpha: 1.00).CGColor
        
        return cell
    }
}

extension FitnessTVC: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch indexPath.row
        {
        case 0: self.performSegueWithIdentifier("segueToStepsVC", sender: nil)
        case 1: self.performSegueWithIdentifier("segueToCaloriesVC", sender: nil)
        case 2: self.performSegueWithIdentifier("segueToDistanceVC", sender: nil)
        default: break
        }
    }
}