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
    
    //    private func findPeaks(inout magnitudes: [Double])-> [Double]
    //    {
    //        var peaks: [Double] = [Double]()
    //        
    //        // ignore the first element
    //        peaks.append(max(magnitudes[1], magnitudes[2]))
    //        
    //        for i in 2..<magnitudes.count
    //        {
    //            if i != magnitudes.count - 1
    //            {
    //                peaks.append(max(magnitudes[i], magnitudes[i - 1], magnitudes[i + 1]))
    //            }
    //            else
    //            {
    //                break
    //            }
    //        }
    //        
    //        // TODO:Does this affect the number of steps? Are they clumsly lost or foolishly added?
    //        peaks = Array(Set(peaks)) // removing duplicates.
    //        
    //        return peaks
    //    }
    
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