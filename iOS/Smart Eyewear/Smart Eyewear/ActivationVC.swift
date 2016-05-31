//
//  ActivationVC.swift
//  Smart Eyewear
//
//  Created by Emil Shirima on 5/24/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class ActivationVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func turnOnOffBtnAction(sender: UIButton)
    {
        if sender.currentTitle == "Turn On"
        {
            // TODO: Diconnect connection from the photo sensor
            sender.setTitle("Turn Off", forState: .Normal)
        }
        else
        {
            // TODO: Initiate connection to the poto sensor
            sender.setTitle("Turn On", forState: .Normal)
        }
    }
    
    @IBAction func automaticBtnAction(sender: UIButton)
    {
        print("Automatic Mode Activated")
    }
    
}
