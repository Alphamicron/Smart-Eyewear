//
//  GraphsVC.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 6/22/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit
import PNChart

class GraphsVC: UIViewController
{
    var desiredSensor: Constants.Sensor = Constants.Sensor.Null
    let BMM150Magnetometer: MBLMagnetometerBMM150 = ConnectionVC.currentlySelectedDevice.magnetometer as! MBLMagnetometerBMM150
    let lineChart: PNLineChart = PNLineChart(frame: CGRect(x: 0, y: 0, width: GraphsVC().view.bounds.size.width, height: GraphsVC().view.bounds.size.height))
    var newPoints: [GraphPoints] = [GraphPoints]()
    
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
        
        print("VWD called")
        stopStreamingSensorInfo()
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
    
    //    func graphResults(newGraphPoint: GraphPoints)
    //    {
    //        newPoints.append(newGraphPoint)
    //        
    //        // X-Value Graph
    //        let xValueData: PNLineChartData = PNLineChartData()
    //        xValueData.color = Constants.themeGreenColour
    //        xValueData.itemCount = UInt(newPoints.count)
    //        xValueData.inflexionPointStyle = .Triangle
    //        
    //        xValueData.getData = ({(index: Int) -> PNLineChartDataItem in
    //            //            var xValue: CGFloat = self.newPoints[index].xValue
    //            //            var item: PNLineChartDataItem = PNLineChartDataItem(y: xValue)
    //            //            return item
    //            return PNLineChartDataItem(y: newPoints[index].xValue)
    //        })
    //        
    //        lineChart.strokeChart()
    //        
    //        self.view.addSubview(lineChart)
    //    }
}
