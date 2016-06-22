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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
