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
    @IBOutlet weak var turnOnSwitch: UISwitch!
    @IBOutlet weak var manualBtn: UIButton!
    @IBOutlet weak var automaticBtn: UIButton!
    
    var photoSensorVoltage: Float = Float()
    var userTimer: NSTimer = NSTimer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initiateUIValues()
        
        if !Constants.isDeviceConnected()
        {
            presentViewController(Constants.defaultErrorAlert("Device Error", errorMessage: "A device needs to be connected to activate the photo sensor"), animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
    
    // POST: Keeps track of when manual mode is ON/OFF
    @IBAction func userSwitchAction(sender: UISwitch)
    {
        if sender.on
        {
            // TODO: Do stuff when switch is ON
            print("Switch turned ON")
        }
        else
        {
            print("Switch turned OFF")
        }
    }
    // POST: Sets up the slider with default values upon a successful view load
    func initiateUIValues()
    {
        metaWearValueSlider.minimumValue = Constants.userThresholdMinimumValue
        metaWearValueSlider.maximumValue = Constants.userThresholdMaximumValue
        userThresholdSlider.minimumValue = Constants.userThresholdMinimumValue
        userThresholdSlider.maximumValue = Constants.userThresholdMaximumValue
        
        hideAllManualOperationStuff()
        hideAllAutomaticOperationStuff()
        
        // makes the switch vertical
        turnOnSwitch.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        turnOnSwitch.onTintColor = UIColor(red: 0.208, green: 0.169, blue: 0.137, alpha: 1.00)
        
        manualBtn.setTitle("Manual OFF", forState: .Normal)
        manualBtn.setTitle("Manual ON", forState: .Selected)
        
        automaticBtn.setTitle("Automatic OFF", forState: .Normal)
        automaticBtn.setTitle("Automatic ON", forState: .Selected)
        
        manualBtn.addTarget(self, action: #selector(ActivationVC.manualButtonClicked(_:)), forControlEvents: .TouchUpInside)
        automaticBtn.addTarget(self, action: #selector(ActivationVC.automaticButtonClicked(_:)), forControlEvents: .TouchUpInside)
        
        manualBtn.layer.cornerRadius = 10
        automaticBtn.layer.cornerRadius = manualBtn.layer.cornerRadius
    }
    
    func readPhotoSensorValue()
    {
        var photoSensorVoltage: Float = Float()
        
        if let photoSensorGPIO = DevicesTVC.currentlySelectedDevice.gpio
        {
            let photoSensor: MBLGPIOPin = photoSensorGPIO.pins[Constants.PinAssignments.pinTwo] as! MBLGPIOPin
            
            photoSensor.analogAbsolute.readAsync().success({ (analogueResult: AnyObject) in
                
                let attainedValue = analogueResult as! MBLNumericData
                photoSensorVoltage = self.convertValueToSliderScale(attainedValue.value.floatValue)
                self.reflectChangesToMetaWearSlider(photoSensorVoltage)
                
            })
        }
    }
    
    // POST: Given a current voltage, converts it to the scale; Constants.userThresholdMinimumValue to Constants.userThresholdMaximumValue
    func convertValueToSliderScale(photoSensorVoltage: Float)-> Float
    {
        return (photoSensorVoltage / Constants.maximumPinVoltage) * Constants.userThresholdMaximumValue
    }
    
    func reflectChangesToMetaWearSlider(newMetaWearValue: Float)
    {
        metaWearValueSlider.setValue(newMetaWearValue, animated: true)
        metaWearLabel.text = String(Int(metaWearValueSlider.value))
    }
    
    // POST: Repeats the said task every taskDuration seconds
    func repeatThisTaskEvery(requiredTask: Selector, taskDuration: NSTimeInterval)
    {
        Constants.defaultTimer = NSTimer.scheduledTimerWithTimeInterval(taskDuration, target: self, selector: requiredTask, userInfo: nil, repeats: true)
    }
    
    func manualButtonClicked(sender: UIButton)
    {
        if !Constants.isDeviceConnected()
        {
            presentViewController(Constants.defaultErrorAlert("Invalid Operation", errorMessage: "A device needs to be connected to continue"), animated: true, completion: nil)
        }
        else
        {
            sender.selected = !sender.selected
            
            // manual mode selected
            if sender.selected
            {
                hideAllAutomaticOperationStuff()
                turnOnSwitch.hidden = false
            }
            else
            {
                turnOnSwitch.hidden = true
            }
        }
    }
    
    func automaticButtonClicked(sender: UIButton)
    {
        if !Constants.isDeviceConnected()
        {
            presentViewController(Constants.defaultErrorAlert("Invalid Operation", errorMessage: "A device needs to be connected to continue"), animated: true, completion: nil)
        }
        else
        {
            sender.selected = !sender.selected
            
            // automatic mode selected
            if sender.selected
            {
                unhideAllAutomaticOperationStuff()
                
                hideAllManualOperationStuff()
                
                // update photo sensor value each second
                repeatThisTaskEvery(#selector(ActivationVC.readPhotoSensorValue), taskDuration: 1.0)
            }
            else
            {
                Constants.defaultTimer.invalidate()
                hideAllAutomaticOperationStuff()
            }
        }
    }
    
    func hideAllManualOperationStuff()
    {
        turnOnSwitch.on = false
        turnOnSwitch.hidden = true
        manualBtn.selected = false
    }
    
    func hideAllAutomaticOperationStuff()
    {
        metaWearLabel.hidden = true
        metaWearValueSlider.hidden = true
        userThresholdSlider.hidden = true
        userThresholdLabel.hidden = true
        automaticBtn.selected = false
    }
    
    // POST: Sets a random slider value at first then unhides corresponding stuff
    func unhideAllAutomaticOperationStuff()
    {
        // TODO: Consider initiating the slider to some default value instead of random generation?
        userThresholdSlider.setValue(Float(arc4random_uniform(UInt32(Constants.userThresholdMaximumValue))), animated: true)
        userThresholdLabel.text = String(Int(userThresholdSlider.value))
        
        metaWearValueSlider.hidden = false
        userThresholdSlider.hidden = false
        
        metaWearLabel.hidden = false
        userThresholdLabel.hidden = false
    }
}
