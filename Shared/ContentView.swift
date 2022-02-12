//
//  ContentView.swift
//  Shared
//
//  Created by Joshua Campbell  on 2/11/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var myfunc = 0.0
    @State var x = 0.0
    @State var totalGuesses = 0.0
    @State var totalIntegral = 0.0
    @State var radius = 1.0
    @State var guessString = "23458"
    @State var totalGuessString = "0"
    @State var eString = "0.0"
    @State var ErrorString = "0.0"
    @State var ActualString = "0.0"
    
    
    // Setup the GUI to monitor the data from the Monte Carlo Integral Calculator
    @ObservedObject var monteCarlo = MonteCarlo(withData: true)
    
    
    //Setup the GUI View
    var body: some View {
        HStack{
            
            VStack{
                
                VStack(alignment: .center) {
                    Text("Guesses")
                        .font(.callout)
                        .bold()
                    TextField("# Guesses", text: $guessString)
                        .padding()
                }
                .padding(.top, 5.0)
                
                VStack(alignment: .center) {
                    Text("Total Guesses")
                        .font(.callout)
                        .bold()
                    TextField("# Total Guesses", text: $totalGuessString)
                        .padding()
                }
                
                VStack(alignment: .center) {
                    Text("e")
                        .font(.callout)
                        .bold()
                    TextField("# e", text: $eString)
                        .padding()
                }
                VStack(alignment: .center) {
                    Text("Actual Value")
                        .font(.callout)
                        .bold()
                    TextField("Actual", text: $ActualString)
                        .padding()
                }
                
                VStack(alignment: .center) {
                    Text("Error")
                        .font(.callout)
                        .bold()
                    TextField("error%", text: $ErrorString)
                        .padding()
                }
               
                Button("Cycle Calculation", action: {Task.init{await self.calculateE()}})
                    .padding()
                    .disabled(monteCarlo.enableButton == false)
                
                Button("Clear", action: {self.clear()})
                    .padding(.bottom, 5.0)
                    .disabled(monteCarlo.enableButton == false)
                
                if (!monteCarlo.enableButton){
                    
                    ProgressView()
                }
                
                
            }
            .padding()
            
            //DrawingField
            
            
            drawingView(redLayer:$monteCarlo.underData, blueLayer: $monteCarlo.aboveData)
                .padding()
                .aspectRatio(1, contentMode: .fit)
                .drawingGroup()
            // Stop the window shrinking to zero.
            Spacer()
            
        }
    }
    
    func calculateE() async {
        
        
        monteCarlo.setButtonEnable(state: false)
        
        monteCarlo.guesses = Int(guessString)!
        monteCarlo.radius = radius
        monteCarlo.totalGuesses = Int(totalGuessString) ?? Int(0.0)
        
        await monteCarlo.calculatee()
        
        totalGuessString = monteCarlo.totalGuessesString
        
        eString =  monteCarlo.eString
        
        ErrorString = monteCarlo.ErrorString
        
        ActualString = monteCarlo.ActualString
        
        monteCarlo.setButtonEnable(state: true)
        
    }
    
    func clear(){
        
        guessString = "23458"
        totalGuessString = "0.0"
        eString =  ""
        ErrorString = ""
        monteCarlo.totalGuesses = 0
        monteCarlo.totalIntegral = 0.0
        monteCarlo.underData = []
        monteCarlo.aboveData = []
        monteCarlo.firstTimeThroughLoop = true
        
        
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
