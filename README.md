# DeviceDiag

SwiftUI app that runs hardware diagnostics on an iPhone and sends the results as JSON
over a WebSocket to a desktop receiver. Built as a small model of a device-diagnostics
tool: protocol-driven tests, Codable serialization, async/await, real-time socket link.

## What it tests
| Test | Framework | Notes |
|---|---|---|
| Battery | UIDevice | level, charge state, Low Power Mode |
| Display / ambient light | UIScreen | iOS has no public ambient-light API; reports brightness as a proxy |
| Accelerometer | CoreMotion | averages 10 samples, expects ~1 g at rest |
| Camera | AVFoundation | permission, camera discovery, builds a capture input |
| Biometrics | LocalAuthentication | runs a real Face ID / Touch ID prompt |
| NFC | CoreNFC | hardware-support check only |

## Architecture
- `DiagnosticTest` protocol: every test is one struct; the view model never changes when you add one.
- MVVM: `DiagnosticsViewModel` (`@MainActor`, `ObservableObject`) owns state; views only render it.
- `Codable` models with snake_case key strategy and ISO-8601 dates.
- `DiagnosticsSocket`: `URLSessionWebSocketTask`, sends the report, awaits a `ServerAck`.
- `[weak manager]` in the CoreMotion handler avoids a retain cycle.

## Run it
**Create the project (pick one):**
- Xcode: File > New > Project > iOS App (SwiftUI, name `DeviceDiag`, iOS 16+). Delete the default
  `ContentView.swift` and app file, drag in the `DeviceDiag/` folder contents. Add to Info:
  `NSCameraUsageDescription`, `NSFaceIDUsageDescription`, `NSLocalNetworkUsageDescription`,
  and App Transport Security > Allows Local Networking = YES.
- XcodeGen: `brew install xcodegen && xcodegen`, open `DeviceDiag.xcodeproj`.

**Start the receiver (on your Mac):**
```
cd server && npm install && npm start
```
It prints the `ws://IP:8080` address. Put your Mac and iPhone on the same Wi-Fi, paste that
address into the app, tap **Run all**, then **Send report to server**.

Run on a real iPhone: the Simulator has no battery, accelerometer, camera or NFC.
If Xcode complains about concurrency, set Swift Language Version to 5.

## Ideas to extend
CoreMotion gyro test, flashlight/torch test, a unit-test target for the models' JSON round-trip,
a Swift Package for the tests, reading NFC tags with `NFCNDEFReaderSession`.
