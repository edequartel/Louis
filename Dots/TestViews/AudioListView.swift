import SwiftUI


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
    @State private var characters = "abkl"
    @State private var minLength  = "0"
    @State private var maxLength  = "10"
    
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
            
            List(getMP3Files(atPath: "dutch/words", containingCharacters: characters, minLength: Int(minLength), maxLength: Int(maxLength)), id: \.self) { fileName in
                Text(fileName)
            }
        }
    }
}


struct AudioListView_Previews: PreviewProvider {
    static var previews: some View {
        AudioListView()
    }
}
