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
    @IBOutlet weak var setBtn: UIButton!
    @IBOutlet weak var activateBtn: UIButton!
    @IBOutlet weak var userThresholdSlider: UISlider!
    @IBOutlet weak var metaWearValueSlider: UISlider!
    
    static var automaticModeOn: Bool = Bool()
    static var currentValueSetByUser: Float = Float()
    
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
            checkIfPhotoSensorIsOn()
            Constants.repeatThis(task: #selector(readPhotoSensorValue), forDuration: Constants.defaultDelayTime, onTarget: self)
        }
    }
    
    //    override func viewWillAppear(animated: Bool)
    //    {
    //        super.viewWillAppear(animated)
    //        
    //        checkIfPhotoSensorIsOn()
    //    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // POST: Keeps track of the user's threshold changes
    @IBAction func userThresholdChanged(sender: UISlider)
    {
        AutomaticVC.currentValueSetByUser = sender.value
        
        print("user's value when slid: \(AutomaticVC.currentValueSetByUser)")
        
        //        if sender.value < metaWearValueSlider.value
        //        {
        //            PhotoSensor.turn(state: SwitchState.On)
        //        }
        //        else
        //        {
        //            PhotoSensor.turn(state: SwitchState.Off)
        //        }
    }
    
    @IBAction func activateBtnAction(sender: UIButton)
    {
        sender.selected = !sender.selected
        
        if sender.selected
        {
            print("auto is ON")
            
            setBtn.hidden = false
            sender.setTitle("OFF", forState: .Normal)
            userThresholdSlider.userInteractionEnabled = true
        }
        else
        {
            print("auto is OFF")
            
            setBtn.hidden = true
            Constants.defaultTimer.invalidate()
            
            PhotoSensor.turn(state: SwitchState.Off)
            AutomaticVC.automaticModeOn = false
            
            sender.setTitle("ON", forState: .Normal)
            userThresholdSlider.userInteractionEnabled = false
        }
    }
    
    @IBAction func setBtnAction(sender: UIButton)
    {
        print("set button tapped")
        
        if userThresholdSlider.value < metaWearValueSlider.value
        {
            PhotoSensor.turn(state: SwitchState.On)
            AutomaticVC.automaticModeOn = true
        }
        else
        {
            PhotoSensor.turn(state: SwitchState.Off)
            AutomaticVC.automaticModeOn = false
        }
    }
    
    // POST: Keeps track of the photo sensor's threshold changes
    func metawearThresholdChanged(sender: UISlider)
    {
        //        if sender.value > userThresholdSlider.value
        //        {
        //            PhotoSensor.turn(state: SwitchState.On)
        //        }
        //        else
        //        {
        //            PhotoSensor.turn(state: SwitchState.Off)
        //        }
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
                self.metaWearValueSlider.setValue(photoSensorVoltage, animated: true)
            })
        }
    }
    
    // POST: Given a current voltage, converts it to the scale; Constants.userThresholdMinimumValue to Constants.userThresholdMaximumValue
    func convertValueToSliderScale(photoSensorVoltage: Float)-> Float
    {
        return (photoSensorVoltage / Constants.maximumPinVoltage) * Constants.userThresholdMaximumValue
    }
    
    func checkIfPhotoSensorIsOn()
    {        
        if let metaWearGPIO = ConnectionVC.currentlySelectedDevice.gpio
        {
            let photoSensorPin = metaWearGPIO.pins[PinAssignments.pinOne] as! MBLGPIOPin
            
            photoSensorPin.digitalValue.readAsync().success({ (result: AnyObject) in
                
                let sensorResult: MBLNumericData = result as! MBLNumericData
                let isSwitchOn: Bool = sensorResult.value.boolValue
                
                print("Photo sensor result \(sensorResult.value.boolValue)")
                
                if isSwitchOn
                {
                    self.setupView(forState: SwitchState.On)
                }
                else
                {
                    self.setupView(forState: SwitchState.Off)
                }
            })
        }
    }
    
    func setupView(forState currentState: SwitchState)
    {
        switch currentState
        {
        case .On:
            setBtn.hidden = false
            AutomaticVC.automaticModeOn = true
            activateBtn.setTitle("OFF", forState: .Normal)
            userThresholdSlider.userInteractionEnabled = true
            userThresholdSlider.value = AutomaticVC.currentValueSetByUser
            print("user's value when setting up the view: \(AutomaticVC.currentValueSetByUser)")
            
        case .Off:
            setBtn.hidden = true
            AutomaticVC.automaticModeOn = false
            activateBtn.setTitle("ON", forState: .Normal)
            userThresholdSlider.userInteractionEnabled = false
            userThresholdSlider.value = AutomaticVC.currentValueSetByUser
            print("user's value when setting up the view: \(AutomaticVC.currentValueSetByUser)")
        }
    }
    
    func dealWithManualMode()
    {        
        PhotoSensor.turn(state: SwitchState.Off)
        ManualVC.manualModeOn = false
        
        setupView(forState: SwitchState.Off)
    }
    
    func exitView()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
}