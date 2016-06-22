//
//  RGBVC.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 6/11/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class RGBVC: UIViewController
{
    var colorWheel: ISColorWheel = ISColorWheel()
    
    var redLabel: UILabel = UILabel()
    var greenLabel: UILabel = UILabel()
    var blueLabel: UILabel = UILabel()
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!
    
    @IBOutlet weak var colorView: UIView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if !Constants.isDeviceConnected()
        {
            Constants.defaultErrorAlert(self, errorTitle: "Connection Error", errorMessage: "A CTRL Eyewear needs to be connected to change its LED colours", errorPriority: Constants.AlertPriority.Medium)
            
            Constants.displayBackgroundImageOnError(self.view, typeOfError: Constants.ErrorState.NoMetaWear)
        }
        else
        {
            createTheColorWheel()
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = Constants.themeRedColour
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "NavRGBWhite"))
        
        // initialise with a value first
        redSlider.setValue((colorWheel.currentColor.getRGBAValue()?.red)!, animated: true)
        greenSlider.setValue((colorWheel.currentColor.getRGBAValue()?.green)!, animated: true)
        blueSlider.setValue((colorWheel.currentColor.getRGBAValue()?.blue)!, animated: true)
        
        // initialise them with the current colour wheel's colour value
        redValueLabel.text = String(Int((colorWheel.currentColor.getRGBAValue()?.red)!))
        greenValueLabel.text = String(Int((colorWheel.currentColor.getRGBAValue()?.green)!))
        blueValueLabel.text = String(Int((colorWheel.currentColor.getRGBAValue()?.blue)!))
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        Constants.turnOffMetaWearLED()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // PRE: View needs to be loaded
    // POST: A color wheel is added onto the loaded view
    func createTheColorWheel()
    {
        // iPhone 6S best settings
        //        let colorWheelSize: CGSize = CGSizeMake(colorView.bounds.size.width * 0.9, colorView.bounds.size.height * 0.9)
        //        
        //        colorWheel = ISColorWheel(frame: CGRect(x: colorWheelSize.width/14, y: 15, width: colorView.bounds.size.width/2, height: colorView.bounds.size.height))
        
        let size: CGSize = colorView.bounds.size
        
        let wheelSize = CGSizeMake(size.width * 0.41, size.width * 0.41)
        
        colorWheel = ISColorWheel(frame: CGRect(x: size.width/15, y: 5, width: wheelSize.width, height: wheelSize.height))
        
        colorWheel.delegate = self
        colorWheel.continuous = false
        
        colorView.addSubview(colorWheel)
    }
    
    @IBAction func redSliderTapped(sender: UISlider)
    {
        redValueLabel.text = String(Int(sender.value))
        
        let userDesiredColor: UIColor = UIColor(red: CGFloat(sender.value/255.0), green: CGFloat(greenSlider.value/255.0), blue: CGFloat(blueSlider.value/255.0), alpha: 1)
        
        ConnectionVC.currentlySelectedDevice.led?.setLEDColorAsync(userDesiredColor, withIntensity: Constants.defaultLEDIntensity)
    }
    
    @IBAction func greenSliderTapped(sender: UISlider)
    {
        greenValueLabel.text = String(Int(sender.value))
        
        let userDesiredColor: UIColor = UIColor(red: CGFloat(redSlider.value/255.0), green: CGFloat(sender.value/255.0), blue: CGFloat(blueSlider.value/255.0), alpha: 1)
        
        ConnectionVC.currentlySelectedDevice.led?.setLEDColorAsync(userDesiredColor, withIntensity: Constants.defaultLEDIntensity)
    }
    
    @IBAction func blueSliderTapped(sender: UISlider)
    {
        blueValueLabel.text = String(Int(sender.value))
        
        let userDesiredColor: UIColor = UIColor(red: CGFloat(redSlider.value/255.0), green: CGFloat(greenSlider.value/255.0), blue: CGFloat(sender.value/255.0), alpha: 1)
        
        ConnectionVC.currentlySelectedDevice.led?.setLEDColorAsync(userDesiredColor, withIntensity: Constants.defaultLEDIntensity)
    }
}

// MARK: ISColorWheel Delegate
extension RGBVC: ISColorWheelDelegate
{
    func colorWheelDidChangeColor(colorWheel: ISColorWheel!)
    {
        ConnectionVC.currentlySelectedDevice.led?.setLEDColorAsync(colorWheel.currentColor, withIntensity: Constants.defaultLEDIntensity)
        
        redSlider.setValue((colorWheel.currentColor.getRGBAValue()?.red)!, animated: true)
        greenSlider.setValue((colorWheel.currentColor.getRGBAValue()?.green)!, animated: true)
        blueSlider.setValue((colorWheel.currentColor.getRGBAValue()?.blue)!, animated: true)
        
        redValueLabel.text = String(Int((colorWheel.currentColor.getRGBAValue()?.red)!))
        greenValueLabel.text = String(Int((colorWheel.currentColor.getRGBAValue()?.green)!))
        blueValueLabel.text = String(Int((colorWheel.currentColor.getRGBAValue()?.blue)!))
    }
}

