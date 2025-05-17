import Foundation

enum JSONError: Error, LocalizedError {
    case fileNotFound
    case decodingError
    case invalidData
    
    public var errorDescription: String? {
        switch self {
        case .fileNotFound:
            "The file was not found."
        case .decodingError:
            "Failed to decode the JSON data."
        case .invalidData:
            "Unexpected data format."
        }
    }
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
