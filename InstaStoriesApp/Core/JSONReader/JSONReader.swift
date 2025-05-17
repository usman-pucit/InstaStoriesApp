import Foundation

enum JSONError: Error {
    case fileNotFound
    case decodingError
    case invalidData
}

protocol JSONReaderType {
    func load<T: Decodable>(_ filename: String) throws -> T
}

// MARK: - JSONReader
struct JSONReader: JSONReaderType {
    func load<T: Decodable>(_ filename: String) throws -> T {
        guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw JSONError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw JSONError.decodingError
        }
    }
} 
