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
}