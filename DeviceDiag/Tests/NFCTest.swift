import CoreNFC

/// Hardware-support check only. Actually reading tags needs an
/// NFCNDEFReaderSession plus the NFC capability (paid developer account).
struct NFCTest: DiagnosticTest {
    let id = "nfc"
    let name = "NFC"

    func run() async -> TestResult {
        if NFCNDEFReaderSession.readingAvailable {
            return makeResult(.passed, "NFC tag reading supported")
        }
        return makeResult(.unavailable, "NFC tag reading not supported on this device")
    }
}
