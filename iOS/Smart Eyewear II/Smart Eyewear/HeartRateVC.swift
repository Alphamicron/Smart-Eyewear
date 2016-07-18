//
//  HeartRateVC.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 7/18/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class HeartRateVC: UIViewController
{
    var entryText: String = String()
    var globalHeartRate: Double = Double()
    
    @IBOutlet weak var entryLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        entryLabel.text = entryText
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        repeatThisTaskEvery(#selector(HeartRateVC.getHeartRateData), taskDuration: Constants.defaultDelayTime)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func exitBtnAction(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getHeartRateData()
    {
        let heartRateSensorPin = ConnectionVC.currentlySelectedDevice.gpio?.pins[PinAssignments.pinZero]
        
        heartRateSensorPin!.analogAbsolute.readAsync().success({ (result: AnyObject) in
            let analogValue: MBLNumericData = result as! MBLNumericData
            let heartRate: Double = self.map(analogValue.value.doubleValue, inMinValue: 0, inMaxValue: 3, outMinValue: 0, outMaxValue: 100)
            
            if heartRate != self.globalHeartRate
            {
                self.globalHeartRate = heartRate
            }
            
            self.entryLabel.text = "\(Int(self.globalHeartRate)) bpm"
        })
    }
    
    func repeatThisTaskEvery(requiredTask: Selector, taskDuration: NSTimeInterval)
    {
        Constants.defaultTimer = NSTimer.scheduledTimerWithTimeInterval(taskDuration, target: self, selector: requiredTask, userInfo: nil, repeats: true)
    }
    
    func map(value: Double, inMinValue: Double, inMaxValue: Double, outMinValue: Double, outMaxValue: Double)-> Double
    {
        return (value - inMinValue) * (outMaxValue - outMinValue) / (inMaxValue - inMinValue) + outMinValue
    }
}
