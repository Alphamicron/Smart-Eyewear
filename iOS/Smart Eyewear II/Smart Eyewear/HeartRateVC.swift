//
//  HeartRateVC.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 7/18/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class HeartRateVC: UIViewController
{
    var entryText: String = String()
    
    @IBOutlet weak var entryLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        entryLabel.text = entryText
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func exitBtnAction(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
