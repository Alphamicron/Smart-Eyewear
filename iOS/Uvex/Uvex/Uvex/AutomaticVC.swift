//
//  AutomaticVC.swift
//  Uvex
//
//  Created by Alphamicron on 8/12/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit
import JSSAlertView

class AutomaticVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if ManualVC.manualModeOn
        {
            let userAlert = JSSAlertView().show(
                self,
                title: "Confirm",
                text: "Manual mode is still active. Do you wish to deactivate it?",
                buttonText: "Yep",
                cancelButtonText: "Nope"
            )
            
            userAlert.setTitleFont("AvenirNext-Regular")
            userAlert.setTextFont("AvenirNext-Regular")
            userAlert.setButtonFont("AvenirNext-Regular")
            userAlert.addAction(test)
            userAlert.addCancelAction(exitView)
        }
        else
        {
            
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func test()
    {
        print("user entered auto mode")
        
        ManualVC.manualModeOn = false
        ManualVC.turnPhotoSensor(SwitchState.Off)
    }
    
    func exitView()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
}