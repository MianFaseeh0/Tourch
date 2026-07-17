/// Represents the current state of the device torch.
///
/// Kept as its own model so the ViewModel and View never have to reason
/// about raw booleans or platform-channel details — just this enum.
enum TorchStatus {
  off,
  on,
}
