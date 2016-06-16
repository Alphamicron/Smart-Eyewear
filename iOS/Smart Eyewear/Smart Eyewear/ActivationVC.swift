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
    @IBOutlet weak var helpBtn: UIButton!
    
    @IBOutlet weak var helpTextLabel: UILabel!
    
    @IBOutlet weak var cloudyImageView: UIImageView!
    @IBOutlet weak var cloudySunnyImageView: UIImageView!
    @IBOutlet weak var sunnyImageView: UIImageView!
    
    var photoSensorVoltage: Float = Float()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if !Constants.isDeviceConnected()
        {
            Constants.defaultErrorAlert(self, errorTitle: "Connection Error", errorMessage: "A CTRL Eyewear needs to be connected to activate the photo sensor", errorPriority: Constants.AlertPriority.Medium)
            
            Constants.displayBackgroundImageOnError(self.view, typeOfError: Constants.ErrorState.NoMetaWear)
        }
        else
        {
            initiateUIValues()
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = Constants.themeRedColour
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "NavGogglesWhite"))
        
        ActivationVC.turnLED(Constants.LEDState.Off)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
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
            // TODO: Check if its already ON before actually turning it ON.
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
            
            ActivationVC.turnLED(Constants.LEDState.Off)
        }
    }
    
    @IBAction func automaticSwitchAction(sender: UISwitch)
    {
        if sender.on
        {
            manualSwitch.setOn(false, animated: true)
            manualSwitch.sendActionsForControlEvents(.ValueChanged)
            
            setImagesForState(Constants.LEDState.On)
            
            metaWearValueSlider.thumbTintColor = Constants.themeRedColour
            userThresholdSlider.thumbTintColor = UIColor(red: 0.502, green: 0.506, blue: 0.518, alpha: 1.00)
            
            userThresholdSlider.minimumTrackTintColor = Constants.themeRedColour
            metaWearValueSlider.minimumTrackTintColor = Constants.themeRedColour
            
            helpBtn.hidden = false
            
            userThresholdSlider.setValue(Constants.userThresholdMaximumValue/2, animated: true)
            userThresholdSlider.userInteractionEnabled = true
            
            repeatThisTaskEvery(#selector(ActivationVC.readPhotoSensorValue), taskDuration: Constants.defaultDelayTime)
        }
        else
        {
            Constants.defaultTimer.invalidate()
            
            helpBtn.hidden = true
            helpTextLabel.hidden = true
            userThresholdSlider.userInteractionEnabled = false
            
            userThresholdSlider.thumbTintColor = Constants.themeInactiveStateColour
            metaWearValueSlider.thumbTintColor = Constants.themeInactiveStateColour
            
            userThresholdSlider.minimumTrackTintColor = Constants.themeInactiveStateColour
            metaWearValueSlider.minimumTrackTintColor = Constants.themeInactiveStateColour
            
            userThresholdSlider.setValue(Float(), animated: true)
            metaWearValueSlider.setValue(Float(), animated: true)
            
            setImagesForState(Constants.LEDState.Off)
            
            ActivationVC.turnLED(Constants.LEDState.Off)
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
        //        if !Constants.isDeviceConnected()
        //        {
        //            Constants.defaultErrorAlert(self, errorTitle: "Connection Error", errorMessage: "A CTRL Eyewear needs to be connected to continue", errorPriority: Constants.AlertPriority.Medium)
        //        }
        //        else
        //        {
        //            sender.selected = !sender.selected
        //            
        //            if sender.selected
        //            {
        //                print("button on")
        //                sender.setTitle("ON", forState: .Selected)
        //                sender.backgroundColor = Constants.themeGreenColour
        //                
        //                userThresholdSlider.setValue(Constants.userThresholdMaximumValue/2, animated: true)
        //                userThresholdSlider.userInteractionEnabled = true
        //                
        //                repeatThisTaskEvery(#selector(ActivationVC.readPhotoSensorValue), taskDuration: Constants.defaultDelayTime)
        //            }
        //            else
        //            {
        //                print("button off")
        //                Constants.defaultTimer.invalidate()
        //                sender.setTitle("OFF", forState: .Normal)
        //                sender.backgroundColor = Constants.themeRedColour
        //                userThresholdSlider.userInteractionEnabled = false
        //            }
        //        }
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
    
    func setImagesForState(ledState: Constants.LEDState)
    {
        switch ledState
        {
        case .On:
            cloudyImageView.image = UIImage(named: "Clouds")
            cloudySunnyImageView.image = UIImage(named: "CloudySunny")
            sunnyImageView.image = UIImage(named: "Sunny")
            
        case .Off:
            cloudyImageView.image = UIImage(named: "CloudsGray")
            cloudySunnyImageView.image = UIImage(named: "CloudsSunnyGray")
            sunnyImageView.image = UIImage(named: "SunnyGray")
        }
    }
    
    // POST: Sets up the slider with default values upon a successful view load
    func initiateUIValues()
    {
        // resize the mode activating switches
        manualSwitch.transform = CGAffineTransformMakeScale(1.25, 1.25)
        automaticSwitch.transform = CGAffineTransformMakeScale(1.25, 1.25)
        
        metaWearValueSlider.minimumValue = Constants.userThresholdMinimumValue
        metaWearValueSlider.maximumValue = Constants.userThresholdMaximumValue
        userThresholdSlider.minimumValue = Constants.userThresholdMinimumValue
        userThresholdSlider.maximumValue = Constants.userThresholdMaximumValue
        
        userThresholdSlider.thumbTintColor = Constants.themeInactiveStateColour
        metaWearValueSlider.thumbTintColor = Constants.themeInactiveStateColour
        
        userThresholdSlider.userInteractionEnabled = false
        
        helpBtn.hidden = true
        helpTextLabel.hidden = true
        
        setImagesForState(Constants.LEDState.Off)
        
        manualBtn.setTitle("OFF", forState: .Normal)
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
