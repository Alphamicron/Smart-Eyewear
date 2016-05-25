//
//  RGBLedVC.swift
//  Smart Eyewear
//
//  Created by Emil Shirima on 5/24/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class RGBLedVC: UIViewController
{
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        DevicesTVC.currentlySelectedDevice.led?.setLEDOnAsync(false, withOptions: 1)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if !Constants.isDeviceConnected()
        {
            presentViewController(Constants.defaultErrorAlert("Device Error", errorMessage: "A device needs to be connected to see its battery life."), animated: true, completion: nil)
        }
        else
        {
            DevicesTVC.currentlySelectedDevice.led?.flashLEDColorAsync(UIColor(red: 0.004, green: 0.098, blue: 0.200, alpha: 1.00), withIntensity: 1.0, numberOfFlashes: 3)
            
            Constants.delayFor(5, closure: {
                
                DevicesTVC.currentlySelectedDevice.led?.flashLEDColorAsync(UIColor(red: 0.224, green: 0.071, blue: 0.122, alpha: 1.00), withIntensity: 1.0, numberOfFlashes: 5)
            })
            
            Constants.delayFor(10, closure: {
                
                DevicesTVC.currentlySelectedDevice.led?.flashLEDColorAsync(UIColor(red: 0.847, green: 0.780, blue: 0.682, alpha: 1.00), withIntensity: 1.0, numberOfFlashes: 5)
            })
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
