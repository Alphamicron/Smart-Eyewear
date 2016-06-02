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
    
    var redSlider: UISlider = UISlider()
    var greenSlider: UISlider = UISlider()
    var blueSlider: UISlider = UISlider()
    
    var redValueLabel: UILabel = UILabel()
    var greenValueLabel: UILabel = UILabel()
    var blueValueLabel: UILabel = UILabel()
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        Constants.turnOffMetaWearLED()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if !Constants.isDeviceConnected()
        {
            presentViewController(Constants.defaultErrorAlert("Device Error", errorMessage: "A device needs to be connected to change its LED colours"), animated: true, completion: nil)
        }
        
        setupTheColorWheel()
        
        setupTheRGBLabels()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
    
    func setupTheRGBLabels()
    {
        // Create the colour labels
        let redLabel: UILabel = UILabel(frame: CGRect(x: 15, y: 425, width: 35, height: 20))
        let greenLabel: UILabel = UILabel(frame: CGRect(x: redLabel.frame.origin.x, y: redLabel.frame.origin.y + 60, width: redLabel.frame.width, height: redLabel.frame.height))
        let blueLabel: UILabel = UILabel(frame: CGRect(x: redLabel.frame.origin.x, y: greenLabel.frame.origin.y + 60, width: redLabel.frame.width, height: redLabel.frame.height))
        
        // Create the colour sliders
        redSlider = UISlider(frame: CGRect(x: redLabel.frame.width + 5, y: 420 + redLabel.frame.height/2, width: 250, height: 10))
        greenSlider = UISlider(frame: CGRect(x: redSlider.frame.origin.x, y: 479 + greenLabel.frame.height/2, width: redSlider.frame.width, height: redSlider.frame.height))
        blueSlider = UISlider(frame: CGRect(x: redSlider.frame.origin.x, y: 538 + blueLabel.frame.height/2, width: redSlider.frame.width, height: redSlider.frame.height))
        
        redValueLabel = UILabel(frame: CGRect(x: redSlider.frame.width + 50, y: redSlider.frame.origin.y - 15, width: 35, height: 35))
        greenValueLabel = UILabel(frame: CGRect(x: redValueLabel.frame.origin.x, y: greenSlider.frame.origin.y - 15, width: redValueLabel.frame.width, height: redValueLabel.frame.height))
        blueValueLabel = UILabel(frame: CGRect(x: redValueLabel.frame.origin.x, y: blueSlider.frame.origin.y - 15, width: redValueLabel.frame.width, height: redValueLabel.frame.height))
        
        // Initialize their respective values
        redSlider.minimumValue = 0
        redSlider.maximumValue = 255
        greenSlider.minimumValue = redSlider.minimumValue
        greenSlider.maximumValue = redSlider.maximumValue
        blueSlider.minimumValue = redSlider.minimumValue
        blueSlider.maximumValue = redSlider.maximumValue
        
        // Setup the label fonts and sizes
        redLabel.font = Constants.defaultFont
        greenLabel.font = Constants.defaultFont
        blueLabel.font = Constants.defaultFont
        redValueLabel.font = Constants.defaultFont
        greenValueLabel.font = Constants.defaultFont
        blueValueLabel.font = Constants.defaultFont
        
        // Pretty much assigning texts to the labels
        redLabel.text = "R"
        greenLabel.text = "G"
        blueLabel.text = "B"
        
        // Update the slider values initially
        redSlider.setValue((colorWheelView.currentColor.getRGBAValue()?.red)!, animated: true)
        greenSlider.setValue((colorWheelView.currentColor.getRGBAValue()?.green)!, animated: true)
        blueSlider.setValue((colorWheelView.currentColor.getRGBAValue()?.blue)!, animated: true)
        
        redValueLabel.text = String(Int((colorWheelView.currentColor.getRGBAValue()?.red)!))
        greenValueLabel.text = String(Int((colorWheelView.currentColor.getRGBAValue()?.green)!))
        blueValueLabel.text = String(Int((colorWheelView.currentColor.getRGBAValue()?.blue)!))
        
        self.view.addSubview(redLabel)
        self.view.addSubview(greenLabel)
        self.view.addSubview(blueLabel)
        self.view.addSubview(redSlider)
        self.view.addSubview(greenSlider)
        self.view.addSubview(blueSlider)
        self.view.addSubview(redValueLabel)
        self.view.addSubview(greenValueLabel)
        self.view.addSubview(blueValueLabel)
    }
}

// MARK: ISColorWheel Delegate
extension RGBLedVC: ISColorWheelDelegate
{
    func colorWheelDidChangeColor(colorWheel: ISColorWheel!)
    {
        DevicesTVC.currentlySelectedDevice.led?.setLEDColorAsync(colorWheel.currentColor, withIntensity: Constants.defaultLEDIntensity)
        
        // TODO: Is this update really necessary
        // update the sliders to reflect the current colour being hovered over by the wheel
        redSlider.setValue((colorWheel.currentColor.getRGBAValue()?.red)!, animated: true)
        greenSlider.setValue((colorWheel.currentColor.getRGBAValue()?.green)!, animated: true)
        blueSlider.setValue((colorWheel.currentColor.getRGBAValue()?.blue)!, animated: true)
        
        redValueLabel.text = String(Int((colorWheel.currentColor.getRGBAValue()?.red)!))
        greenValueLabel.text = String(Int((colorWheel.currentColor.getRGBAValue()?.green)!))
        blueValueLabel.text = String(Int((colorWheel.currentColor.getRGBAValue()?.blue)!))
    }
}
