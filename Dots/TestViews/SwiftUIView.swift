import SwiftUI

struct SwiftUIView: View {
    @State private var filterCharacters = "aeiou"
    @State private var filteredNames = [String]()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Filter characters", text: $filterCharacters)
                    .padding()
                    .onChange(of: filterCharacters) { newValue in
                        filterNames()
                    }
                    .autocapitalization(.none)
                
                if filteredNames.isEmpty {
                    Text("No words found")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    List(filteredNames.sorted(), id: \.self) { name in
                        Text(name)
                    }
                }
            }
            .navigationTitle("Filtered Words")
            .onAppear {
                filterNames()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func filterNames() {
        let audioPath = getAudioPath()

        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(atPath: audioPath.path)

            let fileNamesWithoutExtension = getFileNamesWithoutExtension(from: directoryContents)

            filteredNames = filterNamesWithCharacters(fileNamesWithoutExtension, characters: filterCharacters)

        } catch {
            fatalError("Could not get contents of \(audioPath.path) folder: \(error.localizedDescription)")
        }
    }

    private func getAudioPath() -> URL {
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Could not get documents directory path")
        }

        let audioPath = documentsPath.appendingPathComponent("dutch/words")

        return audioPath
    }

    private func getFileNamesWithoutExtension(from directoryContents: [String]) -> [String] {
        directoryContents
            .compactMap { URL(string: $0)?.deletingPathExtension().lastPathComponent }
    }

    private func filterNamesWithCharacters(_ names: [String], characters: String) -> [String] {
        let filterSet = Set(characters)

        let filteredNames = names.filter { name in
            let nameSet = Set(name)

            return nameSet.isSubset(of: filterSet) && filterSet.isSuperset(of: nameSet)
        }

        return filteredNames
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
