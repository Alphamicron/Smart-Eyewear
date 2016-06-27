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
    @IBOutlet weak var firstTimerTextField: UITextField!
    @IBOutlet weak var secondTimerTextField: UITextField!
    @IBOutlet weak var thirdTimerTextField: UITextField!
    
    @IBOutlet weak var firstColorSequence: UIButton!
    @IBOutlet weak var secondColorSequence: UIButton!
    @IBOutlet weak var thirdColorSequence: UIButton!
    
    var firstColorSelected: Bool = Bool()
    var secondColorSelected: Bool = Bool()
    var thirdColorSelected: Bool = Bool()
    
    var userSelectedColour: UIColor = UIColor()
    
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
        showColourPickerBelow(sender)
        firstColorSelected = true
    }
    
    @IBAction func colour2BtnAction(sender: UIButton)
    {
        showColourPickerBelow(sender)
        secondColorSelected = true
    }
    
    @IBAction func colour3BtnAction(sender: UIButton)
    {
        showColourPickerBelow(sender)
        thirdColorSelected = true
    }
    
    // MARK: Textfield Editing Did End
    @IBAction func firstColourAction(sender: UITextField)
    {
        print("First colour text box: \(sender.text!)")
    }
    
    @IBAction func secondColorAction(sender: UITextField)
    {
        print("Second colour textbox: \(sender.text!)")
    }
    
    @IBAction func thirdColurAction(sender: UITextField)
    {
        print("Third colour textbox: \(sender.text!)")
    }
    
    @IBAction func exitBtnAction(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveBtnAction(sender: UIButton)
    {
        print("Save button pressed")
    }
    
    private func showColourPickerBelow(desiredButton: UIButton)
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
