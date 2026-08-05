import SwiftUI

@Observable
@MainActor
final class WarningsViewModel {
    var items: [WarningItem] = []
    var isLoading = false
    var errorMessage: String?

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            items = try await FogosAPI.shared.fetchWarnings()
        } catch {
            errorMessage = "Sem ligação"
        }
    }
}

struct WarningsView: View {
    @State private var vm = WarningsViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading && vm.items.isEmpty {
                    ProgressView()
                } else if let error = vm.errorMessage, vm.items.isEmpty {
                    ContentUnavailableView(error, systemImage: "wifi.exclamationmark")
                } else if vm.items.isEmpty {
                    ContentUnavailableView("Sem avisos", systemImage: "checkmark.circle")
                } else {
                    List(vm.items) { item in
                        WarningRow(item: item)
                    }
                    .listStyle(.carousel)
                }
            }
            .navigationTitle("Avisos")
            .task {
                await vm.load()
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(120))
                    if Task.isCancelled { break }
                    await vm.load()
                }
            }
            .refreshable { await vm.load() }
        }
    }
}

struct WarningRow: View {
    let item: WarningItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                Text(item.title)
                    .font(.headline)
                    .lineLimit(2)
            }
            if !item.text.isEmpty {
                Text(item.text)
                    .font(.caption)
                    .lineLimit(3)
                    .foregroundStyle(.secondary)
            }
            if !item.timestamp.isEmpty {
                Text(item.timestamp)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 2)
    }

    private var color: Color {
        switch item.severity {
        case .red: .red
        case .orange: .orange
        case .yellow: .yellow
        case .green: .green
        }
    }
}
