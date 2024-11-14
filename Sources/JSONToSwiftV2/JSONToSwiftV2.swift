// JSONToSwift.swift

import Foundation
import SwiftData

@available(macOS 14, *)
public func importData<T: Decodable, ModelType>(
    fileName: String,
    jsonType: T.Type,
    data: Data? = nil,
    dataMapper: (T) -> ModelType
) throws -> (Int, [ModelType]) {
    let jsonData: Data
    
    if let providedData = data {
        jsonData = providedData
    } else {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json"),
              let fileData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            throw ImportError.fileNotFound(fileName: fileName)
        }
        jsonData = fileData
    }
    
    do {
        // Decode the JSON data into an array of T
        let decodedDataArray = try JSONDecoder().decode([T].self, from: jsonData)
        
        // Map each decoded JSON object to your Swift model
        let models = decodedDataArray.map(dataMapper)
        return (models.count, models)
    } catch let decodingError as DecodingError {
        throw ImportError.jsonDecodingError(fileName: fileName, underlyingError: decodingError)
    }
}
