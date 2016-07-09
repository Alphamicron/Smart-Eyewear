//
//  GraphsVC.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 6/22/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit
import Charts

class GraphsVC: UIViewController
{
    var totalNumberOfSteps: Int = Int()
    var desiredSensor: Sensor = Sensor.Null
    var timeStampsWithSeconds: [String] = [String]()
    var sensorTimeStamps: [String] = [String]()
    var numberOfSteps: [Int] = [Int]()
    static var sensorReadings: NSMutableArray = NSMutableArray()
    static var sensorReadingsTimeStamps: NSMutableArray = NSMutableArray()
    
    let BMM150Magnetometer: MBLMagnetometerBMM150 = ConnectionVC.currentlySelectedDevice.magnetometer as! MBLMagnetometerBMM150
    let BMM160Accelerometer: MBLAccelerometerBMI160 = ConnectionVC.currentlySelectedDevice.accelerometer as! MBLAccelerometerBMI160
    
    @IBOutlet weak var graphView: BarChartView!
    @IBOutlet weak var numberOfStepsLabel: UILabel!
    @IBOutlet weak var stepsTitleLabel: UILabel!
    @IBOutlet weak var numberOfCaloriesLabel: UILabel!
    @IBOutlet weak var caloriesTitleLabel: UILabel!
    
    var months: [String] = [String]()
    var unitsSold: [Double] = [Double]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        numberOfStepsLabel.text = String(Int())
        stepsTitleLabel.text = "steps"
        numberOfCaloriesLabel.text = String(Int())
        caloriesTitleLabel.text = "calorie"
        
        graphView.delegate = self
        
        graphView.noDataText = "No data to display"
        graphView.noDataTextDescription = "You need to workout for data to be displayed"
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        switch desiredSensor
        {
        case .Accelerometer:
            //            getAccelerometerReading()
            //            countNumberOfStepsInRealTime()
            //            startLoggingDataToController()
            downloadDataFromController()
        case .Gyroscope:
            getGyroscopeReading()
        case .Magnetometer:
            getMagnetometerReading()
        case .Null:
            print("An unexpected error has occured")
        }
        
