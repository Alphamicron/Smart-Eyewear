//
//  HeartRateVC.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 7/18/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

/*
 References:
 https://github.com/WorldFamousElectronics/PulseSensor_Amped_Arduino
 http://projects.mbientlab.com/heart-rate-data-with-the-pulse-sensor-and-metawear/
 */


class HeartRateVC: UIViewController
{
    var entryText: String = String()
    var lastBeatTime: Int = Int() // used to find Inter-beat Interval (IBI)
    var sampleCounter: Int = Int() // used to determine pulse timing
    var threshold: Float = 256 // used to find instant moment of heart beat, seeded
    var interBeatInterval: Int = 1 // time interval between individual beats
    var waveCrest: Float = 256
    var waveTrough: Float = 256
    var waveAmplitude: Float = 100
    var beatsPerMinute: Float = 60
    var pulse: Bool = Bool() // true if live heartbeat detected, false otherwise
    var firstBeat: Bool = true // used to seed rate array so we startup with reasonable BPM
    var secondBeat: Bool = Bool() // used to seed rate array so we startup with reasonable BPM
    var heartRate: NSMutableArray = NSMutableArray()
    let arrayCapacity: Int = 10
    
    @IBOutlet weak var entryLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        entryLabel.text = entryText
        heartRate = NSMutableArray(capacity: arrayCapacity)
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        Constants.repeatThis(task: #selector(HeartRateVC.getHeartRateData), forDuration: 0.05, onTarget: self)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        Constants.defaultTimer.invalidate()
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
        
        heartRateSensorPin?.analogRatio.readAsync().success({ (result: AnyObject) in
            
            let resultData: MBLNumericData = result as! MBLNumericData
            let signal: Float = resultData.value.floatValue * 512
            
            self.heartBeatCalculator(signal)
            
            self.entryLabel.text = String(self.beatsPerMinute)
        })
    }
    
    func heartBeatCalculator(signal: Float)
    {
        self.sampleCounter += 50 // keeps track of the time in milliseconds
        
        let timeSinceLastBeat = self.sampleCounter - self.lastBeatTime // to avoid noise
        
        // find the crest and trough of the wave
        if signal < self.threshold && timeSinceLastBeat > ((self.interBeatInterval/5)*3)
        {
            if signal < self.waveTrough
            {
                self.waveTrough = signal // lowest point in pulse wave
            }
        }
        
        if signal > self.threshold && signal > self.waveCrest // helps in noise avoidance
        {
            self.waveCrest = signal // highest point in pulse wave
        }
        
        // Looking for an actual heart beat
        // Signal surges up in value every time there is a pulse
        if timeSinceLastBeat > 250 // avoids high frequency noise
        {
            if signal > self.threshold && self.pulse == false && timeSinceLastBeat > ((self.interBeatInterval/5)*3)
            {
                self.pulse = true
                
                self.interBeatInterval = self.sampleCounter - self.lastBeatTime
                self.lastBeatTime = self.sampleCounter
                
                if self.secondBeat
                {
                    self.secondBeat = false
                    
                    // seed the running total to get a realisitic BPM at startup
                    for i in 0...arrayCapacity - 1
                    {
                        self.heartRate.insertObject(self.interBeatInterval, atIndex: i)
                    }
                }
                
                if self.firstBeat
                {
                    self.firstBeat = false
                    self.secondBeat = true
                    return // discard IBI value because its unreliable
                }
                
                var runningTotal: Int = Int()
                
                for i in 0...arrayCapacity - 2 // shift data in the array
                {
                    self.heartRate.replaceObjectAtIndex(i, withObject: self.heartRate[i + 1])
                    runningTotal += self.heartRate[i].integerValue
                }
                
                self.heartRate.removeObjectAtIndex(arrayCapacity - 1)
                self.heartRate.insertObject(self.interBeatInterval, atIndex: arrayCapacity - 1)
                
                runningTotal += self.heartRate.objectAtIndex(arrayCapacity - 1).integerValue
                runningTotal /= arrayCapacity // mean of IBI values
                
                self.beatsPerMinute = Float(60000/runningTotal)
            }
        }
        
        // When the values are going down, the beat is over
        if signal < self.threshold && self.pulse == true
        {
            self.pulse = false
            self.waveAmplitude = self.waveCrest - self.waveTrough
            self.threshold = (self.waveAmplitude/2) + self.waveTrough // threshold = 50% of amplitude
            // reset values
            self.waveCrest = self.threshold
            self.waveTrough = self.threshold
        }
        
        // If 2.5 seconds go by without a beat -> reset
        if timeSinceLastBeat > 2500
        {
            self.threshold = 250
            self.waveCrest = self.threshold
            self.waveTrough = self.threshold
            self.lastBeatTime = self.sampleCounter
            self.firstBeat = true
            self.secondBeat = Bool()
        }
    }
}
