import SwiftUI


//struct TestView: View {
//    let str = "schakelaar"
//    let separators = ["eeuw","sch","eeu","ij","ooi","aa","ui","oo","eu","ei"] //long sounds
//
//
//    var body: some View {
//        Button("Split") {
////            let splitArray = recursiveSplit(str, by: separators)
////            print(splitArray) // Output: [(false, "l"), (true, "eeu"), (false, ""), (true, "a"), (false, "w")]
//            let outputStr = recursiveConcatenate(str, by: separators)
//            print(outputStr)
//        }
//    }
//}

func recursiveSplit(_ str: String, by separators: [String]) -> [(isSeparator: Bool, value: String)] {
    guard !separators.isEmpty else {
        let chars = Array(str)
        let values = chars.map { String($0) }
        let tuples = values.map { (isSeparator: false, value: $0) }
        return tuples
    }
    
    let firstSeparator = separators[0]
    let remainingSeparators = Array(separators.dropFirst())
    
    let components = str.components(separatedBy: firstSeparator)
    let splitComponents = components.map { recursiveSplit($0, by: remainingSeparators) }
    
    var result: [(isSeparator: Bool, value: String)] = []
    for i in 0..<splitComponents.count {
        if i > 0 {
            result.append((isSeparator: true, value: firstSeparator))
        }
        let component = splitComponents[i]
        if !component.isEmpty {
            if component.count == 1 && !component[0].isSeparator {
                result.append(component[0])
            } else {
                result.append(contentsOf: component)
            }
        }
    }
    
    return result
}

func recursiveConcatenate(_ str: String, by separators: [String]) -> String {
    let splitArray = recursiveSplit(str, by: separators)
    return splitArray.map { $0.value }.joined(separator: "-")
}

//-----------------------------------------------------------------------------------

func getMP3Files(atPath path: String, containingCharacters characters: String, minLength: Int? = nil, maxLength: Int? = nil) -> [String] {
    let fileManager = FileManager.default
    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
        fatalError("Could not locate Documents directory")
    }
    let directoryPath = documentsDirectory.appendingPathComponent(path)
    let mp3Files = try! fileManager.contentsOfDirectory(atPath: directoryPath.path)
        .filter { $0.hasSuffix(".mp3") }
        .map { $0.replacingOccurrences(of: ".mp3", with: "") }
        .filter { name in
            let filterNames = filterNamesWithCharacters([name], characters: characters)
            return !filterNames.isEmpty &&
                (minLength == nil || name.count >= minLength!) &&
                (maxLength == nil || name.count <= maxLength!)
        }
    return mp3Files
}


func filterNamesWithCharacters(_ names: [String], characters: String) -> [String] {
    let filterSet = Set(characters)

    let filteredNames = names.filter { name in
        let nameSet = Set(name)

        return nameSet.isSubset(of: filterSet) && filterSet.isSuperset(of: nameSet)
    }
    return filteredNames
}


struct AudioListView: View {
    @EnvironmentObject var viewModel: LouisViewModel
    @State private var characters = "abkl"
    @State private var minLength  = "0"
    @State private var maxLength  = "10"
    
    let separators = ["eeuw","sch","eeu","ij","ooi","oei","aa","ui","oo","eu","ei","ie","ee","oe"] //long sounds
    //
    
    var body: some View {
        VStack {
            HStack {
                TextField("Filter", text: $characters)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                TextField("Minimum length", text: $minLength)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Maximum length", text: $maxLength)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            List(getMP3Files(atPath: "\(viewModel.Languages[viewModel.indexLanguage].zip)/words", containingCharacters: characters, minLength: Int(minLength), maxLength: Int(maxLength)), id: \.self) { fileName in
                HStack {
                    Text(fileName)
                    Spacer()
                    Text(recursiveConcatenate(fileName, by: separators))
                }
            }
        }
    }
}


struct AudioListView_Previews: PreviewProvider {
    static var previews: some View {
        AudioListView()
    }
}
