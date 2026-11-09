import Foundation

/// Every hardware check conforms to this. Adding a new test = one new struct,
/// no changes to the view model's run loop (open/closed principle).
@MainActor
protocol DiagnosticTest {
    var id: String { get }
    var name: String { get }
    func run() async -> TestResult
}

extension DiagnosticTest {
    func makeResult(_ status: TestStatus, _ detail: String) -> TestResult {
        TestResult(id: id, name: name, status: status, detail: detail, timestamp: Date())
    }
}
