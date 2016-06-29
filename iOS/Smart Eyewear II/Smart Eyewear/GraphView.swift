//
//  GraphView.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 6/28/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

//  Credits to easyui https://goo.gl/4GZmTH

import UIKit

class GraphView: UIView
{
    let xAxisScale: CGFloat = 20.0
    let yAxisScale: CGFloat = 50.0
    var timer: dispatch_source_t?
    var generalYOffset: CGFloat = CGFloat()
    
    func CGAffineTransformMakeScaleTranslate(sx: CGFloat, sy:CGFloat, dx: CGFloat, dy: CGFloat) -> CGAffineTransform
    {
        return CGAffineTransformMake(sx, 0.0, 0.0, sy, dx, dy)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    deinit
    {
        dispatch_source_cancel(timer!)
    }
    
    override func awakeFromNib()
    {
        self.contentMode = .Right
        GraphsVC.sensorReadings = NSMutableArray()
        weak var weakSelf: AnyObject? = self
        let delayInSeconds: Float = 0.25
        
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue())
        dispatch_source_set_timer(timer!, dispatch_walltime(nil, 0), UInt64(delayInSeconds * Float(NSEC_PER_SEC)), 0)
        dispatch_source_set_event_handler(timer!, {() -> Void in
            
            weakSelf!.updateValues()
        })
        
        dispatch_resume(timer!)
    }
    
    func updateValues()
    {
        let size: CGSize = self.bounds.size
        let maxDimension: CGFloat = size.width
        let maxValue: Int = Int(floor(maxDimension / xAxisScale))
        
        if GraphsVC.sensorReadings.count > maxValue
        {
            GraphsVC.sensorReadings.removeObjectsInRange(NSMakeRange(0, GraphsVC.sensorReadings.count - maxValue))
        }
        
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect)
    {
        if GraphsVC.sensorReadings.count == 0
        {
            return
        }
        
        let ctx: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetStrokeColorWithColor(ctx, Constants.themeGreenColour.CGColor)
        CGContextSetLineJoin(ctx, .Round)
        CGContextSetLineWidth(ctx, 3)
        
        let path: CGMutablePathRef = CGPathCreateMutable()
        let yOffset: CGFloat = self.bounds.size.height / 2
        generalYOffset = yOffset
        var transform: CGAffineTransform = CGAffineTransformMakeScaleTranslate(xAxisScale, sy: yAxisScale, dx: 0, dy: yOffset)
        
        // draw the x-axis
        //        CGPathMoveToPoint(path, &transform, 0, 0)
        //        CGPathAddLineToPoint(path, &transform, self.bounds.size.width, 0)
        
        // draw the x-value points initially
        var sensorXValue: CGFloat = CGFloat(GraphsVC.sensorReadings.objectAtIndex(0).x)
        CGPathMoveToPoint(path, &transform, 0, sensorXValue)
        self.drawAtPoint(point(0, y: sensorXValue), withTitle: valueTitle(0), sensorAxis: SensorAxes.xAxis)
        
        // draw the y-value points initially
        var sensorYValue: CGFloat = CGFloat(GraphsVC.sensorReadings.objectAtIndex(0).y)
        CGPathMoveToPoint(path, &transform, 0, sensorYValue)
        self.drawAtPoint(point(0, y: sensorYValue), withTitle: valueTitle(0), sensorAxis: SensorAxes.yAxis)
        
        // draw the z-value points initially
        var sensorZValue: CGFloat = CGFloat(GraphsVC.sensorReadings.objectAtIndex(0).z)
        CGPathMoveToPoint(path, &transform, 0, sensorZValue)
        self.drawAtPoint(point(0, y: sensorZValue), withTitle: valueTitle(0), sensorAxis: SensorAxes.zAxis)
        
        // then draw the remaining points
        for readingPosition in 1 ..< GraphsVC.sensorReadings.count
        {
            sensorXValue = CGFloat(GraphsVC.sensorReadings.objectAtIndex(readingPosition).x)
            sensorYValue = CGFloat(GraphsVC.sensorReadings.objectAtIndex(readingPosition).y)
            sensorZValue = CGFloat(GraphsVC.sensorReadings.objectAtIndex(readingPosition).z)
            
            CGPathAddLineToPoint(path, &transform, CGFloat(readingPosition), sensorXValue)
            CGPathAddLineToPoint(path, &transform, CGFloat(readingPosition), sensorYValue)
            CGPathAddLineToPoint(path, &transform, CGFloat(readingPosition), sensorZValue)
            
            self.drawAtPoint(point(CGFloat(readingPosition), y: sensorXValue), withTitle: valueTitle(readingPosition), sensorAxis: SensorAxes.xAxis)
            self.drawAtPoint(point(CGFloat(readingPosition), y: sensorYValue), withTitle: valueTitle(readingPosition), sensorAxis: SensorAxes.yAxis)
            self.drawAtPoint(point(CGFloat(readingPosition), y: sensorZValue), withTitle: valueTitle(readingPosition), sensorAxis: SensorAxes.zAxis)
        }
        
        CGContextAddPath(ctx, path)
        CGContextStrokePath(ctx)
    }
    
    func drawAtPoint(point: CGPoint, withTitle newTitle: String, sensorAxis: SensorAxes)
    {
        var axisColour: UIColor = UIColor()
        
        switch sensorAxis
        {
        case .xAxis:
            axisColour = Constants.themeGreenColour
        case .yAxis:
            axisColour = Constants.themeRedColour
        case .zAxis:
            axisColour = Constants.themeYellowColour
        case .RMS:
            axisColour = Constants.themeInactiveStateColour
        }
        
        newTitle.drawAtPoint(point, withAttributes: [NSFontAttributeName: Constants.defaultFont.fontWithSize(8), NSStrokeColorAttributeName: axisColour])
    }
    
    // converts the point to a string inorder to present to the graph
    func valueTitle(index: Int)-> String
    {
        return String(format: "%.f", CGFloat(GraphsVC.sensorReadings.objectAtIndex(index).x) * yAxisScale)
    }
    
    func point(x: CGFloat, y: CGFloat)-> CGPoint
    {
        return CGPointMake(x * xAxisScale, generalYOffset + y * yAxisScale)
    }
}