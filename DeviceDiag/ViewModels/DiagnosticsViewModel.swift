import SwiftUI

@MainActor
final class DiagnosticsViewModel: ObservableObject {
    @Published private(set) var results: [TestResult]
    @Published private(set) var isRunning = false
    @Published private(set) var socketStatus = "Not connected"
    @Published var serverURL = "ws://192.168.1.10:8080"

    private let tests: [any DiagnosticTest]
    private let socket = DiagnosticsSocket()

    init(tests: [any DiagnosticTest]) {
        self.tests = tests
        self.results = tests.map {
            TestResult(id: $0.id, name: $0.name, status: .idle, detail: "Not run yet", timestamp: Date())
        }
    }

    convenience init() {
        self.init(tests: [
            BatteryTest(),
            DisplayLightTest(),
            MotionTest(),
            CameraTest(),
            BiometricTest(),
            NFCTest()
        ])
    }

    var summary: String {
        let passed = results.filter { $0.status == .passed }.count
        return "\(passed)/\(results.count) passed"
    }

    func runAll() async {
        isRunning = true
        defer { isRunning = false }
        for index in tests.indices {
            await run(at: index)
        }
    }

    func run(at index: Int) async {
        guard tests.indices.contains(index) else { return }
        results[index].status = .running
        results[index] = await tests[index].run()
    }

    func sendReport() async {
        guard let url = URL(string: serverURL), url.scheme == "ws" || url.scheme == "wss" else {
            socketStatus = "Invalid URL (use ws://host:port)"
            return
        }
        socketStatus = "Connecting…"
        socket.connect(to: url)

        let device = UIDevice.current
        let report = DeviceReport(
            deviceName: device.name,
            systemVersion: device.systemVersion,
            model: device.model,
            generatedAt: Date(),
            results: results
        )

        do {
            let ack = try await socket.send(report)
            socketStatus = "Server acknowledged \(ack.received) results"
        } catch {
            socketStatus = "Failed: \(error.localizedDescription)"
        }
        socket.disconnect()
    }
}
