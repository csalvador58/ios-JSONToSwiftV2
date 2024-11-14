// ImportError.swift
enum ImportError: Error, Equatable {
    case fileNotFound(fileName: String)
    case jsonDecodingError(fileName: String, underlyingError: Error)
    case saveError(message: String)
    
    var localizedDescription: String {
        switch self {
        case .fileNotFound(let fileName):
            return "Failed to load \(fileName).json from the main bundle."
        case .jsonDecodingError(let fileName, let underlyingError):
            return "Failed to decode \(fileName).json: \(underlyingError.localizedDescription)"
        case .saveError(let message):
            return "Failed to save context: \(message)"
        }
    }
    
    // Equatable conformance to allow comparisons
    static func == (lhs: ImportError, rhs: ImportError) -> Bool {
        switch (lhs, rhs) {
        case (.fileNotFound(let fileName1), .fileNotFound(let fileName2)):
            return fileName1 == fileName2
        case (.jsonDecodingError(let fileName1, _), .jsonDecodingError(let fileName2, _)):
            return fileName1 == fileName2
        case (.saveError(let message1), .saveError(let message2)):
            return message1 == message2
        default:
            return false
        }
    }
}
