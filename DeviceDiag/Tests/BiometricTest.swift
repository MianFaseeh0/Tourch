import LocalAuthentication

struct BiometricTest: DiagnosticTest {
    let id = "biometrics"
    let name = "Biometrics"

    func run() async -> TestResult {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return makeResult(.unavailable, error?.localizedDescription ?? "Biometrics not available")
        }

        let kind: String
        switch context.biometryType {
        case .faceID:  kind = "Face ID"
        case .touchID: kind = "Touch ID"
        default:       kind = "Biometrics"
        }

        do {
            let ok = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Diagnostic test: verify the biometric sensor"
            )
            return makeResult(ok ? .passed : .failed, "\(kind) authentication \(ok ? "succeeded" : "failed")")
        } catch {
            return makeResult(.failed, "\(kind): \(error.localizedDescription)")
        }
    }
}
