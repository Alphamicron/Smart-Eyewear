//
//  GraphsVC.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 6/22/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class GraphsVC: UIViewController
{
    var desiredSensor: Sensor = Sensor.Null
    let BMM150Magnetometer: MBLMagnetometerBMM150 = ConnectionVC.currentlySelectedDevice.magnetometer as! MBLMagnetometerBMM150
    
    var dataEntries: [BarChartDataEntry] = [BarChartDataEntry]()
    static var sensorReadings: NSMutableArray = NSMutableArray()
    
    @IBOutlet var chartView: LineChartView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        chartView.delegate = self
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false // TODO: Change to true
        chartView.drawGridBackgroundEnabled = false
        
        chartView.leftAxis.labelFont = Constants.defaultFont // TODO: Decrease the font to 10pts?
        chartView.leftAxis.granularityEnabled = true
        chartView.leftAxis.granularity = 0.1
        
        chartView.rightAxis.labelFont = Constants.defaultFont // TODO: Decrease the font to 10pts?
        chartView.rightAxis.granularityEnabled = true
        chartView.rightAxis.granularity = 0.1
        
        chartView.legend.position = .BelowChartLeft
        chartView.legend.form = .Line
        chartView.legend.font = Constants.defaultFont
        chartView.legend.xEntrySpace = 4.0
        
        chartView.animate(xAxisDuration: 2.0)
        chartView.animate(xAxisDuration: 2.0)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        switch desiredSensor
        {
        case .Accelerometer:
            getAccelerometerReading()
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
                self.updateGraph()
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
    }
    
    //    func setDataCount(count: Int) {
    //        var xVals: [AnyObject] = [AnyObject]()
    //        var entries: [AnyObject] = [AnyObject]()
    //        for var i = 0; i < count; i++ {
    //            xVals.append(i.stringValue())
    //            entries.append(BarChartDataEntry(value: sinf(M_PI * (i % 128) / 64.0), xIndex: i))
    //        }
    //        var set: BarChartDataSet? = nil
    //        if chartView.data.dataSetCount > 0 {
    //            set = (chartView.data.dataSets[0] as! BarChartDataSet)
    //            set.yVals = entries
    //            self.chartView.data.xValsObjc = xVals
    //            chartView.notifyDataSetChanged()
    //        }
    //        else {
    //            set = BarChartDataSet(yVals: entries, label: "Sinus Function")
    //            set.barSpace = 0.4
    //            set!.color = UIColor(red: 240 / 255.0, green: 120 / 255.0, blue: 124 / 255.0, alpha: 1.0)
    //            var data: BarChartData = BarChartData(xVals: xVals, dataSet: set!)
    //            data.valueFont = UIFont(name: "HelveticaNeue-Light", size: 10.0)
    //            data.drawValues = false
    //            self.chartView.data = data
    //        }
    //    }
    
    func updateGraph()
    {
        let newData = GraphsVC.sensorReadings.lastObject as! MBLAccelerometerData
        let lastElementIndex = GraphsVC.sensorReadings.count - 1
        let newDataEntry = BarChartDataEntry(value: newData.x, xIndex: lastElementIndex)
        dataEntries.append(newDataEntry)
        
        var dataSet: BarChartDataSet? = nil
        
        if chartView.data?.dataSetCount > 0
        {
            dataSet = chartView.data?.dataSets[0] as? BarChartDataSet
            dataSet?.yVals = dataEntries
            chartView.notifyDataSetChanged()
        }
        else
        {
            dataSet = BarChartDataSet(yVals: dataEntries, label: "X-Axis Accellerometer")
            dataSet?.barSpace = 0.4
            dataSet?.colors = [Constants.themeGreenColour]
            
            let barData: BarChartData = BarChartData()
            barData.dataSets = [dataSet!]
            barData.xVals = ["hello", "world", "this"]
            barData.setValueFont(Constants.defaultFont)
            
            self.chartView.data = barData
        }
    }
}

// MARK: ChartView Delegate
extension GraphsVC: ChartViewDelegate
{
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight)
    {
        print("Chart view selected")
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase)
    {
        print("Chart view nothing selected")
    }
}