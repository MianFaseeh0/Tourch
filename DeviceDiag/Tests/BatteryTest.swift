import UIKit

struct BatteryTest: DiagnosticTest {
    let id = "battery"
    let name = "Battery"

    func run() async -> TestResult {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true

        let level = device.batteryLevel          // -1 when unavailable (e.g. Simulator)
        guard level >= 0 else {
            return makeResult(.unavailable, "Battery level not available on this device")
        }

        let state: String
        switch device.batteryState {
        case .charging:  state = "charging"
        case .full:      state = "full"
        case .unplugged: state = "unplugged"
        default:         state = "unknown"
        }
        let lowPower = ProcessInfo.processInfo.isLowPowerModeEnabled ? "on" : "off"
        return makeResult(.passed, "\(Int(level * 100))% · \(state) · low power mode \(lowPower)")
    }
}
