//
//  BatteryLevelVC.swift
//  Smart Eyewear
//
//  Created by Emil Shirima on 5/24/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit
import PNChart
import JSSAlertView

class BatteryLevelVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if !Constants.isDeviceConnected()
        {
            Constants.defaultErrorAlert(self, errorTitle: "Connection Error", errorMessage: "A CTRL Eyewear needs to be connected to see its battery life", errorPriority: AlertPriority.High)
            
            //            Constants.displayBackgroundImageOnError(self.view, typeOfError: ErrorState.NoMetaWear)
        }
        else
        {
            ConnectionVC.currentlySelectedDevice.readBatteryLifeWithHandler({ (deviceChargeValue: NSNumber?, error: NSError?) in
                
                // Metawear error getting the current battery level
                if let batteryCheckError = error
                {
                    let userAlert = JSSAlertView().show(
                        self,
                        title: "Battery Error",
                        text: batteryCheckError.localizedDescription,
                        buttonText: "Try Again",
                        cancelButtonText: "Dismiss"
                    )
                    
                    userAlert.setTitleFont("AvenirNext-Regular")
                    userAlert.setTextFont("AvenirNext-Regular")
                    userAlert.setButtonFont("AvenirNext-Regular")
                    userAlert.addAction(self.viewDidLoad)
                }
                
                self.drawCircleGraph(deviceChargeValue!)
            })
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // POST: Represents the device's charge in a circle graph
    func drawCircleGraph(currentDeviceCharge: NSNumber)
    {
        let circleFrame: CGRect = CGRect(x: self.view.bounds.size.width/2.02, y: self.view.bounds.size.height/4, width: self.view.bounds.size.width/65, height: self.view.bounds.size.height/2)
        
        let circleChart = PNCircleChart(frame: circleFrame, total: Constants.deviceFullChargeValue, current: currentDeviceCharge, clockwise: true, shadow: true, shadowColor: Constants.themeGreyColour)
        
        circleChart.displayCountingLabel = true
        circleChart.countingLabel.font = Constants.defaultNormalFont.fontWithSize(40)
        circleChart.countingLabel.kerning = 1.0 // increase character spacing
        circleChart.lineWidth = 28
        circleChart.strokeColor = getColourForCharge(currentDeviceCharge)
        
        circleChart.strokeChart()
        
        self.view.addSubview(circleChart)
    }
    
    func getColourForCharge(currentDeviceCharge: NSNumber)-> UIColor
    {        
        if currentDeviceCharge.intValue > 50 // good charge if above half
        {
            return Constants.themeGreenColour
        }
        else if currentDeviceCharge.intValue <= 50 && currentDeviceCharge.intValue > 25 // medium charge if between (25-50]
        {
            return Constants.themeYellowColour
        }
        else // low charge if <=25
        {
            return Constants.themeRedColour
        }
    }
}