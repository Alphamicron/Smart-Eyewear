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
    var totalNumberOfCalories: Int = Int()
    var desiredSensor: Sensor = Sensor.Null
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
        
        graphView.noDataText = "no chart data available"
        graphView.noDataTextDescription = "you need to workout for data to be displayed"
        
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        unitsSold = [25.2, 4.0, 6.0, 10.5, 12.0, 16.0, 4.20, 18.6, 2.19, 4.0, 5.0, 4.0,]
        
        setChart(months, values: unitsSold)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        switch desiredSensor
        {
        case .Accelerometer:
            //            getAccelerometerReading()
            countNumberOfSteps()
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
    
    func countNumberOfSteps()
    {
        BMM160Accelerometer.stepEvent.startNotificationsWithHandlerAsync { (result: AnyObject?, error:NSError?) in
            if error == nil
            {
                let stepData: MBLNumericData = result as! MBLNumericData
                self.totalNumberOfSteps += Int(stepData.value)
                
                self.numberOfStepsLabel.text = String(self.totalNumberOfSteps)
                
                if self.totalNumberOfSteps <= 1
                {
                    self.stepsTitleLabel.text = "step"
                }
                else
                {
                    self.stepsTitleLabel.text = "steps"
                }
                
                
                GraphsVC.sensorReadings.addObject(self.totalNumberOfSteps)
                GraphsVC.sensorReadingsTimeStamps.addObject(self.getDateStringFrom(stepData.description))
                
                print("Sensor size: \(GraphsVC.sensorReadings.count)")
                print("Timestamp size: \(GraphsVC.sensorReadingsTimeStamps.count)")
            }
            else
            {
                print("Error getting footstep data")
                print(error?.localizedDescription)
            }
        }
    }
    
    func getDateStringFrom(sensorReadingsResult: String)-> String
    {
        return String(sensorReadingsResult.characters.dropLast())
    }
    
    func setChart(dataPoints: [String], values: [Double])
    {
        var dataEntries: [BarChartDataEntry] = [BarChartDataEntry]()
        
        for i in 0..<dataPoints.count
        {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet: BarChartDataSet = BarChartDataSet(yVals: dataEntries, label: "units sold")
        let chartData: BarChartData = BarChartData(xVals: months, dataSet: chartDataSet)
        graphView.data = chartData
        
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
        var sumOfElements: Double = Double()
        
        for thisStep in unitsSold
        {
            sumOfElements += thisStep
        }
        
        return sumOfElements/Double(unitsSold.count)
    }
    
    func stopStreamingSensorInfo()
    {
        ConnectionVC.currentlySelectedDevice.accelerometer?.dataReadyEvent.stopNotificationsAsync()
        ConnectionVC.currentlySelectedDevice.gyro?.dataReadyEvent.stopNotificationsAsync()
        BMM150Magnetometer.periodicMagneticField.stopNotificationsAsync()
        BMM160Accelerometer.stepEvent.stopNotificationsAsync()
    }
}

extension GraphsVC: ChartViewDelegate
{
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight)
    {
        print("value: \(entry.value) in \(months[dataSetIndex])")
        print("value: \(entry.value) in \(months[entry.xIndex])")
    }
}