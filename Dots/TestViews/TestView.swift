//
//  libLouisView.swift
//  
//
//  Created by Eric de Quartel on 11/03/2023.
//

import SwiftUI


struct TestView: View {
    let str = "schakelaar"
    let separators = ["eeuw","sch","eeu","ij","ooi","aa","ui","oo","eu","ei"] //long sounds
    
    
    var body: some View {
        Button("Split") {
//            let splitArray = recursiveSplit(str, by: separators)
//            print(splitArray) // Output: [(false, "l"), (true, "eeu"), (false, ""), (true, "a"), (false, "w")]
            let outputStr = recursiveConcatenate(str, by: separators)
            print(outputStr)
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
