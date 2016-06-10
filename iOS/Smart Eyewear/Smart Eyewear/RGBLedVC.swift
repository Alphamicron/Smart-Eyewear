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
    
    var redLabel: UILabel = UILabel()
    var greenLabel: UILabel = UILabel()
    var blueLabel: UILabel = UILabel()
    
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
        
        self.navigationController?.navigationBar.barTintColor = Constants.themeRedColour
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "NavRGBWhite"))
        
        if !Constants.isDeviceConnected()
        {
            presentViewController(Constants.defaultErrorAlert("Device Error", errorMessage: "A device needs to be connected to change its LED colours"), animated: true, completion: nil)
            
            Constants.displayBackgroundImageOnError(self.view, typeOfError: Constants.ErrorState.NoMetaWear)
        }
        else
        {
            createTheColorWheel()
            createTheColourTitleLabels()
            createColourSliders()
            createColourValueLabels()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // PRE: View needs to be loaded
    // POST: A color wheel is added onto the loaded view
    func createTheColorWheel()
    {
        let colorWheelSize: CGSize = CGSizeMake(self.view.bounds.size.width * 0.9, self.view.bounds.size.height * 0.5)
        
        colorWheelView = ISColorWheel(frame: CGRect(x: self.view.bounds.size.width / 2 - colorWheelSize.width / 2, y: self.view.bounds.size.height * 0.1, width: colorWheelSize.width, height: colorWheelSize.height))
        colorWheelView.delegate = self
        // if true, a single tap and drag reflects colour changes
        // if false, a user is required to drag and stop at a point for the colour to be changed
        colorWheelView.continuous = false
        
        self.view.addSubview(colorWheelView)
    }
    
    func createTheColourTitleLabels()
    {
        // create labels
        redLabel = UILabel(frame: CGRect(x: 15, y: 425, width: 35, height: 20))
        greenLabel = UILabel(frame: CGRect(x: redLabel.frame.origin.x, y: redLabel.frame.origin.y + 60, width: redLabel.frame.width, height: redLabel.frame.height))
        blueLabel = UILabel(frame: CGRect(x: redLabel.frame.origin.x, y: greenLabel.frame.origin.y + 60, width: redLabel.frame.width, height: redLabel.frame.height))
        
        // set their titles respectively
        redLabel.text = "R"
        greenLabel.text = "G"
        blueLabel.text = "B"
        
        // set the text font
        redLabel.font = Constants.defaultFont
        greenLabel.font = Constants.defaultFont
        blueLabel.font = Constants.defaultFont
        
        // add them to the main view
        self.view.addSubview(redLabel)
        self.view.addSubview(greenLabel)
        self.view.addSubview(blueLabel)
    }
    
    func createColourSliders()
    {
        // create sliders
        redSlider = UISlider(frame: CGRect(x: redLabel.frame.width + 5, y: 420 + redLabel.frame.height/2, width: 250, height: 10))
        greenSlider = UISlider(frame: CGRect(x: redSlider.frame.origin.x, y: 479 + greenLabel.frame.height/2, width: redSlider.frame.width, height: redSlider.frame.height))
        blueSlider = UISlider(frame: CGRect(x: redSlider.frame.origin.x, y: 538 + blueLabel.frame.height/2, width: redSlider.frame.width, height: redSlider.frame.height))
        
        // declare their properties
        redSlider.minimumValue = Float()
        redSlider.maximumValue = 255
        greenSlider.minimumValue = redSlider.minimumValue
        greenSlider.maximumValue = redSlider.maximumValue
        blueSlider.minimumValue = redSlider.minimumValue
        blueSlider.maximumValue = redSlider.maximumValue
        
        // initialize with a value first
        redSlider.setValue((colorWheelView.currentColor.getRGBAValue()?.red)!, animated: true)
        greenSlider.setValue((colorWheelView.currentColor.getRGBAValue()?.green)!, animated: true)
        blueSlider.setValue((colorWheelView.currentColor.getRGBAValue()?.blue)!, animated: true)
        
        // add actions to the sliders
        redSlider.addTarget(self, action: #selector(RGBLedVC.redSliderTapped(_:)), forControlEvents: .ValueChanged)
        greenSlider.addTarget(self, action: #selector(RGBLedVC.greenSliderTapped(_:)), forControlEvents: .ValueChanged)
        blueSlider.addTarget(self, action: #selector(RGBLedVC.blueSliderTapped(_:)), forControlEvents: .ValueChanged)
        
        // add them to the main view
        self.view.addSubview(redSlider)
        self.view.addSubview(greenSlider)
        self.view.addSubview(blueSlider)
    }
    
    func createColourValueLabels()
    {
        // create the labels
        redValueLabel = UILabel(frame: CGRect(x: redSlider.frame.width + 50, y: redSlider.frame.origin.y - 15, width: 35, height: 35))
        greenValueLabel = UILabel(frame: CGRect(x: redValueLabel.frame.origin.x, y: greenSlider.frame.origin.y - 15, width: redValueLabel.frame.width, height: redValueLabel.frame.height))
        blueValueLabel = UILabel(frame: CGRect(x: redValueLabel.frame.origin.x, y: blueSlider.frame.origin.y - 15, width: redValueLabel.frame.width, height: redValueLabel.frame.height))
        
        
        // asssign fonts
        redValueLabel.font = Constants.defaultFont
        greenValueLabel.font = Constants.defaultFont
        blueValueLabel.font = Constants.defaultFont
        
        // initialise them with the current colour wheel's colour value
        redValueLabel.text = String(Int((colorWheelView.currentColor.getRGBAValue()?.red)!))
        greenValueLabel.text = String(Int((colorWheelView.currentColor.getRGBAValue()?.green)!))
        blueValueLabel.text = String(Int((colorWheelView.currentColor.getRGBAValue()?.blue)!))
        
        // add them to the main view
        self.view.addSubview(redValueLabel)
        self.view.addSubview(greenValueLabel)
        self.view.addSubview(blueValueLabel)
    }
    
    func redSliderTapped(sender: UISlider)
    {
        redValueLabel.text = String(Int(sender.value))
        
        let userDesiredColor: UIColor = UIColor(red: CGFloat(sender.value/255.0), green: CGFloat(greenSlider.value/255.0), blue: CGFloat(blueSlider.value/255.0), alpha: 1)
        
        ConnectionVC.currentlySelectedDevice.led?.setLEDColorAsync(userDesiredColor, withIntensity: Constants.defaultLEDIntensity)
    }
    
    func greenSliderTapped(sender: UISlider)
    {
        greenValueLabel.text = String(Int(sender.value))
        
        let userDesiredColor: UIColor = UIColor(red: CGFloat(redSlider.value/255.0), green: CGFloat(sender.value/255.0), blue: CGFloat(blueSlider.value/255.0), alpha: 1)
        
        ConnectionVC.currentlySelectedDevice.led?.setLEDColorAsync(userDesiredColor, withIntensity: Constants.defaultLEDIntensity)
    }
    
    func blueSliderTapped(sender: UISlider)
    {
        blueValueLabel.text = String(Int(sender.value))
        
        let userDesiredColor: UIColor = UIColor(red: CGFloat(redSlider.value/255.0), green: CGFloat(greenSlider.value/255.0), blue: CGFloat(sender.value/255.0), alpha: 1)
        
        ConnectionVC.currentlySelectedDevice.led?.setLEDColorAsync(userDesiredColor, withIntensity: Constants.defaultLEDIntensity)
    }
}

// MARK: ISColorWheel Delegate
extension RGBLedVC: ISColorWheelDelegate
{
    func colorWheelDidChangeColor(colorWheel: ISColorWheel!)
    {
        ConnectionVC.currentlySelectedDevice.led?.setLEDColorAsync(colorWheel.currentColor, withIntensity: Constants.defaultLEDIntensity)
        
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
