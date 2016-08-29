//
//  SpO2VC.swift
//  Uvex
//
//  Created by Alphamicron on 8/19/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit
import Charts

class SpO2VC: UIViewController
{
    @IBOutlet weak var spO2ValueLabel: UILabel!
    @IBOutlet weak var lungsImageView: UIImageView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    let arrayCapacity: Int = 10
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
    var heartRateTimeStamps: [String] = [String]()
    var heartRateReadings: [Double] = [Double]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lungsImageView.image = Lungs.imageOfSlice1(size: lungsImageView.bounds.size, resizing: Lungs.ResizingBehavior.AspectFit)
        
        var initial: Int = 0, last: Int = 100
        
        spO2ValueLabel.text = String(FitnessTVC.randomNumber(from: &initial, to: &last))
        
        heartRate = NSMutableArray(capacity: arrayCapacity)
        
        lineChartView.delegate = self
        
        // GUI stuff
        lineChartView.descriptionText = ""
        lineChartView.xAxis.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.userInteractionEnabled = false
        lineChartView.drawGridBackgroundEnabled = false
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        lineChartView.noDataText = "No data to display"
        lineChartView.noDataTextDescription = "Heart rate readings needed for data to be displayed."
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        Constants.repeatThis(task: #selector(getHeartRateData), forDuration: 0.05, onTarget: self)
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
    
    func getHeartRateData()
    {
        let heartRateSensorPin = ConnectionVC.currentlySelectedDevice.gpio?.pins[PinAssignments.pinZero]
        
        heartRateSensorPin?.analogRatio.readAsync().success({ (result: AnyObject) in
            
            let resultData: MBLNumericData = result as! MBLNumericData
            print(resultData.description)
            let signal: Float = resultData.value.floatValue * 512
            
            self.heartBeatCalculator(signal)
            
            self.heartRateReadings.append(resultData.value.doubleValue)
            self.heartRateTimeStamps.append(self.getTimeStringFrom(resultData.description, sensorType: Sensor.HeartRate))
            
            self.drawChartData(xAxisValues: &self.heartRateTimeStamps, yAxisValues: &self.heartRateReadings)
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
    
    func drawChartData(inout xAxisValues dataPoints: [String], inout yAxisValues values: [Double])
    {
        // creating an array of data entries
        var dataEntries : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0..<dataPoints.count
        {
            dataEntries.append(ChartDataEntry(value: values[i], xIndex: i))
        }
        
        var dataSet: LineChartDataSet = LineChartDataSet()
        
        // executed if we are simply adding data in real time
        if lineChartView.data?.dataSetCount > 0
        {
            dataSet = lineChartView.data?.dataSets[0] as! LineChartDataSet
            dataSet.yVals = dataEntries
            lineChartView.data?.xValsObjc = dataPoints
            lineChartView.data?.notifyDataChanged()
            lineChartView.notifyDataSetChanged()
        }
        else // creating an entirely new graph
        {
            // create a data set with our array
            dataSet = LineChartDataSet(yVals: dataEntries, label: "heart rate")
            dataSet.axisDependency = .Left // line will correlate with left axis values
            dataSet.setColor(Constants.themeRedColour) // set colour
            dataSet.lineWidth = 3.0
            dataSet.fillAlpha = 65 / 255.0
            dataSet.fillColor = Constants.themeRedColour
            dataSet.highlightColor = Constants.themeGreyColour
            dataSet.mode = .CubicBezier // give it the cubic function graph style
            dataSet.drawValuesEnabled = false
            dataSet.drawCirclesEnabled = false
            dataSet.valueFont = Constants.defaultNormalFont.fontWithSize(8)
            
            var dataSets : [LineChartDataSet] = [LineChartDataSet]()
            dataSets.append(dataSet)
            
            // pass our dataPoints in for our x-axis label value along with our dataSets
            let data: LineChartData = LineChartData(xVals: dataPoints, dataSets: dataSets)
            data.setValueTextColor(UIColor(red: 0.925, green: 0.494, blue: 0.114, alpha: 1.00))
            
            
            //            lineChartView.xAxis.labelPosition = .Bottom
            //            lineChartView.animate(xAxisDuration: 3.0)
            
            self.lineChartView.data = data
        }
    }
    
    /*  Given a string, extracts the time portion
     *  Complexity: O(n)
     *  If sensorType == Accelerometer
     *      PRE:  String format is "MMM DD, YYYY, HH:MM:SEC 1" e.g "Jul 7, 2016, 15:10:32 1"
     *      POST: 15:10:32
     *  Else if sensorType == HeartRate
     *      PRE:  String format is "MMM DD, YYYY, HH:MM:SEC Float" e.g "Jul 22, 2016, 15:57:26 0.424242.."
     *      POST: 15:57:26
     */
    func getTimeStringFrom(sensorReadingsResult: String, sensorType: Sensor)-> String
    {
        var timeRange: Any?
        
        switch sensorType
        {
        case .Accelerometer:
            timeRange = sensorReadingsResult.endIndex.advancedBy(-10)..<sensorReadingsResult.endIndex.advancedBy(-2)
        case .HeartRate:
            timeRange = sensorReadingsResult.startIndex.advancedBy(14)..<sensorReadingsResult.startIndex.advancedBy(22)
        default:
            break
        }
        
        return sensorReadingsResult[timeRange as! Range]
    }
}

extension SpO2VC: ChartViewDelegate
{
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight)
    {
        print("value: \(entry.value) at \(heartRateTimeStamps[entry.xIndex])")
    }
}