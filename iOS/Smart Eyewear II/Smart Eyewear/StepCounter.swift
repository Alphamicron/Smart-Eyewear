//
//  StepCounter.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 7/11/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import Foundation

class StepCounter
{
    private var xAxes: [Double] = [Double]()
    private var yAxes: [Double] = [Double]()
    private var zAxes: [Double] = [Double]()
    private var rmsValues: [Double] = [Double]()
    
    init(graphPoints: GraphPoints)
    {
        xAxes = graphPoints.xAxes
        yAxes = graphPoints.yAxes
        zAxes = graphPoints.zAxes
        rmsValues = graphPoints.rmsValues
    }
    
    func numberOfSteps()-> Int
    {
        var pointMagnitudes: [Double] = rmsValues
        
        removeGravityEffectsFrom(&pointMagnitudes)
        
        let minimumPeakHeight: Double = standardDeviationOf(pointMagnitudes)
        
        // smoothes the points first before finding their peaks
        simpleMovingAverage(&pointMagnitudes, movingAverageWindow: 10)
        
        let peaks = findPeaks(&pointMagnitudes)
        
        var totalNumberOfSteps: Int = Int()
        
        for thisPeak in peaks
        {
            if thisPeak > minimumPeakHeight
            {
                totalNumberOfSteps += 1
            }
        }
        
        return totalNumberOfSteps
    }
    
    // TODO: dummy method for the time being. replaced with RMS values from controller itself
    private func calculateMagnitude()-> [Double]
    {
        var pointMagnitudes: [Double] = [Double]()
        
        for i in 0..<xAxes.count
        {
            let sumOfAxesSquare: Double = pow(xAxes[i], 2) + pow(yAxes[i], 2) + pow(zAxes[i], 2)
            pointMagnitudes.append(sqrt(sumOfAxesSquare))
        }
        
        return pointMagnitudes
    }
    
    private func removeGravityEffectsFrom(inout magnitudesWithGravityEffect: [Double])
    {
        let mean: Double = calculateMeanOf(rmsValues)
        
        for i in 0..<magnitudesWithGravityEffect.count
        {
            magnitudesWithGravityEffect[i] -= mean
        }
    }
    
    // Reference: https://en.wikipedia.org/wiki/Standard_deviation
    private func standardDeviationOf(magnitudes: [Double])-> Double
    {
        var sumOfElements: Double = Double()
        var mutableMagnitudes: [Double] = magnitudes
        
        // calculates the numerator of the equation
        /* no need to do (mutableMagnitudes[i] = mutableMagnitudes[i] - mean) 
         * because it has already been done when the gravity effect was removed
         * from the dataset
         */
        for i in 0..<mutableMagnitudes.count
        {
            mutableMagnitudes[i] = pow(mutableMagnitudes[i], 2)
        }
        
        // sum the elements
        for thisElement in mutableMagnitudes
        {
            sumOfElements += thisElement
        }
        
        let sampleVariance: Double = sumOfElements/Double(mutableMagnitudes.count)
        
        return sqrt(sampleVariance)
    }
    
    private func findPeaks(inout magnitudes: [Double])-> [Double]
    {
        var peaks: [Double] = [Double]()
        // only store initial point, if it is larger than the second. You can ignore in most data sets
        if max(magnitudes[0], magnitudes[1]) == magnitudes[0]
        {
            peaks.append(magnitudes[0])
        }
        
        for i in 1..<magnitudes.count - 2
        {
            let maxValue = max(magnitudes[i - 1], magnitudes[i], magnitudes[i + 1])
            // magnitudes[i] is a peak iff it's greater than it's surrounding points
            if maxValue == magnitudes[i]
            {
                peaks.append(magnitudes[i])
            }
        }
        
        return peaks
    }
    
    // A data smoothing algorithm.
    // Reference: https://en.wikipedia.org/wiki/Moving_average#Simple_moving_average
    private func simpleMovingAverage(inout magnitudes: [Double], movingAverageWindow: Int)
    {
        var count: Int = Int()
        var front: Int = Int()
        
        for currentSpot in movingAverageWindow...magnitudes.count
        {
            count = currentSpot - 1
            
            var sum: Double = Double()
            
            while count >= front
            {
                sum += magnitudes[count]
                
                count -= 1
            }
            
            let mean: Double = sum/Double(movingAverageWindow)
            magnitudes[front] = mean
            
            front += 1
        }
        
        // since no copies made, delete the untouched part of the array
        let rangeOfNumbersNotUsedInCalculation: Range = front..<magnitudes.count
        magnitudes.removeRange(rangeOfNumbersNotUsedInCalculation)
    }
    
    private func calculateMeanOf(magnitudes: [Double])-> Double
    {
        var sumOfElements: Double = Double()
        
        for thisElement in magnitudes
        {
            sumOfElements += thisElement
        }
        
        return sumOfElements/Double(magnitudes.count)
    }
}