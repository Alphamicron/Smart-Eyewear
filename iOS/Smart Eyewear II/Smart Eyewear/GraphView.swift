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
    let graphColour: UIColor = Constants.themeGreenColour
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
        CGContextSetStrokeColorWithColor(ctx, graphColour.CGColor)
        CGContextSetLineJoin(ctx, .Round)
        CGContextSetLineWidth(ctx, 3)
        
        let path: CGMutablePathRef = CGPathCreateMutable()
        let yOffset: CGFloat = self.bounds.size.height / 2
        generalYOffset = yOffset
        var transform: CGAffineTransform = CGAffineTransformMakeScaleTranslate(xAxisScale, sy: yAxisScale, dx: 0, dy: yOffset)
        
        // draw the x-axis
        //        CGPathMoveToPoint(path, &transform, 0, 0)
        //        CGPathAddLineToPoint(path, &transform, self.bounds.size.width, 0)
        
        // draw the first point initially
        var y: CGFloat = CGFloat(GraphsVC.sensorReadings.objectAtIndex(0).x)
        CGPathMoveToPoint(path, &transform, 0, y)
        self.drawAtPoint(point(0, y: y), withTitle: valueTitle(0))
        
        // then draw the remaining points
        for readingPosition in 1 ..< GraphsVC.sensorReadings.count
        {
            y = CGFloat(GraphsVC.sensorReadings.objectAtIndex(readingPosition).x)
            
            CGPathAddLineToPoint(path, &transform, CGFloat(readingPosition), y)
            self.drawAtPoint(point(CGFloat(readingPosition), y: y), withTitle: valueTitle(readingPosition))
        }
        
        CGContextAddPath(ctx, path)
        CGContextStrokePath(ctx)
    }
    
    func drawAtPoint(point: CGPoint, withTitle newTitle: String)
    {
        newTitle.drawAtPoint(point, withAttributes: [NSFontAttributeName: Constants.defaultFont.fontWithSize(8), NSStrokeColorAttributeName: graphColour])
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