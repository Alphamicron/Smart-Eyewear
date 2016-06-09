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
    //    @IBOutlet weak var userThresholdLabel: UILabel!
    //    @IBOutlet weak var metaWearLabel: UILabel!
    @IBOutlet weak var manualSwitch: UISwitch!
    
    @IBOutlet weak var automaticSwitch: UISwitch!
    
    @IBOutlet weak var manualBtn: UIButton!
    @IBOutlet weak var automaticBtn: UIButton!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var helpTextLabel: UILabel!
    var photoSensorVoltage: Float = Float()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if !Constants.isDeviceConnected()
        {
            presentViewController(Constants.defaultErrorAlert("Device Error", errorMessage: "A device needs to be connected to activate the photo sensor"), animated: true, completion: nil)
            
            Constants.displayBackgroundImageOnError(self.view, typeOfError: Constants.ErrorState.NoMetaWear)
        }
        else
        {
            initiateUIValues()
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        // TODO: Is this really necessary?
        ActivationVC.turnLED(Constants.LEDState.Off)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // POST: Keeps track of the photo sensor's threshold changes
    func metawearThresholdChanged(sender: UISlider)
    {
        if sender.value > userThresholdSlider.value
        {
            ActivationVC.turnLED(Constants.LEDState.On)
        }
        else
        {
            ActivationVC.turnLED(Constants.LEDState.Off)
        }
    }
    
    // POST: Keeps track of the user's threshold changes
    @IBAction func userThresholdChange(sender: UISlider)
    {
        if sender.value < metaWearValueSlider.value
        {
            ActivationVC.turnLED(Constants.LEDState.On)
        }
        else
        {
            ActivationVC.turnLED(Constants.LEDState.Off)
        }
        
        //        userThresholdLabel.text = String(Int(userThresholdSlider.value))
    }
    
    // POST: tracks when manual mode is activated
    @IBAction func manualSwitchAction(sender: UISwitch)
    {
        if sender.on
        {
            automaticSwitch.setOn(false, animated: true)
            automaticSwitch.sendActionsForControlEvents(.ValueChanged)
            helpTextLabel.hidden = true
            manualBtn.backgroundColor = Constants.themeRedColour
            manualBtn.userInteractionEnabled = true
        }
        else
        {
            manualBtn.setTitle("OFF", forState: .Normal)
            manualBtn.backgroundColor = Constants.themeInactiveStateColour
            manualBtn.userInteractionEnabled = false
        }
    }
    
    @IBAction func automaticSwitchAction(sender: UISwitch)
    {
        if sender.on
        {
            manualSwitch.setOn(false, animated: true)
            manualSwitch.sendActionsForControlEvents(.ValueChanged)
            
            automaticBtn.backgroundColor = Constants.themeRedColour
            automaticBtn.userInteractionEnabled = true
            automaticBtn.setTitle("OFF", forState: .Normal)
            
            helpBtn.hidden = false
        }
        else
        {
            automaticBtn.setTitle("OFF", forState: .Selected)
            automaticBtn.backgroundColor = Constants.themeInactiveStateColour
            automaticBtn.userInteractionEnabled = false
            helpBtn.hidden = true
        }
    }
    
    
    @IBAction func manualBtnAction(sender: UIButton)
    {
        sender.selected = !sender.selected // keeps track of button presses
        
        if sender.selected // button has already been pressed before
        {
            ActivationVC.turnLED(Constants.LEDState.Off)
            sender.setTitle("OFF", forState: .Selected)
            sender.backgroundColor = Constants.themeRedColour
            
        }
        else // not pressed before
        {
            sender.setTitle("ON", forState: .Normal)
            ActivationVC.turnLED(Constants.LEDState.On)
            sender.backgroundColor = Constants.themeGreenColour
        }
    }
    
    @IBAction func automaticBtnAction(sender: UIButton)
    {
        if !Constants.isDeviceConnected()
        {
            presentViewController(Constants.defaultErrorAlert("Invalid Operation", errorMessage: "A device needs to be connected to continue"), animated: true, completion: nil)
        }
        else
        {
            sender.selected = !sender.selected
            
            if sender.selected
            {
                print("button on")
                sender.setTitle("ON", forState: .Selected)
                sender.backgroundColor = Constants.themeGreenColour
                
                userThresholdSlider.userInteractionEnabled = true
                
                repeatThisTaskEvery(#selector(ActivationVC.readPhotoSensorValue), taskDuration: Constants.defaultDelayTime)
            }
            else
            {
                print("button off")
                Constants.defaultTimer.invalidate()
                sender.setTitle("OFF", forState: .Normal)
                sender.backgroundColor = Constants.themeRedColour
                userThresholdSlider.userInteractionEnabled = false
            }
        }
    }
    
    @IBAction func helpBtnAction(sender: UIButton)
    {
        if helpTextLabel.hidden
        {
            helpTextLabel.hidden = false
        }
        else
        {
            helpTextLabel.hidden = true
        }
    }
    
    // POST: Sets up the slider with default values upon a successful view load
    func initiateUIValues()
    {
        metaWearValueSlider.minimumValue = Constants.userThresholdMinimumValue
        metaWearValueSlider.maximumValue = Constants.userThresholdMaximumValue
        userThresholdSlider.minimumValue = Constants.userThresholdMinimumValue
        userThresholdSlider.maximumValue = Constants.userThresholdMaximumValue
        
        userThresholdSlider.userInteractionEnabled = false
        
        helpBtn.hidden = true
        helpTextLabel.hidden = true
        
        manualBtn.setTitle("OFF", forState: .Normal)
        automaticBtn.setTitle("OFF", forState: .Normal)
    }
    
    // POST: Get voltage of photo sensor pin and reflects it onto the metaWearSlider
    func readPhotoSensorValue()
    {
        var photoSensorVoltage: Float = Float()
        
        if let photoSensorGPIO = ConnectionVC.currentlySelectedDevice.gpio
        {
            let photoSensor: MBLGPIOPin = photoSensorGPIO.pins[Constants.PinAssignments.pinTwo] as! MBLGPIOPin
            
            photoSensor.analogAbsolute.readAsync().success({ (analogueResult: AnyObject) in
                
                // cast the value to numeric value
                let attainedValue = analogueResult as! MBLNumericData
                // converts the voltage to a 0-1024 scale
                photoSensorVoltage = self.convertValueToSliderScale(attainedValue.value.floatValue)
                // displays the scaled up value onto the slider
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
        //        metaWearLabel.text = String(Int(metaWearValueSlider.value))
        
        // check to see if the photo sensor value change requires the LED to be turned on
        metawearThresholdChanged(metaWearValueSlider)
    }
    
    // POST: Repeats the said task every taskDuration seconds
    func repeatThisTaskEvery(requiredTask: Selector, taskDuration: NSTimeInterval)
    {
        Constants.defaultTimer = NSTimer.scheduledTimerWithTimeInterval(taskDuration, target: self, selector: requiredTask, userInfo: nil, repeats: true)
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
                repeatThisTaskEvery(#selector(ActivationVC.readPhotoSensorValue), taskDuration: Constants.defaultDelayTime)
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
        manualSwitch.on = false
        manualSwitch.hidden = true
        manualBtn.selected = false
    }
    
    func hideAllAutomaticOperationStuff()
    {
        //        metaWearLabel.hidden = true
        metaWearValueSlider.hidden = true
        userThresholdSlider.hidden = true
        //        userThresholdLabel.hidden = true
        automaticBtn.selected = false
    }
    
    // POST: Sets a random slider value at first then unhides corresponding stuff
    func unhideAllAutomaticOperationStuff()
    {
        metaWearValueSlider.hidden = false
        userThresholdSlider.hidden = false
        
        //        metaWearLabel.hidden = false
        //        userThresholdLabel.hidden = false
    }
    
    static func turnLED(ledState: Constants.LEDState)
    {
        if let metaWearGPIO = ConnectionVC.currentlySelectedDevice.gpio
        {
            let LEDPin = metaWearGPIO.pins[Constants.PinAssignments.pinOne] as! MBLGPIOPin
            
            switch ledState
            {
            case .On:
                LEDPin.setToDigitalValueAsync(true)
            case .Off:
                LEDPin.setToDigitalValueAsync(false)
            }
        }
    }
}
