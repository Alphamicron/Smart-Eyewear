//
//  ConnectionVC.swift
//  Uvex
//
//  Created by Alphamicron on 8/15/16.
//  Copyright © 2016 Alphamicron. All rights reserved.
//

import UIKit

class ConnectionVC: UIViewController
{
    @IBOutlet weak var bluetoothImageView: UIImageView!
    @IBOutlet weak var metawearStateLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupTheUI()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        MainPageVC.activateScroll(false)
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        MainPageVC.activateScroll(true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func setupTheUI()
    {
        let layer: CALayer = self.metawearStateLabel.layer
        let bottomBorder: CALayer = CALayer(layer: layer)
        
        bottomBorder.borderWidth = 3
        bottomBorder.frame = CGRectMake(-bottomBorder.borderWidth, layer.frame.size.height-bottomBorder.borderWidth, layer.frame.size.width, bottomBorder.borderWidth)
        bottomBorder.borderColor = UIColor(red: 0.282, green: 0.278, blue: 0.278, alpha: 1.00).CGColor
        
        layer.addSublayer(bottomBorder)
    }
    
    @IBAction func connectionAction(sender: UIButton)
    {
        
    }
}
