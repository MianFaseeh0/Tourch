import Foundation

enum TestStatus: String, Codable {
    case idle, running, passed, failed, unavailable
}

/// One test outcome. Codable -> sent to the desktop server as JSON.
struct TestResult: Codable, Identifiable, Equatable {
    let id: String
    let name: String
    var status: TestStatus
    var detail: String
    var timestamp: Date
}

struct DeviceReport: Codable {
    let deviceName: String
    let systemVersion: String
    let model: String
    let generatedAt: Date
    let results: [TestResult]
}

/// What the desktop server sends back after receiving a report.
struct ServerAck: Codable {
    let type: String
    let received: Int
}

enum JSONCoding {
    static func makeEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase   // deviceName -> device_name
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }

    static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
