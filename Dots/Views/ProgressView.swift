//
//  ProgressView.swift
//  Dots
//
//  Created by Eric de Quartel on 22/08/2022.
//

import SwiftUI
import StepperView

let authors = ["aap","noot","mies","kees"]

let steps = [ Text("BAL").font(.caption),
              Text("KAM").font(.caption),
              Text("AAP").font(.caption),
              Text("BOOM").font(.caption),
              Text("ROOS").font(.caption)]

let indicationTypes = [StepperIndicationType.custom(NumberedCircleView(text: "1")),
                       .custom(NumberedCircleView(text: "2")),
                       .custom(NumberedCircleView(text: "3")),
                       .custom(NumberedCircleView(text: "4")),
                       .custom(NumberedCircleView(text: "5"))]

let pitStopLineOptions = [
    StepperLineOptions.custom(1, Color.black),
    StepperLineOptions.custom(1, Color.black),
    StepperLineOptions.custom(1, Color.yellow),
    StepperLineOptions.custom(1, Color.black),
    StepperLineOptions.custom(1, Color.black)
]

struct ProgressView: View {
    @EnvironmentObject var settings: Settings
    private var countries: [Country] = Country.allCountries
    
    var stappen = [Text]()  
    
    var body: some View {
        NavigationView {
            Form{
                StepperView()
                    .addSteps(steps)
                    .indicators(indicationTypes)
                    .stepIndicatorMode(StepperMode.vertical)
                    .spacing(30)
                    .lineOptions(StepperLineOptions.custom(1, Colors.blue(.teal).rawValue))
            }
            .navigationTitle("Progress")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