        print("VWA called")
        print(desiredSensor)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        stopStreamingSensorInfo()
        GraphsVC.sensorReadings.removeAllObjects()
        GraphsVC.sensorReadingsTimeStamps.removeAllObjects()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func exitBtnAction(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getAccelerometerReading()
    {
        ConnectionVC.currentlySelectedDevice.accelerometer?.dataReadyEvent.startNotificationsWithHandlerAsync({ (result: AnyObject?, error: NSError?) in
            if error == nil
            {
                let accelData: MBLAccelerometerData = result as! MBLAccelerometerData
                GraphsVC.sensorReadings.addObject(accelData)
                print(accelData)
            }
            else
            {
                print("Error getting accelerometer data")
                print(error?.localizedDescription)
            }
        })
    }
    
    func getGyroscopeReading()
    {
        ConnectionVC.currentlySelectedDevice.gyro?.dataReadyEvent.startNotificationsWithHandlerAsync({ (result: AnyObject?, error: NSError?) in
            if error == nil
            {
                let gyroData: MBLGyroData = result as! MBLGyroData
                GraphsVC.sensorReadings.addObject(gyroData)
                print(gyroData)
            }
            else
            {
                print("Error getting gyroscope data")
                print(error?.localizedDescription)
            }
        })
    }
    
    func getMagnetometerReading()
    {
        BMM150Magnetometer.periodicMagneticField.startNotificationsWithHandlerAsync { (result: AnyObject?, error: NSError?) in
            if error == nil
            {
                let magnetoData: MBLMagnetometerData = result as! MBLMagnetometerData
                GraphsVC.sensorReadings.addObject(magnetoData)
                print(magnetoData)
            }
            else
            {
                print("Error getting magnetometer data")
                print(error?.localizedDescription)
            }
        }
    }
    
    func stopStreamingSensorInfo()
    {
        ConnectionVC.currentlySelectedDevice.accelerometer?.dataReadyEvent.stopNotificationsAsync()
        ConnectionVC.currentlySelectedDevice.gyro?.dataReadyEvent.stopNotificationsAsync()
        BMM150Magnetometer.periodicMagneticField.stopNotificationsAsync()
        BMM160Accelerometer.stepEvent.stopNotificationsAsync()
    }
    
    func setTotalStepsText()
    {
        self.numberOfStepsLabel.text = String(self.totalNumberOfSteps)
        
        if self.totalNumberOfSteps <= 1
        {
            self.stepsTitleLabel.text = "step"
        }
        else
        {
            self.stepsTitleLabel.text = "steps"
        }
    }
    
    func countNumberOfStepsInRealTime()
    {
        BMM160Accelerometer.stepEvent.startNotificationsWithHandlerAsync { (result: AnyObject?, error:NSError?) in
            if error == nil
            {
                print(result)
                let stepData: MBLNumericData = result as! MBLNumericData
                self.totalNumberOfSteps += Int(stepData.value)
                
                self.setTotalStepsText()
                
                GraphsVC.sensorReadings.addObject(self.totalNumberOfSteps)
                GraphsVC.sensorReadingsTimeStamps.addObject(self.getTimeStringFrom(stepData.description))
                
                print("steps data: \(stepData)")
            }
            else
            {
                print("Error getting footstep data")
                print(error?.localizedDescription)
            }
        }
    }
    
    // Given a string, extracts the time portion
    // PRE: String should be of format: "MMM DD, YYYY, HH:MM:SEC 1" e.g "Jul 7, 2016, 15:10:32 1"
    // POST: 15:10:32
    func getTimeStringFrom(sensorReadingsResult: String)-> String
    {
        let dateRange: Range = sensorReadingsResult.endIndex.advancedBy(-10)..<sensorReadingsResult.endIndex.advancedBy(-2)
        
        return sensorReadingsResult[dateRange]
    }
    
    func drawChart(dataPoints: [String], values: [Int])
    {
        // consists of the data points for the chart
        var dataEntries: [BarChartDataEntry] = [BarChartDataEntry]()
        
        // add the recorded values to the data entry array
        for i in 0..<dataPoints.count
        {
            let dataEntry = BarChartDataEntry(value: Double(values[i]), xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        // declare the y and x axis values respectively
        let chartDataSet: BarChartDataSet = BarChartDataSet(yVals: dataEntries, label: "number of steps")
        let chartData: BarChartData = BarChartData(xVals: sensorTimeStamps, dataSet: chartDataSet)
        graphView.data = chartData
        
        // chart GUI modifications
        let averageLine: ChartLimitLine = ChartLimitLine(limit: averageSteps(), label: "average steps")
        graphView.rightAxis.addLimitLine(averageLine)
        averageLine.lineColor = Constants.themeInactiveStateColour
        
        chartDataSet.colors = ChartColorTemplates.colorful()
        chartDataSet.barBorderColor = Constants.themeInactiveStateColour
        chartDataSet.barBorderWidth = 1.5
        
        graphView.descriptionText = String()
        graphView.xAxis.labelPosition = .Bottom
        graphView.animate(yAxisDuration: 2.0, easingOption: .EaseInOutBack)
    }
    
    func averageSteps()-> Double
    {
        return Double(totalNumberOfSteps)/Double(numberOfSteps.count)
    }
    
    func startLoggingDataToController()
    {
        BMM160Accelerometer.stepCounter.periodicReadWithPeriod(500).differentialSampleOfEvent(60000)
        BMM160Accelerometer.stepEvent.startLoggingAsync()
    }
    
    func downloadDataFromController()
    {        
        BMM160Accelerometer.stepEvent.downloadLogAndStopLoggingAsync(true)
        { (number: Float) in
            
            }.success { (result: AnyObject) in
                
                let loggedEntries: [MBLNumericData] = result as! [MBLNumericData]
                
                for thisLoggedEntry in loggedEntries
                {
                    self.timeStampsWithSeconds.append(self.getTimeStringFrom(thisLoggedEntry.description))
                    
                    print("************************************")
                    print(thisLoggedEntry)
                    print("************************************")
                }
                
                self.prepareDataForGraphing()
        }
    }
    
    func binarySearchForFirstOccurence(elements: [String], desiredElement: String)-> Int
    {
        var left: Int = 0, right: Int = elements.count - 1
        
        while left <= right
        {
            let middle: Int = (left + right)/2
            
            let middleElement: String = elements[middle]
            
            if left == right && middleElement.hasPrefix(desiredElement)
            {
                return left
            }
            
            if middleElement.hasPrefix(desiredElement)
            {
                if middle > 0
                {
                    if !elements[middle - 1].hasPrefix(desiredElement)
                    {
                        return middle
                    }
                }
                
                right = middle - 1
            }
            else if middleElement < desiredElement
            {
                left = middle + 1
            }
            else if middleElement > desiredElement
            {
                right = middle - 1
            }
        }
        
        return -1
    }
    
    func binarySearchForLastOccurence(elements: [String], desiredElement: String) -> Int
    {
        var left: Int = 0, right: Int = elements.count - 1
        
        while (left <= right)
        {
            let middle: Int = (left + right) / 2
            
            let middleElement: String = elements[middle]
            
            if left == right && middleElement.hasPrefix(desiredElement)
            {
                return left
            }
            
            if middleElement.hasPrefix(desiredElement)
            {
                if middle < elements.count - 1
                {
                    if !elements[middle + 1].hasPrefix(desiredElement)
                    {
                        return middle
                    }
                }
                
                left = middle + 1
            }
            else if (middleElement < desiredElement)
            {
                left = middle + 1
            }
            else if (middleElement > desiredElement)
            {
                right = middle - 1
            }
        }
        
        return -1
    }
    
    /*
     * Iterate through the time stamps and extract the seconds portion
     * Run two BFSs using this time stamp w/out secs in time stamp with secs to get the start and end location of this time stamp
     * The difference between start and end added by 1 gives you the total steps done in this minute
     * Update totalNumber of steps with number of steps done in a minute
     * Add the time w/out seconds along with the number of steps to their respective arrays to act as data source for the graph
     * Update count so as it skips the already discovered elements
     * Set the textLabel to reflect the total number of steps
     * Graph the data points
     * Complexity: O(nlogn)
     */
    func prepareDataForGraphing()
    {
        var count: Int = Int()
        
        // reset it back to zero to avoid conflicts with real time number of steps
        totalNumberOfSteps = 0
        
        while count < timeStampsWithSeconds.count
        {
            let thisTimeStamp = timeStampsWithSeconds[count]
            
            let timeWithoutSecondsRange: Range = thisTimeStamp.endIndex.advancedBy(-8)..<thisTimeStamp.endIndex.advancedBy(-3)
            
            // time will be of format "HH:MM"
            let timeWithoutSeconds: String = thisTimeStamp[timeWithoutSecondsRange]
            
            let firstIndex = binarySearchForFirstOccurence(timeStampsWithSeconds, desiredElement: timeWithoutSeconds)
            let lastIndex = binarySearchForLastOccurence(timeStampsWithSeconds, desiredElement: timeWithoutSeconds)
            
            let numberOfStepsForThisTimeStamp: Int = (lastIndex - firstIndex) + 1
            
            totalNumberOfSteps += numberOfStepsForThisTimeStamp
            
            sensorTimeStamps.append(timeWithoutSeconds)
            numberOfSteps.append(numberOfStepsForThisTimeStamp)
            
            count = lastIndex + 1
        }
        
        self.setTotalStepsText()
        
        // get rid of this array at this point
        timeStampsWithSeconds.removeAll(keepCapacity: false)
        
        drawChart(sensorTimeStamps, values: numberOfSteps)
    }
}

extension GraphsVC: ChartViewDelegate
{
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight)
    {
        print("value: \(entry.value) at \(sensorTimeStamps[entry.xIndex])")
    }
}