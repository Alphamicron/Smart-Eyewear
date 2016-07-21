//
//  Constants.swift
//  Smart Eyewear
//
//  Created by Emil Shirima on 5/24/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

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
    static let deviceFullChargeValue: NSNumber = 100
    static let defaultTimeOut: NSTimeInterval = 15 // max waiting time for a device to be connected
    static let defaultDelayTime: NSTimeInterval = 1.0
    static let defaultLEDIntensity: CGFloat = 1.0
    static var defaultTimer: NSTimer = NSTimer()
    static let userThresholdMinimumValue: Float = Float() // min value for a valid photo sensor threshold
    static let userThresholdMaximumValue: Float = 1024 // max value for a valid photo sensor threshold
    static let maximumPinVoltage: Float = 3.0 // maximum voltage supplied by Pin 6 as of https://mbientlab.com/docs/MetaWearCPSv0.5.pdf
    static let defaultFont: UIFont = UIFont(name: "AvenirNext-Regular", size: 20)!
    static let themeRedColour: UIColor = UIColor(red: 0.925, green: 0.114, blue: 0.141, alpha: 1.00)
    static let themeGreenColour: UIColor = UIColor(red: 0.290, green: 0.839, blue: 0.388, alpha: 1.00)
    static let themeYellowColour: UIColor = UIColor(red: 0.941, green: 0.843, blue: 0.020, alpha: 1.00)
    static let themeInactiveStateColour: UIColor = UIColor(red: 0.208, green: 0.169, blue: 0.137, alpha: 1.00)
    static let themeTextColour: UIColor = UIColor(red: 0.502, green: 0.506, blue: 0.518, alpha: 1.00)
    static let metaWearName: String = "MetaWear"
    
    static func defaultErrorAlert(origin: UIViewController, errorTitle: String, errorMessage: String, errorPriority: AlertPriority)
    {
        
        switch errorPriority
        {
        case .High:
            
            let userAlert = JSSAlertView().show(origin, title: errorTitle, text: errorMessage, buttonText: "dismiss", color: Constants.themeRedColour, iconImage: UIImage(named: "AlertEagle"))
            
            userAlert.setTextTheme(.Light)
            userAlert.setTitleFont("AvenirNext-Regular")
            userAlert.setTextFont("AvenirNext-Regular")
            userAlert.setButtonFont("AvenirNext-Regular")
            
        case .Medium:
            
            let userAlert = JSSAlertView().show(origin, title: errorTitle, text: errorMessage, buttonText: "okay", color: Constants.themeYellowColour, iconImage: UIImage(named: "AlertEagleYellow"))
            
            userAlert.setTextTheme(.Dark)
            userAlert.setTitleFont("AvenirNext-Regular")
            userAlert.setTextFont("AvenirNext-Regular")
            userAlert.setButtonFont("AvenirNext-Regular")
            
        case .Low:
            
            let userAlert = JSSAlertView().show(origin, title: errorTitle, text: errorMessage, buttonText: "okay", color: Constants.themeGreenColour, iconImage: UIImage(named: "AlertEagleGreen"))
            
            userAlert.setTextTheme(.Light)
            userAlert.setTitleFont("AvenirNext-Regular")
            userAlert.setTextFont("AvenirNext-Regular")
            userAlert.setButtonFont("AvenirNext-Regular")
        }
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
    
    static func disconnectDevice()
    {
        ConnectionVC.currentlySelectedDevice.disconnectWithHandler(nil)
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

struct GraphPoints
{
    var xAxes: [Double] = [Double]()
    var yAxes: [Double] = [Double]()
    var zAxes: [Double] = [Double]()
    var rmsValues: [Double] = [Double]()
}

enum AlertPriority
{
    case Low
    case Medium
    case High
}

enum ErrorState
{
    case NoMetaWear
    case NoBLEConnection
}

enum LEDState
{
    case On
    case Off
}

enum Sensor
{
    case Accelerometer
    case Magnetometer
    case Gyroscope
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