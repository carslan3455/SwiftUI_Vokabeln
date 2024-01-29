import SwiftUI

struct ContentView: View {
    @State private var germanWord = ""
    @State private var englishWord = ""
    @State private var vocabList = [String]()

    var body: some View {
        VStack {
            HStack {
                TextField("Deutsches Wort", text: $germanWord)
                TextField("Englisches Wort", text: $englishWord)
                Button("Speichern", action: saveVocabPair)
            }
            List(vocabList, id: \.self) { pair in
                Text(pair)
            }
            Spacer()
        }
    }

    func saveVocabPair() {
        guard !germanWord.isEmpty && !englishWord.isEmpty else {
            return
        }

        let vocabPair = "\(germanWord)-\(englishWord)"
        vocabList.append(vocabPair)

        // Optional: Datei speichern
        saveToFile(vocabPair: vocabPair)
        
        // Felder leeren
        germanWord = ""
        englishWord = ""
    }

    func saveToFile(vocabPair: String) {
        // Dateipfad
        let filePath = getDocumentsDirectory().appendingPathComponent("vocab.txt")

        do {
            // Daten an Datei anhängen
            try "\(vocabPair)\n".appendToURL(fileURL: filePath, atomically: true, encoding: .utf8)
        } catch {
            print("Fehler beim Speichern der Datei: \(error.localizedDescription)")
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension String {
    func appendToURL(fileURL: URL, atomically: Bool, encoding: String.Encoding) throws {
        let data = self.data(using: encoding)!
        try data.appendToURL(fileURL: fileURL, atomically: atomically)
    }
}

extension Data {
    func appendToURL(fileURL: URL, atomically: Bool) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        } else {
            try write(to: fileURL, options: .atomic)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
