//
//  MotionSensorsVC.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 6/22/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class MotionSensorsVC: UIViewController
{
    @IBOutlet weak var accelerometerBtn: UIButton!
    @IBOutlet weak var gyroscopeBtn: UIButton!
    @IBOutlet weak var magnetometerBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if !Constants.isDeviceConnected()
        {
            Constants.defaultErrorAlert(self, errorTitle: "Connection Error", errorMessage: "A CTRL Eyewear needs to be connected to access its sensors", errorPriority: AlertPriority.Medium)
            
            Constants.displayBackgroundImageOnError(self.view, typeOfError: ErrorState.NoMetaWear)
        }
        else
        {
            // increase character spacing
            accelerometerBtn.titleLabel?.kerning = 1.0
            gyroscopeBtn.titleLabel?.kerning = (accelerometerBtn.titleLabel?.kerning)!
            magnetometerBtn.titleLabel?.kerning = (accelerometerBtn.titleLabel?.kerning)!
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = Constants.themeRedColour
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "NavOthersWhite"))
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let destinationVC = segue.destinationViewController as! GraphsVC
        
        if segue.identifier == "segueToAccelerometer"
        {
            destinationVC.desiredSensor = Sensor.Accelerometer
        }
        else if segue.identifier == "segueToMagnetometer"
        {
            destinationVC.desiredSensor = Sensor.Magnetometer
        }
        else if segue.identifier == "segueToGyroscope"
        {
            destinationVC.desiredSensor = Sensor.Gyroscope
        }
    }
}
