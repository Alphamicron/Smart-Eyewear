//
//  BatteryLevelVC.swift
//  Smart Eyewear
//
//  Created by Emil Shirima on 5/24/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit
import PNChart

class BatteryLevelVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if !Constants.isDeviceConnected()
        {
            presentViewController(Constants.defaultErrorAlert("Device Error", errorMessage: "A device needs to be connected to see its battery life."), animated: true, completion: nil)
            
            drawCircleGraph(0)
        }
        else
        {
            DevicesTVC.currentlySelectedDevice.readBatteryLifeWithHandler({ (deviceChargeValue: NSNumber?, error: NSError?) in
                if let batteryCheckError = error
                {
                    let alertController = UIAlertController(title: "Battery Check Error", message: batteryCheckError.localizedDescription, preferredStyle: .Alert)
                    
                    alertController.addAction(UIAlertAction(title: "Try Again", style: .Default, handler: { (action: UIAlertAction) in
                        self.viewDidLoad()
                    }))
                    
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
                self.drawCircleGraph(deviceChargeValue!)
            })
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // POST: Represents the device's charge in a circle graph
    func drawCircleGraph(currentDeviceCharge: NSNumber)
    {
        let circleFrame: CGRect = CGRect(x: self.view.bounds.size.width/2, y: self.view.bounds.size.width/5, width: self.view.bounds.size.width/65, height: self.view.bounds.size.height/2)
        
        let circleChart = PNCircleChart(frame: circleFrame, total: Constants.deviceFullChargeValue, current: currentDeviceCharge, clockwise: true, shadow: true, shadowColor: UIColor.grayColor())
        
        circleChart.displayCountingLabel = true
        circleChart.lineWidth = 25
        circleChart.backgroundColor = UIColor.clearColor()
        circleChart.strokeColor = UIColor(red: 0.302, green: 0.769, blue: 0.478, alpha: 1.00)
        circleChart.strokeChart()
        
        self.view.addSubview(circleChart)
    }
    
}
