import Foundation

enum SocketError: LocalizedError {
    case notConnected
    case encodingFailed

    var errorDescription: String? {
        switch self {
        case .notConnected:   return "Not connected to the server"
        case .encodingFailed: return "Could not encode the report"
        }
    }
}

/// Thin WebSocket client over URLSessionWebSocketTask.
/// Sends the Codable report as a JSON text frame and waits for the server's ack.
final class DiagnosticsSocket {
    private let session = URLSession(configuration: .default)
    private var task: URLSessionWebSocketTask?

    func connect(to url: URL) {
        disconnect()
        task = session.webSocketTask(with: url)
        task?.resume()
    }

    func disconnect() {
        task?.cancel(with: .goingAway, reason: nil)
        task = nil
    }

    func send(_ report: DeviceReport) async throws -> ServerAck {
        guard let task else { throw SocketError.notConnected }

        let data = try JSONCoding.makeEncoder().encode(report)
        guard let text = String(data: data, encoding: .utf8) else { throw SocketError.encodingFailed }
        try await task.send(.string(text))

        let reply = try await task.receive()
        switch reply {
        case .string(let string):
            return try JSONCoding.makeDecoder().decode(ServerAck.self, from: Data(string.utf8))
        case .data(let data):
            return try JSONCoding.makeDecoder().decode(ServerAck.self, from: data)
        @unknown default:
            throw SocketError.encodingFailed
        }
    }
}
