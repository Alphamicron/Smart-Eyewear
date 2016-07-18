//
//  StepCounter.swift
//  Smart Eyewear
//
//  Created by Alphamicron on 7/11/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import Foundation

/**************************************************************
 +------------------------------------------------------------+
 | Name: StepCounter                                          |
 | Purpose: Count number of steps from accelerometer data     |
 | Inputs: X,Y,Z and RMS values                               |
 | Outputs: Total number of steps, distance and speed         |
 | Throws: Poop                                               |
 +------------------------------------------------------------+
 **************************************************************/

class StepCounter
{
    private var xAxes: [Double] = [Double]()
    private var yAxes: [Double] = [Double]()
    private var zAxes: [Double] = [Double]()
    private var rmsValues: [Double] = [Double]()
    
    private var totalNumberOfSteps: Int = Int()
    private var speedTravelled: Double = Double()
    private var totalDistanceTravelled: Double = Double()
    
    private let userHeight: Double = ({
        
        let feet: Double = 5.0
        let inches: Double = 8.0
        
        return feet + (inches/12.0)
        }())
    
    init(inout graphPoints: GraphPoints)
    {
        xAxes = graphPoints.xAxes
        yAxes = graphPoints.yAxes
        zAxes = graphPoints.zAxes
        rmsValues = graphPoints.rmsValues
    }
    
    func numberOfSteps()-> (totalSteps: Int, distanceInFeet: Double)
    {
        var pointMagnitudes: [Double] = rmsValues
        
        removeGravityEffectsFrom(&pointMagnitudes)
        
        let minimumPeakHeight: Double = standardDeviationOf(pointMagnitudes)
        
        // smoothes the points first before finding their peaks
        // the window is adviced to be an odd number
        simpleMovingAverage(&pointMagnitudes, movingAverageWindow: 5)
        
        let peaks = findPeaks(&pointMagnitudes)
        
        for thisPeak in peaks
        {
            if thisPeak > minimumPeakHeight
            {
                totalNumberOfSteps += 1
            }
        }
        
        // calculate the distance travelled
        distanceTravelled()
        
        return (totalNumberOfSteps, totalDistanceTravelled)
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
    
    // Finds local maxima of given points
    // Complexity: O(n)
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
    // Complexity: O(n squared)
    private func simpleMovingAverage(inout magnitudes: [Double], movingAverageWindow: Int)
    {
        var count: Int = Int(), front: Int = Int()
        
        for currentSpot in movingAverageWindow...magnitudes.count
        {
            count = currentSpot - 1
            
            var sumOfElements: Double = Double()
            
            // sum up all the elements before and including count
            while count >= front
            {
                sumOfElements += magnitudes[count]
                
                count -= 1
            }
            
            // replace it with the average
            magnitudes[front] = sumOfElements/Double(movingAverageWindow)
            
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
    
    // PRE:  Non zero values entered as range
    // POST: Random number between [firstNumber, secondNumber] of 'points' decimal points
    private func generateRandomNumber(from firstNumber: Double, to secondNumber: Double, decimalPoints points: Double)-> Double
    {
        let factor: Double = pow(10, points)
        
        // convert them to whole numbers
        let first: UInt32 = UInt32(firstNumber * factor)
        let second: UInt32 = UInt32(secondNumber * factor)
        
        // get number between the whole numbers
        let randomNumber: Double = Double(arc4random_uniform(second - first + 1) + first)
        
        // division for 'points' d.p precision
        return randomNumber/factor
    }
    
    private func distanceTravelled()
    {
        // assumed that a user's step is (0.4-0.5) their height
        let stepLengthFactor: Double = generateRandomNumber(from: 0.4, to: 0.5, decimalPoints: 4)
        
        totalDistanceTravelled = Double(totalNumberOfSteps) * userHeight * stepLengthFactor
    }
}