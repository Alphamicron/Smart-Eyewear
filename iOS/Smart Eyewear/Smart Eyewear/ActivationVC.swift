//
//  ActivationVC.swift
//  Smart Eyewear
//
//  Created by Emil Shirima on 5/24/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class ActivationVC: UIViewController
{
    @IBOutlet weak var userThresholdSlider: UISlider!
    @IBOutlet weak var metaWearValueSlider: UISlider!
    @IBOutlet weak var userThresholdLabel: UILabel!
    @IBOutlet weak var metaWearLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initiateSliderValues()
        
        if !Constants.isDeviceConnected()
        {
            presentViewController(Constants.defaultErrorAlert("Device Error", errorMessage: "A device needs to be connected to change its LED colours"), animated: true, completion: nil)
        }
        else
        {
            if let photoSensorGPIO = DevicesTVC.currentlySelectedDevice.gpio
            {
                let photoSensor: MBLGPIOPin = photoSensorGPIO.pins[2] as! MBLGPIOPin
                photoSensor.analogAbsolute.readAsync().success({ (result: AnyObject) in
                    print(result)
                    let temp = result as! MBLNumericData
                    print(temp)
                    print(temp.value.floatValue)
                })
            }
            
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func turnOnOffBtnAction(sender: UIButton)
    {
        if sender.currentTitle == "Turn On"
        {
            // TODO: Diconnect connection from the photo sensor
            sender.setTitle("Turn Off", forState: .Normal)
        }
        else
        {
            // TODO: Initiate connection to the poto sensor
            sender.setTitle("Turn On", forState: .Normal)
        }
    }
    
    @IBAction func automaticBtnAction(sender: UIButton)
    {
        print("Automatic Mode Activated")
    }
    
    // POST: Keeps track of the user's threshold changes
    @IBAction func userThresholdChange(sender: UISlider)
    {
        print("Current value: \(sender.value)")
        userThresholdLabel.text = String(Int(sender.value))
    }
    
    
    func initiateSliderValues()
    {
        userThresholdSlider.minimumValue = Constants.userThresholdMinimumValue
        userThresholdSlider.maximumValue = Constants.userThresholdMaximumValue
        
        metaWearValueSlider.minimumValue = userThresholdSlider.minimumValue
        metaWearValueSlider.maximumValue = userThresholdSlider.maximumValue
        
        // MARK: Consider initiating the slider to some default value instead of random generation?
        userThresholdSlider.setValue(Float(arc4random_uniform(UInt32(Constants.userThresholdMaximumValue))), animated: true)
        
        metaWearLabel.text = String(Int(metaWearValueSlider.value))
        userThresholdLabel.text = String(Int(userThresholdSlider.value))
    }
}
