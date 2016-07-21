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
    var peak: Float = 256 // used to find peak in pulse wave, seeded
    var trough: Float = 256 // used to find trough in pulse wave, seeded
    var BPM: Float = 60
    var amplitude: Float = 100 // used to hold amplitude of pulse waveform, seeded
    var pulse: Bool = Bool() // true if live heartbeat detected, false otherwise
    var firstBeat: Bool = true // used to seed rate array so we startup with reasonable BPM
    var secondBeat: Bool = Bool() // used to seed rate array so we startup with reasonable BPM
    var heartRate: NSMutableArray = NSMutableArray(capacity: 10)
    
    @IBOutlet weak var entryLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        entryLabel.text = entryText
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        repeatThisTaskEvery(#selector(HeartRateVC.getHeartRateData), taskDuration: 0.05)
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
            
            print("signal: \(signal)")
            
            self.sampleCounter += 50 // keeps track of the time in milliseconds
            
            let timeSinceLastBeat = self.sampleCounter - self.lastBeatTime // to avoid noise
            print("time interval: \(timeSinceLastBeat)")
            
            // find the peak and trough of the wave
            if signal < self.threshold && timeSinceLastBeat > ((self.interBeatInterval/5)*3)
            {
                if signal < self.trough
                {
                    self.trough = signal // lowest point in pulse wave
                    
                    print("trough: \(self.trough)")
                }
            }
            
            if signal > self.threshold && signal > self.peak // helps in noise avoidance
            {
                self.peak = signal // highest point in pulse wave
                print("peak: \(self.peak)")
            }
            
            // Looking for an actual heart beat
            // Signal surges up in value every time there is a pulse
            if timeSinceLastBeat > 250 // avoids high frequency noise
            {
                if signal > self.threshold && self.pulse == false && timeSinceLastBeat > ((self.interBeatInterval/5)*3)
                {
                    self.pulse = true
                    
                    self.interBeatInterval = self.sampleCounter - self.lastBeatTime
                    print("IBI: \(self.interBeatInterval)")
                    self.lastBeatTime = self.sampleCounter
                    
                    if self.secondBeat
                    {
                        print("second beat")
                        self.secondBeat = false
                        
                        // seed the running total to get a realisitic BPM at startup
                        for i in 0...9
                        {
                            self.heartRate.insertObject(self.interBeatInterval, atIndex: i)
                        }
                    }
                    
                    if self.firstBeat
                    {
                        print("first beat")
                        self.firstBeat = false
                        self.secondBeat = true
                        return // discard IBI value because its unreliable
                    }
                    
                    var runningTotal: Int = Int()
                    
                    for i in 0...8 // shift data in the array
                    {
                        self.heartRate.replaceObjectAtIndex(i, withObject: self.heartRate[i + 1])
                        
                        runningTotal += self.heartRate[i].integerValue
                        
                        print("count \(i) from added \(self.heartRate[i + 1])")
                    }
                    
                    self.heartRate.removeObjectAtIndex(9)
                    self.heartRate.insertObject(self.interBeatInterval, atIndex: 9)
                    print("count 9 from added \(self.heartRate[9])")
                    
                    runningTotal += self.heartRate.objectAtIndex(9).integerValue
                    print("running total: \(runningTotal)")
                    
                    runningTotal /= 10 // mean of IBI values
                    print("running average: \(runningTotal)")
                    
                    self.BPM = Float(60000/runningTotal)
                    print("BPM: \(self.BPM)")
                    
                }
            }
            
            // When the values are going down, the beat is over
            if signal < self.threshold && self.pulse == true
            {
                self.pulse = false
                self.amplitude = self.peak - self.trough
                self.threshold = (self.amplitude/2) + self.trough // threshold = 50% of amplitude
                // reset values
                self.peak = self.threshold
                self.trough = self.threshold
            }
            
            // If 2.5 seconds go by without a beat -> reset
            if timeSinceLastBeat > 2500
            {
                self.threshold = 250
                self.peak = self.threshold
                self.trough = self.threshold
                self.lastBeatTime = self.sampleCounter
                self.firstBeat = true
                self.secondBeat = Bool()
            }
            
            self.entryLabel.text = String(self.BPM)
        })
    }
    
    func heartBeat(analogSignal: Float)-> Float
    {
        
        
        return Float()
    }
    
    func repeatThisTaskEvery(requiredTask: Selector, taskDuration: NSTimeInterval)
    {
        Constants.defaultTimer = NSTimer.scheduledTimerWithTimeInterval(taskDuration, target: self, selector: requiredTask, userInfo: nil, repeats: true)
    }
}
