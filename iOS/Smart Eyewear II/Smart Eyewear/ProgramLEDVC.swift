//
//  ProgramLEDVC.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 6/24/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class ProgramLEDVC: UIViewController
{
    var firstColorSelected: Bool = Bool()
    var secondColorSelected: Bool = Bool()
    var thirdColorSelected: Bool = Bool()
    
    @IBOutlet weak var firstTimerTextField: UITextField!
    @IBOutlet weak var secondTimerTextField: UITextField!
    @IBOutlet weak var thirdTimerTextField: UITextField!
    
    @IBOutlet weak var firstColorSequence: UIButton!
    @IBOutlet weak var secondColorSequence: UIButton!
    @IBOutlet weak var thirdColorSequence: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // hides keyboard when tapped outside of the textfields
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func colour1BtnAction(sender: UIButton)
    {
        firstColorSelected = true
        showColourPickerRelativeTo(sender)
    }
    
    @IBAction func colour2BtnAction(sender: UIButton)
    {
        secondColorSelected = true
        showColourPickerRelativeTo(sender)
    }
    
    @IBAction func colour3BtnAction(sender: UIButton)
    {
        thirdColorSelected = true
        showColourPickerRelativeTo(sender)
    }
    
    @IBAction func exitBtnAction(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveBtnAction(sender: UIButton)
    {
        print("Save button pressed")
        
        performFieldsCheck()
        
        Constants.eraseAllSwitchCommands()
        
        //        flashLEDWithTimer()
        //        flashLEDWithNumberOfFlashes()
    }
    
    //TODO: Reflect the LED colour to be that of the selected button
    func flashLEDWithTimer()
    {
        ConnectionVC.currentlySelectedDevice.mechanicalSwitch?.switchUpdateEvent.programCommandsToRunOnEventAsync({
            
            // flash the first sequence
            ConnectionVC.currentlySelectedDevice.led?.flashLEDColorAsync(UIColor.redColor(), withIntensity: 1.0, onTime: self.timeInMilliseconds(Int(self.firstTimerTextField.text!)!), andPeriod: self.timeInMilliseconds(Int(self.firstTimerTextField.text!)!) * 2)
            
            // flash the second sequence
            ConnectionVC.currentlySelectedDevice.led?.flashLEDColorAsync(UIColor.greenColor(), withIntensity: 1.0, onTime: self.timeInMilliseconds(Int(self.secondTimerTextField.text!)!), andPeriod: self.timeInMilliseconds(Int(self.firstTimerTextField.text!)!) * 4)
            
            // flash the third sequence
            ConnectionVC.currentlySelectedDevice.led?.flashLEDColorAsync(UIColor.blueColor(), withIntensity: 1.0, onTime: self.timeInMilliseconds(Int(self.thirdTimerTextField.text!)!), andPeriod: 0)
        })
    }
    
    func flashLEDWithNumberOfFlashes()
    {
        ConnectionVC.currentlySelectedDevice.mechanicalSwitch?.switchUpdateEvent.programCommandsToRunOnEventAsync({
            
            // flash the first sequence
            ConnectionVC.currentlySelectedDevice.led?.flashLEDColorAsync(self.firstColorSequence.backgroundColor!, withIntensity: 1.0, numberOfFlashes: UInt8(self.firstTimerTextField.text!)!)
            
            // flash the second sequence
            ConnectionVC.currentlySelectedDevice.led?.flashLEDColorAsync(self.secondColorSequence.backgroundColor!, withIntensity: 1.0, numberOfFlashes: UInt8(self.secondTimerTextField.text!)!)
            
            // flash the third sequence
            ConnectionVC.currentlySelectedDevice.led?.flashLEDColorAsync(self.thirdColorSequence.backgroundColor!, withIntensity: 1.0, numberOfFlashes: UInt8(self.thirdTimerTextField.text!)!)
        })
    }
    
    // POST: Makes sure that no empty fields exist
    func performFieldsCheck()
    {
        if firstTimerTextField.text?.characters.count < 1
        {
            firstTimerTextField.text = "1"
        }
        else if secondTimerTextField.text?.characters.count < 1
        {
            secondTimerTextField.text = "1"
        }
        else if thirdTimerTextField.text?.characters.count < 1
        {
            thirdTimerTextField.text = "1"
        }
    }
    
    func timeInMilliseconds(numberOfSeconds: Int)-> UInt16
    {
        return UInt16(numberOfSeconds * 1000)
    }
    
    private func showColourPickerRelativeTo(desiredButton: UIButton)
    {
        let colorPickerVC = storyboard?.instantiateViewControllerWithIdentifier("colorPicker") as! ColorPickerViewController
        
        colorPickerVC.modalPresentationStyle = .Popover
        
        colorPickerVC.preferredContentSize = CGSizeMake(265, 400)
        
        colorPickerVC.colorPickerDelegate = self
        
        if let popoverController = colorPickerVC.popoverPresentationController
        {
            popoverController.sourceView = self.view
            
            // show popover from button
            popoverController.sourceRect = desiredButton.frame
            
            // show popover arrow at feasible direction
            popoverController.permittedArrowDirections = UIPopoverArrowDirection.Any
            
            popoverController.delegate = self
        }
        
        presentViewController(colorPickerVC, animated: true, completion: nil)
    }
}

// MARK: Popover Delegate
extension ProgramLEDVC: UIPopoverPresentationControllerDelegate
{
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return .None // present popover for both iOS and iPad
    }
}

// MARK: Color Picker Delegate
extension ProgramLEDVC: ColorPickerDelegate
{
    func colorPickerDidColorSelected(selectedUIColor selectedUIColor: UIColor, selectedHexColor: String)
    {
        if firstColorSelected
        {
            firstColorSelected = false
            firstColorSequence.backgroundColor = selectedUIColor
        }
        else if secondColorSelected
        {
            secondColorSelected = false
            secondColorSequence.backgroundColor = selectedUIColor
        }
        else if thirdColorSelected
        {
            thirdColorSelected = false
            thirdColorSequence.backgroundColor = selectedUIColor
        }
    }
}
