//
//  AutomaticVC.swift
//  Uvex
//
//  Created by Alphamicron on 8/12/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit
import JSSAlertView

class AutomaticVC: UIViewController
{
    @IBOutlet weak var userThresholdSlider: UISlider!
    @IBOutlet weak var metaWearValueSlider: UISlider!
    
    static var automaticModeOn: Bool = Bool()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if ManualVC.manualModeOn
        {
            let userAlert = JSSAlertView().show(
                self,
                title: "Confirm",
                text: "Manual mode is still active. Do you wish to deactivate it?",
                buttonText: "Yep",
                cancelButtonText: "Nope"
            )
            
            userAlert.setTitleFont("AvenirNext-Regular")
            userAlert.setTextFont("AvenirNext-Regular")
            userAlert.setButtonFont("AvenirNext-Regular")
            userAlert.addAction(dealWithManualMode)
            userAlert.addCancelAction(exitView)
        }
        else
        {
            Constants.repeatThis(task: #selector(readPhotoSensorValue), forDuration: Constants.defaultDelayTime, onTarget: self)
        }
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        print(checkIfPhotoSensorIsOn())
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // POST: Keeps track of the user's threshold changes
    @IBAction func userThresholdChanged(sender: UISlider)
    {
        print("user slid")
        
        if sender.value < metaWearValueSlider.value
        {
            PhotoSensor.turn(state: SwitchState.On)
        }
        else
        {
            PhotoSensor.turn(state: SwitchState.Off)
        }
    }
    
    @IBAction func setBtnAction(sender: UIButton)
    {
        print("set button tapped")
    }
    
    // POST: Keeps track of the photo sensor's threshold changes
    func metawearThresholdChanged(sender: UISlider)
    {
        if sender.value > userThresholdSlider.value
        {
            PhotoSensor.turn(state: SwitchState.On)
        }
        else
        {
            PhotoSensor.turn(state: SwitchState.Off)
        }
    }
    
    // POST: Get voltage of photo sensor pin and reflects it onto the metaWearSlider
    func readPhotoSensorValue()
    {
        var photoSensorVoltage: Float = Float()
        
        if let photoSensorGPIO = ConnectionVC.currentlySelectedDevice.gpio
        {
            let photoSensor: MBLGPIOPin = photoSensorGPIO.pins[PinAssignments.pinTwo] as! MBLGPIOPin
            
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
    
    func checkIfPhotoSensorIsOn()
    {        
        if let metaWearGPIO = ConnectionVC.currentlySelectedDevice.gpio
        {
            let photoSensorPin = metaWearGPIO.pins[PinAssignments.pinOne] as! MBLGPIOPin
            
            photoSensorPin.digitalValue.readAsync().success({ (result: AnyObject) in
                
                let sensorResult: MBLNumericData = result as! MBLNumericData
                
                print("Photo sensor result \(sensorResult.value.boolValue)")
            })
        }
    }
    
    func dealWithManualMode()
    {
        print("user entered auto mode")
        
        PhotoSensor.turn(state: SwitchState.Off)
        ManualVC.manualModeOn = false
    }
    
    func exitView()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
}