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
    
    init(graphPoints: GraphPoints)
    {
        xAxes = GraphPoints.xAxes
        yAxes = GraphPoints.yAxes
        zAxes = GraphPoints.zAxes
    }
    
    func numberOfSteps()-> Int
    {
        var magnitude = calculateMagnitude()
        
        removeGravityEffectsFrom(&magnitude)
        
        let minimumPeakHeight: Double = standardDeviationOf(magnitude)
        
        let peaks = findPeaks(&magnitude)
        
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
        for i in 0..<magnitudesWithGravityEffect.count
        {
            let mean: Double = (xAxes[i] + yAxes[i] + zAxes[i])/3
            
            magnitudesWithGravityEffect[i] -= mean
        }
    }
    
    // Reference: https://en.wikipedia.org/wiki/Standard_deviation
    private func standardDeviationOf(magnitudes: [Double])-> Double
    {
        var sumOfElements: Double = Double()
        var mutableMagnitudes: [Double] = magnitudes
        
        let mean = calculateMeanOf(magnitudes)
        
        // calculate the numerator of the equation without the sqrt
        for i in 0..<mutableMagnitudes.count
        {
            mutableMagnitudes[i] = mutableMagnitudes[i] - mean
            mutableMagnitudes[i] = pow(mutableMagnitudes[i], 2)
        }
        
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
        
        // ignore the first element
        peaks.append(max(magnitudes[1], magnitudes[2]))
        
        for i in 2..<magnitudes.count
        {
            if i != magnitudes.count - 1
            {
                peaks.append(max(magnitudes[i], magnitudes[i - 1], magnitudes[i + 1]))
            }
            else
            {
                break
            }
        }
        
        // removing duplicates. TODO:Does this affect the number of steps? Or result into some steps from being missed?
        peaks = Array(Set(peaks))
        
        return peaks
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