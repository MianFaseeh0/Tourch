import UIKit

/// iOS has no public ambient-light-sensor API. This test reads the display
/// brightness (which auto-brightness drives from the ambient light sensor)
/// as the closest public signal.
struct DisplayLightTest: DiagnosticTest {
    let id = "display_light"
    let name = "Display / Ambient Light"

    func run() async -> TestResult {
        let screen = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.screen

        guard let screen else {
            return makeResult(.failed, "No active screen found")
        }
        let percent = Int(screen.brightness * 100)
        return makeResult(.passed, "Brightness \(percent)% (auto-brightness follows the ambient light sensor)")
    }
}
