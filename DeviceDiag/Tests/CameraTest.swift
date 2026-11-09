import AVFoundation

struct CameraTest: DiagnosticTest {
    let id = "camera"
    let name = "Camera"

    func run() async -> TestResult {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        var granted = (status == .authorized)
        if status == .notDetermined {
            granted = await AVCaptureDevice.requestAccess(for: .video)
        }
        guard granted else {
            return makeResult(.failed, "Camera permission denied")
        }

        let discovery = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInUltraWideCamera, .builtInTelephotoCamera],
            mediaType: .video,
            position: .unspecified
        )
        let devices = discovery.devices
        guard !devices.isEmpty else {
            return makeResult(.unavailable, "No camera hardware found (Simulator?)")
        }

        // Prove a capture session can actually be built from the primary camera.
        let session = AVCaptureSession()
        guard let primary = devices.first(where: { $0.position == .back }) ?? devices.first,
              let input = try? AVCaptureDeviceInput(device: primary),
              session.canAddInput(input) else {
            return makeResult(.failed, "Could not create a capture input")
        }

        let front = devices.filter { $0.position == .front }.count
        let back = devices.filter { $0.position == .back }.count
        return makeResult(.passed, "\(back) back + \(front) front camera(s); capture input OK")
    }
}
