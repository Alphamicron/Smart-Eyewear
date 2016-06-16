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
    var colorWheelView: ISColorWheel = ISColorWheel()
    
    var redLabel: UILabel = UILabel()
    var greenLabel: UILabel = UILabel()
    var blueLabel: UILabel = UILabel()
    
    //    var redSlider: UISlider = UISlider()
    //    var greenSlider: UISlider = UISlider()
    //    var blueSlider: UISlider = UISlider()
    
    //    var redValueLabel: UILabel = UILabel()
    //    var greenValueLabel: UILabel = UILabel()
    //    var blueValueLabel: UILabel = UILabel()
    
    
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
            //            createTheColourTitleLabels()
            //            createColourSliders()
            //            createColourValueLabels()
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = Constants.themeRedColour
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "NavRGBWhite"))
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
        //        colorWheelView = ISColorWheel(frame: CGRect(x: colorWheelSize.width/14, y: 15, width: colorView.bounds.size.width/2, height: colorView.bounds.size.height))
        
        colorView.backgroundColor = UIColor.brownColor()
        
        colorWheelView = ISColorWheel(frame: CGRect(x: 0, y: 0, width: colorView.frame.size.width/5, height: colorView.frame.size.height/5))
        
        print(colorView.frame.size.height)
        print(colorWheelView.frame.size.height)
        
        colorWheelView.backgroundColor = UIColor.blueColor()
        
        colorWheelView.delegate = self
        // if true, a single tap and drag reflects colour changes
        // if false, a user is required to drag and stop at a point for the colour to be changed
        colorWheelView.continuous = false
        
        colorView.addSubview(colorWheelView)
    }
    
    func createTheColourTitleLabels()
    {
        // create labels
        redLabel = UILabel(frame: CGRect(x: 15, y: 347, width: 35, height: 25))
        greenLabel = UILabel(frame: CGRect(x: redLabel.frame.origin.x, y: redLabel.frame.origin.y + 60, width: redLabel.frame.width, height: redLabel.frame.height))
        blueLabel = UILabel(frame: CGRect(x: redLabel.frame.origin.x, y: greenLabel.frame.origin.y + 60, width: redLabel.frame.width, height: redLabel.frame.height))
        
        // set their titles respectively
        redLabel.text = "r"
        greenLabel.text = "g"
        blueLabel.text = "b"
        
        // set the text font
        redLabel.font = Constants.defaultFont
        greenLabel.font = Constants.defaultFont
        blueLabel.font = Constants.defaultFont
        
        redLabel.textColor = Constants.themeTextColour
        greenLabel.textColor = Constants.themeTextColour
        blueLabel.textColor = Constants.themeTextColour
        
        // add them to the main view
        self.view.addSubview(redLabel)
        self.view.addSubview(greenLabel)
        self.view.addSubview(blueLabel)
    }
    
    func createColourSliders()
    {
        // create sliders
        redSlider = UISlider(frame: CGRect(x: redLabel.frame.width + 5, y: 345 + redLabel.frame.height/2, width: 250, height: 10))
        greenSlider = UISlider(frame: CGRect(x: redSlider.frame.origin.x, y: 404 + greenLabel.frame.height/2, width: redSlider.frame.width, height: redSlider.frame.height))
        blueSlider = UISlider(frame: CGRect(x: redSlider.frame.origin.x, y: 463 + blueLabel.frame.height/2, width: redSlider.frame.width, height: redSlider.frame.height))
        
        // declare their properties
        redSlider.minimumValue = Float()
        redSlider.maximumValue = 255
        greenSlider.minimumValue = redSlider.minimumValue
        greenSlider.maximumValue = redSlider.maximumValue
        blueSlider.minimumValue = redSlider.minimumValue
        blueSlider.maximumValue = redSlider.maximumValue
        
        // set colour of left side of slider
        redSlider.minimumTrackTintColor = Constants.themeRedColour
        greenSlider.minimumTrackTintColor = Constants.themeGreenColour
        blueSlider.minimumTrackTintColor = UIColor(red: 0.067, green: 0.329, blue: 0.757, alpha: 1.00)
        
        // set colour of right side of slider
        redSlider.maximumTrackTintColor = Constants.themeInactiveStateColour
        greenSlider.maximumTrackTintColor = Constants.themeInactiveStateColour
        blueSlider.maximumTrackTintColor = Constants.themeInactiveStateColour
        
        // set colour of the thumb itself
        redSlider.thumbTintColor = Constants.themeRedColour
        greenSlider.thumbTintColor = Constants.themeGreenColour
        blueSlider.thumbTintColor = UIColor(red: 0.067, green: 0.329, blue: 0.757, alpha: 1.00)
        
        // non-continuous updates. Updates reflected after the slider has been released
        redSlider.continuous = false
        greenSlider.continuous = false
        blueSlider.continuous = false
        
        // initialize with a value first
        redSlider.setValue((colorWheelView.currentColor.getRGBAValue()?.red)!, animated: true)
        greenSlider.setValue((colorWheelView.currentColor.getRGBAValue()?.green)!, animated: true)
        blueSlider.setValue((colorWheelView.currentColor.getRGBAValue()?.blue)!, animated: true)
        
        // add actions to the sliders
        redSlider.addTarget(self, action: #selector(RGBVC.redSliderTapped(_:)), forControlEvents: .ValueChanged)
        greenSlider.addTarget(self, action: #selector(RGBVC.greenSliderTapped(_:)), forControlEvents: .ValueChanged)
        blueSlider.addTarget(self, action: #selector(RGBVC.blueSliderTapped(_:)), forControlEvents: .ValueChanged)
        
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
        
        // increase character spacing
        redValueLabel.kerning = 1.0
        greenValueLabel.kerning = 1.0
        blueValueLabel.kerning = 1.0
        
        // assign text colour
        redValueLabel.textColor = Constants.themeTextColour
        greenValueLabel.textColor = Constants.themeTextColour
        blueValueLabel.textColor = Constants.themeTextColour
        
        // initialise them with the current colour wheel's colour value
        redValueLabel.text = String(Int((colorWheelView.currentColor.getRGBAValue()?.red)!))
        greenValueLabel.text = String(Int((colorWheelView.currentColor.getRGBAValue()?.green)!))
        blueValueLabel.text = String(Int((colorWheelView.currentColor.getRGBAValue()?.blue)!))
        
        // add them to the main view
        self.view.addSubview(redValueLabel)
        self.view.addSubview(greenValueLabel)
        self.view.addSubview(blueValueLabel)
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

