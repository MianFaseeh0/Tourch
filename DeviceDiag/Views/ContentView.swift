import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DiagnosticsViewModel()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(Array(viewModel.results.enumerated()), id: \.element.id) { index, result in
                        Button {
                            Task { await viewModel.run(at: index) }
                        } label: {
                            ResultRow(result: result)
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Text("Tests · \(viewModel.summary)")
                } footer: {
                    Text("Tap a row to run a single test.")
                }

                Section("Desktop link (WebSocket)") {
                    TextField("ws://host:8080", text: $viewModel.serverURL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.URL)

                    Button("Send report to server") {
                        Task { await viewModel.sendReport() }
                    }

                    Text(viewModel.socketStatus)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("DeviceDiag")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Run all") {
                        Task { await viewModel.runAll() }
                    }
                    .disabled(viewModel.isRunning)
                }
            }
        }
    }
}

private struct ResultRow: View {
    let result: TestResult

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .foregroundStyle(color)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(result.name).font(.headline)
                Text(result.detail)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(Rectangle())
    }

    private var symbol: String {
        switch result.status {
        case .idle:        return "circle"
        case .running:     return "hourglass"
        case .passed:      return "checkmark.circle.fill"
        case .failed:      return "xmark.circle.fill"
        case .unavailable: return "minus.circle.fill"
        }
    }

    private var color: Color {
        switch result.status {
        case .idle, .running: return .secondary
        case .passed:         return .green
        case .failed:         return .red
        case .unavailable:    return .orange
        }
    }
}
