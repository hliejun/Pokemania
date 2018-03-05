//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import Foundation

enum FileName: String {
    case levels, customLevels, presets, none
}

class Storage {

    static func read<T: Codable>(_ fileName: FileName, as type: T.Type) -> T? {
        let url = getFileUrl(for: fileName)
        if !fileExists(at: url) {
            return nil
        }
        guard let file = FileManager.default.contents(atPath: url.path) else {
            fatalError("Fatal: Cannot read file data from file.")
        }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(type, from: file)
        } catch {
            return nil
        }
    }

    static func write<T: Codable>(_ object: T, to fileName: FileName) {
        let url = getFileUrl(for: fileName)
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(object)
            if fileExists(at: url) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: jsonData, attributes: nil)
        } catch {
            fatalError("Fatal: Object cannot be encoded or written to file. \(error.localizedDescription)")
        }
    }

    static func fileExists(at url: URL? = nil, _ fileName: FileName = .none) -> Bool {
        let filePath = url?.path ?? getFileUrl(for: fileName).path
        return FileManager.default.fileExists(atPath: filePath)
    }

    static func getFileUrl(for fileName: FileName) -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentDirectory.appendingPathComponent("\(fileName).enc")
    }

    static func getImagePath(for fileName: String) -> String {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentDirectory.appendingPathComponent("\(fileName).png").path
    }

}
