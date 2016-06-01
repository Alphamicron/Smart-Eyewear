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
    @IBOutlet weak var userThresholdLabel: UILabel!
    @IBOutlet weak var metaWearLabel: UILabel!
    
    var photoSensorVoltage: Float = Float()
    
    override func viewDidLoad()
    {
        print("VDL called")
        super.viewDidLoad()
        
        initiateSliderValues()
        
        if !Constants.isDeviceConnected()
        {
            presentViewController(Constants.defaultErrorAlert("Device Error", errorMessage: "A device needs to be connected to change its LED colours"), animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        readVoltageFromPhotoSensor()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func turnOnOffBtnAction(sender: UIButton)
    {
        if sender.currentTitle == "Turn On"
        {
            // TODO: Diconnect connection from the photo sensor
            sender.setTitle("Turn Off", forState: .Normal)
        }
        else
        {
            // TODO: Initiate connection to the poto sensor
            sender.setTitle("Turn On", forState: .Normal)
        }
    }
    
    @IBAction func automaticBtnAction(sender: UIButton)
    {
        print("Automatic Mode Activated")
    }
    
    // POST: Keeps track of the user's threshold changes
    @IBAction func userThresholdChange(sender: UISlider)
    {
        print("Current value: \(sender.value)")
        userThresholdLabel.text = String(Int(sender.value))
    }
    
    // POST: Sets up the slider with default values upon a successful view load
    func initiateSliderValues()
    {
        metaWearValueSlider.minimumValue = Constants.userThresholdMinimumValue
        metaWearValueSlider.maximumValue = Constants.userThresholdMaximumValue
        userThresholdSlider.minimumValue = Constants.userThresholdMinimumValue
        userThresholdSlider.maximumValue = Constants.userThresholdMaximumValue
        
        metaWearValueSlider.setValue(readPhotoSensorValueInitially(), animated: true)
        // MARK: Consider initiating the slider to some default value instead of random generation?
        userThresholdSlider.setValue(Float(arc4random_uniform(UInt32(Constants.userThresholdMaximumValue))), animated: true)
        
        
        metaWearLabel.text = String(Int(metaWearValueSlider.value))
        userThresholdLabel.text = String(Int(userThresholdSlider.value))
    }
    
    // POST: Listens for any digital pin value changes, then reads the corrsponding analogue value
    func readVoltageFromPhotoSensor()
    {
        if let photoSensorGPIO = DevicesTVC.currentlySelectedDevice.gpio
        {
            let photoSensor: MBLGPIOPin = photoSensorGPIO.pins[Constants.PinAssignments.pinTwo] as! MBLGPIOPin
            // TODO: Probably just keep track of only falling pin values instead?
            photoSensor.changeType = .Any
            photoSensor.configuration = .Nopull
            photoSensor.changeEvent.startNotificationsWithHandlerAsync({ (digitalResult: AnyObject?, error: NSError?) in
                if error == nil
                {
                    let attainedValue = digitalResult as! MBLNumericData
                    print("Digital Value: \(attainedValue.value.floatValue)")
                    
                    photoSensor.analogAbsolute.readAsync().success({ (analogueResult: AnyObject) in
                        
                        let readValue = analogueResult as! MBLNumericData
                        //                        print(readValue.value.floatValue)
                        self.photoSensorVoltage = readValue.value.floatValue
                        print("Updated Value: \(self.photoSensorVoltage)")
                        self.reflectChangesToMetaWearSlider(self.convertValueToSliderScale(self.photoSensorVoltage))
                    })
                }
                else
                {
                    self.presentViewController(Constants.defaultErrorAlert("Value Change Error", errorMessage: (error?.localizedDescription)!), animated: true, completion: nil)
                }
            })
        }
    }
    
    func readPhotoSensorValueInitially() -> Float
    {
        var photoSensorVoltage: Float = Float()
        
        if let photoSensorGPIO = DevicesTVC.currentlySelectedDevice.gpio
        {
            let photoSensor: MBLGPIOPin = photoSensorGPIO.pins[Constants.PinAssignments.pinTwo] as! MBLGPIOPin
            
            photoSensor.analogAbsolute.readAsync().success({ (analogueResult: AnyObject) in
                
                let attainedValue = analogueResult as! MBLNumericData
                photoSensorVoltage = self.convertValueToSliderScale(attainedValue.value.floatValue)
                
            })
        }
        
        return photoSensorVoltage
    }
    
    // POST: Given a current voltage, converts it to the scale; Constants.userThresholdMinimumValue to Constants.userThresholdMaximumValue
    func convertValueToSliderScale(photoSensorVoltage: Float)-> Float
    {
        return (photoSensorVoltage / Constants.maximumPinVoltage) * Constants.userThresholdMaximumValue
    }
    
    func reflectChangesToMetaWearSlider(newMetaWearValue: Float)
    {
        metaWearValueSlider.setValue(newMetaWearValue, animated: true)
        metaWearLabel.text = String(Int(metaWearValueSlider.value))
    }
}
