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
    static let defaultDelayTime: NSTimeInterval = 2.0
    static let defaultLEDIntensity: CGFloat = 1.0
    static let userThresholdMinimumValue: Float = Float() // min value for a valid photo sensor threshold
    static let userThresholdMaximumValue: Float = 1024 // max value for a valid photo sensor threshold
    
    
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
    
    static func turnOffAllLEDs()
    {
        DevicesTVC.currentlySelectedDevice.led?.setLEDOnAsync(false, withOptions: 1)
    }
    
    static func disconnectDevice()
    {
        DevicesTVC.currentlySelectedDevice.disconnectWithHandler(nil)
    }
}