import UIKit
import Flutter
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let CHANNEL = "torch_channel"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call: call, result: result)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
      result(FlutterError(code: "TORCH_ERROR", message: "No torch available on this device", details: nil))
      return
    }

    do {
      try device.lockForConfiguration()

      switch call.method {
      case "turnOn":
        device.torchMode = .on
        device.unlockForConfiguration()
        result(nil)
      case "turnOff":
        device.torchMode = .off
        device.unlockForConfiguration()
        result(nil)
      default:
        device.unlockForConfiguration()
        result(FlutterMethodNotImplemented)
      }
    } catch {
      result(FlutterError(code: "TORCH_ERROR", message: error.localizedDescription, details: nil))
    }
  }
}
