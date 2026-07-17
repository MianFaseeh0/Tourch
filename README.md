Torch MVVM

A cross-platform Flutter torch app built with MVVM and SOLID principles — native flash control via `MethodChannel` on both Android (`CameraManager`) and iOS (`AVCaptureDevice`).

- Single Responsibility** — service talks to the platform channel, ViewModel manages state, View renders.
- Dependency Inversion** — the ViewModel depends on `ITorchService`, not the concrete `MethodChannelTorchService`, so the service is swappable (mocks, tests, alternate implementations) without touching the ViewModel or View.
- Open/Closed** — new torch backends can be added by implementing `ITorchService`; no existing code changes.

## Platform setup

iOS — add a camera usage description to `Info.plist` (required for any torch/camera access):
```xml
<key>NSCameraUsageDescription</key>
<string>Used to control the device torch.</string>
```

Android — the Kotlin file's package is `com.example.tourch`. Update it to match your `applicationId` in `build.gradle`, and move the file to the matching folder path under `android/app/src/main/kotlin/`.

Method channel contract

Both platforms implement the same channel, `torch_channel`, with two methods:
 `turnOn` Enables the torch 
 `turnOff` Disables the torch 
