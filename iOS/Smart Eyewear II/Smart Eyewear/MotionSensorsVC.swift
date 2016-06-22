//
//  MotionSensorsVC.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 6/22/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit

class MotionSensorsVC: UIViewController
{
    @IBOutlet weak var accelerometerBtn: UIButton!
    @IBOutlet weak var gyroscopeBtn: UIButton!
    @IBOutlet weak var magnetometerBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // increase character spacing
        accelerometerBtn.titleLabel?.kerning = 1.0
        gyroscopeBtn.titleLabel?.kerning = (accelerometerBtn.titleLabel?.kerning)!
        magnetometerBtn.titleLabel?.kerning = (accelerometerBtn.titleLabel?.kerning)!
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = Constants.themeRedColour
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "NavOthersWhite"))
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}
