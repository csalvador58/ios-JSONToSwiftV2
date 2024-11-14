import Testing
import Foundation
@testable import JSONToSwiftV2

struct MockModel: Decodable {
    let id: String
    let name: String
}

struct IngredientsJSON: Decodable {
    let id: String
    let name: String
}

struct Ingredient {
    let id: UUID
    let name: String
}

func mapIngredients(json: IngredientsJSON) -> Ingredient {
    return Ingredient(
        id: UUID(uuidString: json.id) ?? UUID(),
        name: json.name
    )
}

@Suite("JSON to Swift Conversion Tests") final class JSONToSwiftV2Tests {
    @Suite("Data Import") struct ImportTests {
        // Using a more descriptive test label with proper formatting
        @Test("Given valid JSON data, should successfully import and map ingredients")
        @available(macOS 14, *)
        func testImportSuccess() {
            let validJSONData = """
            [
                { "id": "1", "name": "Ingredient A" },
                { "id": "2", "name": "Ingredient B" }
            ]
            """.data(using: .utf8)!
            
            var expectedError: ImportError? = nil
            
            do {
                let (count, models) = try importData(
                    fileName: "validFile",
                    jsonType: IngredientsJSON.self,
                    data: validJSONData,
                    dataMapper: mapIngredients
                )
                #expect(count == 2)
                #expect(models.count == 2)
                #expect(models[0].name == "Ingredient A")
                #expect(models[1].name == "Ingredient B")
            } catch {
                expectedError = error as? ImportError
            }
            #expect(expectedError == nil)
        }
        
        @Test("Given non-existent file name, should throw file not found error")
        @available(macOS 14, *)
        func testFileNotFound() {
            do {
                _ = try importData(
                    fileName: "nonExistentFile",
                    jsonType: MockModel.self,
                    dataMapper: { _ in MockModel(id: "0", name: "Mock") }
                )
                #expect(Bool(false), "Expected to throw fileNotFound error, but no error was thrown")
            } catch let error as ImportError {
                #expect(error == .fileNotFound(fileName: "nonExistentFile"))
            } catch {
                #expect(Bool(false), "Unexpected error: \(error)")
            }
        }
        
        @Test("Given invalid JSON structure, should throw JSON decoding error")
        @available(macOS 14, *)
        func testJSONDecoding() {
            let invalidJSONData = """
            [
                { "unexpected_field": "value" }
            ]
            """.data(using: .utf8)!
            
            do {
                _ = try importData(
                    fileName: "invalidFile",
                    jsonType: MockModel.self,
                    data: invalidJSONData,
                    dataMapper: { _ in MockModel(id: "0", name: "Mock") }
                )
                #expect(Bool(false), "Expected to throw jsonDecodingError, but no error was thrown")
            } catch let error as ImportError {
                if case let .jsonDecodingError(fileName, underlyingError) = error {
                    #expect(fileName == "invalidFile")
                    #expect(underlyingError is DecodingError)
                } else {
                    #expect(Bool(false), "Expected jsonDecodingError, but got \(error)")
                }
            } catch {
                #expect(Bool(false), "Unexpected error: \(error)")
            }
        }
    }
}
