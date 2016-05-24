//
//  BatteryLevelVC.swift
//  Smart Eyewear
//
//  Created by Emil Shirima on 5/24/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit
import PNChart

class BatteryLevelVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()

        drawCircleGraph()
        
//        drawTwo()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawCircleGraph()
    {
        
        let circleFrame: CGRect = CGRect(x: self.view.bounds.size.width/2, y: self.view.bounds.size.width/5, width: self.view.bounds.size.width/65, height: self.view.bounds.size.height/2)
        let circleChart = PNCircleChart(frame: circleFrame, total: 100, current: 45, clockwise: true, shadow: true, shadowColor: UIColor.clearColor())

        circleChart.displayCountingLabel = true
        circleChart.lineWidth = 25
        circleChart.backgroundColor = UIColor.clearColor()
        circleChart.strokeColor = UIColor(red: 0.302, green: 0.769, blue: 0.478, alpha: 1.00)
        circleChart.strokeChart()
        
        self.view.addSubview(circleChart)
    }
    
    func drawTwo()
    {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.view.bounds.size.width/2,y: self.view.bounds.size.width/2), radius: CGFloat(100), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor(red: 0.302, green: 0.769, blue: 0.478, alpha: 1.00).CGColor
        //you can change the line width
        shapeLayer.lineWidth = 10
        
        view.layer.addSublayer(shapeLayer)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
