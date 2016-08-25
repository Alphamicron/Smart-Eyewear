//
//  ManualVC.swift
//  Uvex
//
//  Created by Alphamicron on 8/12/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit
import JSSAlertView

class ManualVC: UIViewController
{
    @IBOutlet weak var switchImageView: UIImageView!
    @IBOutlet weak var switchStateLabel: UILabel!
    
    var isPhotoSensorOn: Bool = Bool()
    static var manualModeOn: Bool = Bool()
    
    //TODO: Account for the scenario when the user comes from Auto mode
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if AutomaticVC.automaticModeOn
        {
            let userAlert = JSSAlertView().show(
                self,
                title: "Confirm",
                text: "Automatic mode is still active. Do you wish to deactivate it?",
                buttonText: "Yep",
                cancelButtonText: "Nope"
            )
            
            userAlert.setTitleFont("AvenirNext-Regular")
            userAlert.setTextFont("AvenirNext-Regular")
            userAlert.setButtonFont("AvenirNext-Regular")
            userAlert.addAction(dealWithAutomaticMode)
            userAlert.addCancelAction(exitView)
        }
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userTappedSwitch))
        switchImageView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(animated: Bool)
    {        
        checkIfPhotoSensorIsOn()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if isPhotoSensorOn
        {
            setupUI(forState: SwitchState.On)
        }
        else
        {
            setupUI(forState: SwitchState.Off)
        }
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        if isPhotoSensorOn
        {
            ManualVC.manualModeOn = true
        }
        else
        {
            ManualVC.manualModeOn = false
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func userTappedSwitch(sender: UITapGestureRecognizer)
    {
        if isPhotoSensorOn
        {
            PhotoSensor.turn(state: SwitchState.Off)
            setupUI(forState: SwitchState.Off)
            isPhotoSensorOn = false
        }
        else
        {
            PhotoSensor.turn(state: SwitchState.On)
            setupUI(forState: SwitchState.On)
            isPhotoSensorOn = true
        }
    }
    
    func checkIfPhotoSensorIsOn()
    {
        if let metaWearGPIO = ConnectionVC.currentlySelectedDevice.gpio
        {
            let photoSensorPin = metaWearGPIO.pins[PinAssignments.pinOne] as! MBLGPIOPin
            
            photoSensorPin.digitalValue.readAsync().success({ (result: AnyObject) in
                
                let sensorResult: MBLNumericData = result as! MBLNumericData
                
                self.isPhotoSensorOn = sensorResult.value.boolValue
                
                print(sensorResult.value.boolValue)
            })
        }
    }
    
    func setupUI(forState switchState: SwitchState)
    {
        switch switchState
        {
        case .On:
            self.switchStateLabel.text = "ON"
            self.switchImageView.image = UIImage(named: "ButtonRed")
            self.switchStateLabel.textColor = Constants.themeRedColour
            
        case .Off:
            self.switchStateLabel.text = "OFF"
            self.switchImageView.image = UIImage(named: "ButtonGrey")
            self.switchStateLabel.textColor = Constants.themeGreyColour
        }
    }
    
    func dealWithAutomaticMode()
    {        
        Constants.defaultTimer.invalidate()
        PhotoSensor.turn(state: SwitchState.Off)
        AutomaticVC.automaticModeOn = false
    }
    
    func exitView()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
}