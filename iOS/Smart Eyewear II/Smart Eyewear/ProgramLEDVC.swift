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
        print("Colour I button tapped")
    }
    
    @IBAction func colour2BtnAction(sender: UIButton)
    {
        print("Colour II button tapped")
    }
    
    @IBAction func colour3BtnAction(sender: UIButton)
    {
        print("Colour III button tapped")
    }
    
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
}
