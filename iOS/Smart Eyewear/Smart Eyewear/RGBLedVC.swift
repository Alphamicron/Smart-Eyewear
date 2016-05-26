//
//  RGBLedVC.swift
//  Smart Eyewear
//
//  Created by Emil Shirima on 5/24/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class RGBLedVC: UIViewController
{
    var colorWheelView: ISColorWheel = ISColorWheel()
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        Constants.turnOffAllLEDs()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if !Constants.isDeviceConnected()
        {
            presentViewController(Constants.defaultErrorAlert("Device Error", errorMessage: "A device needs to be connected to change its LED colours"), animated: true, completion: nil)
        }
        
        setupTheColorWheel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // PRE: View needs to be loaded
    // POST: A color wheel is added onto the loaded view
    func setupTheColorWheel()
    {
        let colorWheelSize: CGSize = CGSizeMake(self.view.bounds.size.width * 0.9, self.view.bounds.size.height * 0.5)
        
        colorWheelView = ISColorWheel(frame: CGRect(x: self.view.bounds.size.width / 2 - colorWheelSize.width / 2, y: self.view.bounds.size.height * 0.1, width: colorWheelSize.width, height: colorWheelSize.height))
        colorWheelView.delegate = self
        // if true, a single tap and drag reflects colour changes
        // if false, a user is required to drag and stop at a point for the colour to be changed
        colorWheelView.continuous = true
        
        self.view.addSubview(colorWheelView)
    }
}

// MARK: ISColorWheel Delegate
extension RGBLedVC: ISColorWheelDelegate
{
    func colorWheelDidChangeColor(colorWheel: ISColorWheel!)
    {
        DevicesTVC.currentlySelectedDevice.led?.setLEDColorAsync(colorWheel.currentColor, withIntensity: Constants.defaultLEDIntensity)
        print(colorWheel.currentColor.getHexValue())
    }
}
