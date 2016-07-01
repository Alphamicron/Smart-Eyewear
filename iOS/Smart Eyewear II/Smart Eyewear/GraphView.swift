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
    let xAxisScale: CGFloat = 2.0
    let yAxisScale: CGFloat = 2.0
    var timer: dispatch_source_t?
    var globalYOffset: CGFloat = CGFloat()
    
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
        let maxDimension: CGFloat = self.bounds.size.width
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
        
        let ctx1: CGContextRef = UIGraphicsGetCurrentContext()!
        let ctx2: CGContextRef = UIGraphicsGetCurrentContext()!
        let ctx3: CGContextRef = UIGraphicsGetCurrentContext()!
        
        CGContextSetStrokeColorWithColor(ctx1, Constants.themeGreenColour.CGColor)
        CGContextSetStrokeColorWithColor(ctx2, Constants.themeRedColour.CGColor)
        CGContextSetStrokeColorWithColor(ctx3, Constants.themeYellowColour.CGColor)
        
        CGContextSetLineJoin(ctx1, .Round)
        CGContextSetLineJoin(ctx2, .Round)
        CGContextSetLineJoin(ctx3, .Round)
        
        CGContextSetLineWidth(ctx1, 3)
        CGContextSetLineWidth(ctx2, 3)
        CGContextSetLineWidth(ctx3, 3)
        
        let path1: CGMutablePathRef = CGPathCreateMutable()
        let path2: CGMutablePathRef = CGPathCreateMutable()
        let path3: CGMutablePathRef = CGPathCreateMutable()
        
        let yOffset: CGFloat = self.bounds.size.height / 2
        var transform: CGAffineTransform = CGAffineTransformMakeScaleTranslate(xAxisScale, sy: yAxisScale, dx: 0, dy: yOffset)
        globalYOffset = yOffset
        
        // draw the x-axis
        //        CGPathMoveToPoint(path1, &transform, 0, 0)
        //        CGPathAddLineToPoint(path1, &transform, self.bounds.size.width, 0)
        
        // draw the first point initially
        var sensorXValue: CGFloat = CGFloat(GraphsVC.sensorReadings.objectAtIndex(0).x)
        var sensorYValue: CGFloat = CGFloat(GraphsVC.sensorReadings.objectAtIndex(0).y)
        var sensorZValue: CGFloat = CGFloat(GraphsVC.sensorReadings.objectAtIndex(0).z)
        
        CGPathMoveToPoint(path1, &transform, 0, sensorXValue)
        CGPathMoveToPoint(path2, &transform, 0, sensorYValue)
        CGPathMoveToPoint(path3, &transform, 0, sensorZValue)
        
        //        self.drawAtPoint(point(0, y: sensorXValue), withTitle: valueTitle(0), sensorAxis: SensorAxes.xAxis)
        //        self.drawAtPoint(point(0, y: sensorYValue), withTitle: valueTitle(0), sensorAxis: SensorAxes.yAxis)
        //        self.drawAtPoint(point(0, y: sensorZValue), withTitle: valueTitle(0), sensorAxis: SensorAxes.zAxis)
        
        // then draw the remaining points
        for readingPosition in 1 ..< GraphsVC.sensorReadings.count
        {
            sensorXValue = CGFloat(GraphsVC.sensorReadings.objectAtIndex(readingPosition).x)
            sensorYValue = CGFloat(GraphsVC.sensorReadings.objectAtIndex(readingPosition).y)
            sensorZValue = CGFloat(GraphsVC.sensorReadings.objectAtIndex(readingPosition).z)
            
            CGPathAddLineToPoint(path1, &transform, CGFloat(readingPosition), sensorXValue)
            CGPathAddLineToPoint(path2, &transform, CGFloat(readingPosition), sensorYValue)
            CGPathAddLineToPoint(path3, &transform, CGFloat(readingPosition), sensorZValue)
            
            //            self.drawAtPoint(point(CGFloat(readingPosition), y: sensorXValue), withTitle: valueTitle(readingPosition), sensorAxis: SensorAxes.xAxis)
            //            self.drawAtPoint(point(CGFloat(readingPosition), y: sensorYValue), withTitle: valueTitle(readingPosition), sensorAxis: SensorAxes.yAxis)
            //            self.drawAtPoint(point(CGFloat(readingPosition), y: sensorZValue), withTitle: valueTitle(readingPosition), sensorAxis: SensorAxes.zAxis)
        }
        
        CGContextAddPath(ctx1, path1)
        CGContextAddPath(ctx2, path2)
        CGContextAddPath(ctx3, path3)
        
        CGContextStrokePath(ctx1)
        CGContextStrokePath(ctx2)
        CGContextStrokePath(ctx3)
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
        return CGPointMake(x * xAxisScale, globalYOffset + y * yAxisScale)
        
        //        return CGPointMake(x * xAxisScale, y * yAxisScale)
    }
}