//
//  Monte Carlo Integration.swift
//  PHYS 440 Assignment 3.1
//
//  Created by Joshua Campbell  on 2/11/22.
//

import Foundation
import SwiftUI

class MonteCarlo: NSObject, ObservableObject {
    
    @MainActor @Published var underData = [(xPoint: Double, yPoint: Double)]()
    @MainActor @Published var aboveData = [(xPoint: Double, yPoint: Double)]()
    @Published var totalGuessesString = ""
    @Published var guessesString = ""
    @Published var eString = ""
    @Published var enableButton = true
    @Published var ErrorString = ""
    @Published var ActualString = ""
    
    var myfunc = 0.0
    var x = 0.0
    var guesses = 1
    var totalGuesses = 0
    var totalIntegral = 0.0
    var radius = 1.0
    var firstTimeThroughLoop = true
    
    @MainActor init(withData data: Bool){
        
        super.init()
        
        underData = []
        aboveData = []
        }
    

    /// Calculate the value of e^(-x) dx
    ///
    ///Calculates the value of e^(-x) dx using Monte Carlo Integration
    ///
    ///Parameter sender:  Any
    func calculatee() async {
        
        var maxGuesses = 0.0
        var actual = 0.0
        var FinalGuess = 0.0
        var Error = 0.0
        let boundingBoxCalculator = BoundingBox() /// Instantiates Class needed to calculate the area of the bounding box.
        
        maxGuesses = Double(guesses)
        
        let newValue = await calculateMonteCarloIntegral(radius: radius, maxGuesses: maxGuesses)
        
        totalIntegral = totalIntegral + newValue
        
        totalGuesses = totalGuesses + guesses
        
        await updateTotalGuessesString(text: "\(totalGuesses)")
        
        FinalGuess = totalIntegral/Double(totalGuesses)
        
        FinalGuess *= boundingBoxCalculator.calculateSurfaceArea(numberOfSides: 2, lengthOfSide1: 1.0, lengthOfSide2: 1.0, lengthOfSide3: 0.0)
        
        ///Calculate the error percentage
        actual = (exp(1)-1)/exp(1)
        
        await updateActualString(text: "\(actual)")
        Error = abs(log10((abs(( actual - FinalGuess))/actual)))
        await updateErrorString(text: "\(Error)")
        
        ///totalGuessesString = "\(totalGuesses)"
        
        ///Calculates e^(-x)
        
        
        
        await updateeString(text: "\(FinalGuess)")
        
    }

    func calculateMonteCarloIntegral(radius: Double, maxGuesses: Double) async -> Double {
        
        var numberOfGuesses = 0.0
        var pointsUnderCurve = 0.0
        var integral = 0.0
        var point = (xPoint: 0.0, yPoint: 0.0)
        var radiusPoint = 0.0
        
        var newUnderPoints : [(xPoint: Double, yPoint: Double)] = []
        var newAbovePoints : [(xPoint: Double, yPoint: Double)] = []
        
        while numberOfGuesses < maxGuesses {
            
            /* Calculate 2 random values within the box */
            
            
            point.xPoint = Double.random(in: 0...1)
            point.yPoint = Double.random(in: 0...1)
            /* Determine the distance from that point to the origin */
            radiusPoint = sqrt(pow(point.xPoint,2.0) + pow(point.yPoint,2.0))
            
            /* If y value is equal to or less than the y of the exponential, counts as being within the exponential */
            
            if((point.yPoint) <= exp(-point.xPoint)){
                pointsUnderCurve += 1.0
                
                newUnderPoints.append(point)
            }
            else{///if not under curve, we don't add to the number of points
                
                
                newAbovePoints.append(point)
                
            }
            
            numberOfGuesses += 1.0
            
    }

        integral = Double(pointsUnderCurve)
        
        if((totalGuesses < 500001) || (firstTimeThroughLoop)){
            
            //            insideData.append(contentsOf: newInsidePoints)
            //            outsideData.append(contentsOf: newOutsidePoints)
            
            
            var plotUnderPoints = newUnderPoints
            var plotAbovePoints = newAbovePoints
            
            if (newUnderPoints.count > 750001) {
                
                plotUnderPoints.removeSubrange(750001..<newUnderPoints.count)
            }
            
            if (newAbovePoints.count > 750001){
                plotAbovePoints.removeSubrange(750001..<newAbovePoints.count)
                
            }
            
            await updateData(underPoints: plotUnderPoints, abovePoints: plotAbovePoints)
            firstTimeThroughLoop = false
        }
            
        return integral
        }
    /// updateData
    /// The function runs on the main thread so it can update the GUI
    /// - Parameters:
    ///   - insidePoints: points under the curve of the given radius
    ///   - outsidePoints: points above the curve of the given radius
    @MainActor func updateData(underPoints: [(xPoint: Double, yPoint: Double)] , abovePoints: [(xPoint: Double, yPoint: Double)]){
        
        underData.append(contentsOf: underPoints)
        aboveData.append(contentsOf: abovePoints)
    }
    
    /// updateTotalGuessesString
    /// The function runs on the main thread so it can update the GUI
    /// - Parameter text: contains the string containing the number of total guesses
    @MainActor func updateTotalGuessesString(text:String){
        
        self.totalGuessesString = text
        
    }
    /// updateString
    /// The function runs on the main thread so it can update the GUI
    /// - Parameter text: contains the string containing the current value of e^-x
    @MainActor func updateeString(text:String){
        
        self.eString = text
    
        
    }
    @MainActor func updateErrorString(text:String){
        
        self.ErrorString = text
        
        
    }
    @MainActor func updateActualString(text:String){
        
        self.ActualString = text
    }

    /// setButton Enable
    /// Toggles the state of the Enable Button on the Main Thread
    /// - Parameter state: Boolean describing whether the button should be enabled.
    @MainActor func setButtonEnable(state: Bool){
        
        
        if state {
            
            Task.init {
                await MainActor.run {
                    
                    
                    self.enableButton = true
                }
            }
            
            
                
        }
        else{
            
            Task.init {
                await MainActor.run {
                    
                    
                    self.enableButton = false
                }
            }
                
        }
        
    }

}
