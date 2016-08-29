//
//  Constants.swift
//  Uvex
//
//  Created by Alphamicron on 7/29/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit
import Foundation
import JSSAlertView

/**************************************************************
 +------------------------------------------------------------+
 | Name:    Constants                                         |
 | Purpose: Holds all constant variables, methods that        |
 |          perform the same operations throughout and        |
 |          structures universally used in the app            |
 +------------------------------------------------------------+
 **************************************************************/

struct Constants
{
    // Metawear
    static let maximumPinVoltage: Float = 3.0 // maximum voltage supplied by Pin 6 as of https://mbientlab.com/docs/MetaWearCPSv0.5.pdf
    static let metaWearName: String = "MetaWear"
    static let deviceFullChargeValue: NSNumber = 100
    static let userThresholdMaximumValue: Float = 1024 // photo sensor max threshold
    static let userThresholdMinimumValue: Float = Float() // photo sensor threshold min threshold
    
    // Timers
    static var defaultTimer: NSTimer = NSTimer()
    static let defaultTimeOut: NSTimeInterval = 15 // max waiting time for a device to be connected
    static let defaultDelayTime: NSTimeInterval = 1.0
    
    // UI
    static let defaultHeadingFont: UIFont = UIFont(name: "AvenirNext-Bold", size: 40)!
    static let defaultNormalFont: UIFont = UIFont(name: "AvenirNext-Regular", size: 20)!
    static let themeRedColour: UIColor = UIColor(red: 0.925, green: 0.114, blue: 0.141, alpha: 1.00)
    static let themeGreyColour: UIColor = UIColor(red: 0.706, green: 0.710, blue: 0.706, alpha: 1.00)
    static let themeBlueColour: UIColor = UIColor(red: 0.000, green: 0.639, blue: 0.855, alpha: 1.00)
    static let themeTextColour: UIColor = UIColor(red: 0.502, green: 0.506, blue: 0.518, alpha: 1.00)
    static let themeGreenColour: UIColor = UIColor(red: 0.290, green: 0.839, blue: 0.388, alpha: 1.00)
    static let themeYellowColour: UIColor = UIColor(red: 0.941, green: 0.843, blue: 0.020, alpha: 1.00)
    static let themeOrangeColour: UIColor = UIColor(red: 0.918, green: 0.467, blue: 0.192, alpha: 1.00)
    
    static func defaultErrorAlert(origin: UIViewController, errorTitle: String, errorMessage: String, buttonText: String)
    {
        let userAlert = JSSAlertView().show(
            origin,
            title: errorTitle,
            text: errorMessage,
            buttonText: buttonText
        )
        
        userAlert.setTextTheme(.Dark)
        userAlert.setTitleFont("AvenirNext-Regular")
        userAlert.setTextFont("AvenirNext-Regular")
        userAlert.setButtonFont("AvenirNext-Regular")
    }
    
    static func defaultNoDeviceAlert(On origin: UIViewController)
    {
        let userAlert = JSSAlertView().show(
            origin,
            title: "Device Error",
            text: "A Uvex Eyewear needs to be connected to access features.",
            buttonText: "dismiss"
        )
        
        userAlert.setTextTheme(.Dark)
        userAlert.setTitleFont("AvenirNext-Regular")
        userAlert.setTextFont("AvenirNext-Regular")
        userAlert.setButtonFont("AvenirNext-Regular")
    }
    
    // POST: Delays any operation for 'delayTime' duration. Time is in seconds.
    static func delayFor(delayTime: Double, closure:()->())
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delayTime * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    static func isDeviceConnected()->Bool
    {
        if ConnectionVC.currentlySelectedDevice.state != .Connected
        {
            return false
        }
        return true
    }
    
    static func turnOffMetaWearLED()
    {
        ConnectionVC.currentlySelectedDevice.led?.setLEDOnAsync(false, withOptions: 1)
    }
    
    static func displayBackgroundImageOnError(currentView: UIView, typeOfError: ErrorState)
    {
        let errorImageView: UIImageView = UIImageView(frame: CGRect(x: currentView.frame.origin.x, y: currentView.frame.origin.y, width: currentView.frame.width, height: currentView.frame.height))
        errorImageView.backgroundColor = UIColor.whiteColor()
        errorImageView.center = CGPointMake(currentView.bounds.size.width/2, currentView.bounds.size.height/2)
        errorImageView.contentMode = .ScaleAspectFit
        
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
    
    static func eraseAllSwitchCommands()
    {
        if let deviceHasButtonPrograms = ConnectionVC.currentlySelectedDevice.mechanicalSwitch?.switchUpdateEvent.hasCommands()
        {
            print(deviceHasButtonPrograms)
            
            if deviceHasButtonPrograms
            {
                ConnectionVC.currentlySelectedDevice.mechanicalSwitch?.switchUpdateEvent.eraseCommandsToRunOnEventAsync()
            }
            print(ConnectionVC.currentlySelectedDevice.mechanicalSwitch?.switchUpdateEvent.hasCommands())
        }
    }
    
    static func repeatThis(task requiredTask: Selector, forDuration taskDuration: NSTimeInterval, onTarget taskTarget: AnyObject)
    {
        defaultTimer = NSTimer.scheduledTimerWithTimeInterval(taskDuration, target: taskTarget, selector: requiredTask, userInfo: nil, repeats: true)
    }
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

struct PhotoSensor
{    
    static func turn(state switchState: SwitchState)
    {
        if let metaWearGPIO = ConnectionVC.currentlySelectedDevice.gpio
        {
            let photoSensorPin = metaWearGPIO.pins[PinAssignments.pinOne] as! MBLGPIOPin
            
            switch switchState
            {
            case .On:
                photoSensorPin.setToDigitalValueAsync(true)
            case .Off:
                photoSensorPin.setToDigitalValueAsync(false)
            }
        }
    }
}

enum ErrorState
{
    case NoMetaWear
    case NoBLEConnection
}

enum SwitchState
{
    case On
    case Off
}

enum Sensor
{
    case Accelerometer
    case Magnetometer
    case Gyroscope
    case HeartRate
    case Null
}

enum SensorAxes
{
    case xAxis
    case yAxis
    case zAxis
    case RMS // root mean square => sqrt(1/n(sq(x1) + sq(x2) +.....+ sq(xn)))
}

enum LabelOption
{
    case totalSteps
    case totalCalories
    case totalDistance
}