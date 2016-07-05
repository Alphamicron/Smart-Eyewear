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
    let BMM160Accelerometer: MBLAccelerometerBMI160 = ConnectionVC.currentlySelectedDevice.accelerometer as! MBLAccelerometerBMI160
    
    //    MBLAccelerometerBMI160 *accelerometer = (MBLAccelerometerBMI160 *)device.accelerometer
    
    var dataEntries: [BarChartDataEntry] = [BarChartDataEntry]()
    static var sensorReadings: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
        //        ConnectionVC.currentlySelectedDevice.accelerometer?.dataReadyEvent.startNotificationsWithHandlerAsync({ (result: AnyObject?, error: NSError?) in
        //            if error == nil
        //            {
        //                let accelData: MBLAccelerometerData = result as! MBLAccelerometerData
        //                GraphsVC.sensorReadings.addObject(accelData)
        //                print(accelData)
        //            }
        //            else
        //            {
        //                print("Error getting accelerometer data")
        //                print(error?.localizedDescription)
        //            }
        //        })
        
        BMM160Accelerometer.stepEvent.startNotificationsWithHandlerAsync { (result: AnyObject?, error:NSError?) in
            if error == nil
            {
                let stepData: MBLNumericData = result as! MBLNumericData
                print("Data step: \(stepData)")
            }
            else
            {
                print("Error getting footstep data")
                print(error?.localizedDescription)
            }
        }
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