import CoreMotion

struct MotionTest: DiagnosticTest {
    let id = "motion"
    let name = "Accelerometer"

    func run() async -> TestResult {
        let manager = CMMotionManager()
        guard manager.isAccelerometerAvailable else {
            return makeResult(.unavailable, "Accelerometer not available (Simulator?)")
        }
        manager.accelerometerUpdateInterval = 0.1

        let magnitude: Double? = await withCheckedContinuation { continuation in
            var samples: [Double] = []
            var finished = false

            // [weak manager]: the manager owns this handler, so capturing it
            // strongly would create a retain cycle until updates are stopped.
            manager.startAccelerometerUpdates(to: .main) { [weak manager] data, _ in
                guard !finished, let a = data?.acceleration else { return }
                samples.append((a.x * a.x + a.y * a.y + a.z * a.z).squareRoot())

                if samples.count >= 10 {
                    finished = true
                    manager?.stopAccelerometerUpdates()
                    continuation.resume(returning: samples.reduce(0, +) / Double(samples.count))
                }
            }
        }

        guard let magnitude else {
            return makeResult(.failed, "No accelerometer samples received")
        }
        // A device at rest reads ~1 g.
        let plausible = (0.5...3.0).contains(magnitude)
        let text = String(format: "Avg magnitude %.2f g over 10 samples", magnitude)
        return makeResult(plausible ? .passed : .failed, text)
    }
}
