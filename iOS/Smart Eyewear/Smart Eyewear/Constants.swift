//
//  Constants.swift
//  Smart Eyewear
//
//  Created by Emil Shirima on 5/24/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import Foundation

struct Constants
{
    static var numberOfButtonTaps: Int = Int()
    static let deviceFullChargeValue: NSNumber = 100
    static let defaultTimeOut: NSTimeInterval = 15 // max waiting time for a device to be connected
    static let defaultDelayTime: NSTimeInterval = 1.0
    static let defaultLEDIntensity: CGFloat = 1.0
    static var defaultTimer: NSTimer = NSTimer()
    static let userThresholdMinimumValue: Float = Float() // min value for a valid photo sensor threshold
    static let userThresholdMaximumValue: Float = 1024 // max value for a valid photo sensor threshold
    static let maximumPinVoltage: Float = 3.0 // maximum voltage supplied by Pin 6 as of https://mbientlab.com/docs/MetaWearCPSv0.5.pdf
    static let defaultFont: UIFont = UIFont(name: "AvenirNext-Regular", size: 20)!
    
    static func defaultErrorAlert(errorTitle: String, errorMessage: String)->UIAlertController
    {
        let defaultAlertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .Alert)
        
        defaultAlertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
        
        return defaultAlertController
    }
    
    // POST: Delays any operation for 'delayTime' duration. Time is in seconds.
    static func delayFor(delayTime: Double, closure:()->())
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delayTime * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    static func isDeviceConnected()->Bool
    {
        if DevicesTVC.currentlySelectedDevice.state != .Connected
        {
            return false
        }
        return true
    }
    
    static func turnOffMetaWearLED()
    {
        DevicesTVC.currentlySelectedDevice.led?.setLEDOnAsync(false, withOptions: 1)
    }
    
    static func disconnectDevice()
    {
        DevicesTVC.currentlySelectedDevice.disconnectWithHandler(nil)
    }
    
    static func displayBackgroundImageOnError(currentView: UIView, typeOfError: ErrorState)
    {
        // if any subviews exist, just delete them
        if currentView.subviews.count != Int()
        {
            for thisSubview in currentView.subviews
            {
                thisSubview.removeFromSuperview()
            }
        }
        
        let errorImageView: UIImageView = UIImageView(frame: CGRect(x: currentView.frame.origin.x, y: currentView.frame.origin.y, width: currentView.frame.width, height: currentView.frame.height))
        errorImageView.center = CGPointMake(currentView.bounds.size.width/2, currentView.bounds.size.height/2)
        errorImageView.contentMode = .ScaleAspectFill
        
        switch typeOfError
        {
        case .NoMetaWear:
            errorImageView.image = UIImage(named: "NoDevice")
            
        case .NoBLEConnection:
            errorImageView.image = UIImage(named: "Bluetooth")
        }
        
        errorImageView.backgroundColor = UIColor.whiteColor()
        
        currentView.addSubview(errorImageView)
    }
    
    static func setButtonToFlashLED()
    {
        // erase any existing commands before assigning new ones
        if let deviceHasButtonPrograms = DevicesTVC.currentlySelectedDevice.mechanicalSwitch?.switchUpdateEvent.hasCommands()
        {
            print(deviceHasButtonPrograms)
            
            if deviceHasButtonPrograms
            {
                DevicesTVC.currentlySelectedDevice.mechanicalSwitch?.switchUpdateEvent.eraseCommandsToRunOnEventAsync()
                
            }
            
            print(DevicesTVC.currentlySelectedDevice.mechanicalSwitch?.switchUpdateEvent.hasCommands())
            
        }
        
        DevicesTVC.currentlySelectedDevice.mechanicalSwitch?.switchUpdateEvent.programCommandsToRunOnEventAsync({
            
            //            ActivationVC.turnLED(Constants.LEDState.Off)
            
            //            print(Constants.numberOfButtonTaps)
            //            
            //            if Constants.numberOfButtonTaps % 2 == 0
            //            {
            //                ActivationVC.turnLED(Constants.LEDState.Off)
            //            }
            //            else
            //            {
            //                ActivationVC.turnLED(Constants.LEDState.On)
            //            }
            
            //            ActivationVC.turnLED(Constants.LEDState.Off)
            
            //            DevicesTVC.currentlySelectedDevice.led?.flashLEDColorAsync(UIColor.redColor(), withIntensity: 1.0, numberOfFlashes: 3)
            
            //            else
            //            {
            //                ActivationVC.turnLED(Constants.LEDState.On)
            //            }
            
            
            if let metaWearGPIO = DevicesTVC.currentlySelectedDevice.gpio
            {
                let LEDPin = metaWearGPIO.pins[Constants.PinAssignments.pinOne] as! MBLGPIOPin
                
                //                LEDPin.setToDigitalValueAsync(true)
                
                print("LEDPin Stuff: \(LEDPin)")
                print("LEDPin Data: \(LEDPin.digitalValue)")
                
                LEDPin.digitalValue.readAsync().success({ (result: AnyObject) in
                    
                    let pinValue: MBLNumericData = result as! MBLNumericData
                    
                    if pinValue.value.boolValue
                    {
                        print("LED is ON")
                        LEDPin.setToDigitalValueAsync(false)
                    }
                    else
                    {
                        print("LED is OFF")
                        LEDPin.setToDigitalValueAsync(true)
                    }
                })
            }
            
            
            //            DevicesTVC.currentlySelectedDevice.mechanicalSwitch?.switchUpdateEvent.startNotificationsWithHandlerAsync({ (result: AnyObject?, error: NSError?) in
            //                if error == nil
            //                {
            //                    let switchState: MBLNumericData = result as! MBLNumericData
            //                    
            //                    if switchState.value.boolValue
            //                    {
            //                        DevicesTVC.currentlySelectedDevice.led?.setLEDColorAsync(UIColor.redColor(), withIntensity: 1.0)
            //                    }
            //                    else
            //                    {
            //                        DevicesTVC.currentlySelectedDevice.led?.setLEDOnAsync(false, withOptions: 1)
            //                    }
            //                    
            //                    print("Switch value: \(switchState.value.boolValue)")
            //                }
            //                else
            //                {
            //                    print("Error getting switch state")
            //                    print(error?.localizedDescription)
            //                }
            //            })
        })
    }
    
    // Refer https://mbientlab.com/docs/MetaWearCPSv0.5.pdf
    struct PinAssignments
    {
        static let pinZero: Int = Int() // DIO0/AIN0
        static let pinOne: Int = 1 // DIO1/AIN1
        static let pinTwo: Int = 2 // DIO2/AIN2
        static let pinThree: Int = 3 // DIO3/AIN3
        static let pinFour: Int = 4 // DIO4
    }
    
    enum LEDState
    {
        case On
        case Off
    }
    
    enum ErrorState
    {
        case NoMetaWear
        case NoBLEConnection
    }
}