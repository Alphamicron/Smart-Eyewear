//
//  ManualVC.swift
//  Uvex
//
//  Created by Alphamicron on 8/12/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit

class ManualVC: UIViewController
{
    @IBOutlet weak var switchImageView: UIImageView!
    @IBOutlet weak var switchStateLabel: UILabel!
    
    var isPhotoSensorOn: Bool = Bool()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func userTappedSwitch(sender: UITapGestureRecognizer)
    {
        if isPhotoSensorOn
        {
            ManualVC.turnPhotoSensor(SwitchState.Off)
            setupUI(forState: SwitchState.Off)
            isPhotoSensorOn = false
        }
        else
        {
            ManualVC.turnPhotoSensor(SwitchState.On)
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
    
    static func turnPhotoSensor(switchState: SwitchState)
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
}