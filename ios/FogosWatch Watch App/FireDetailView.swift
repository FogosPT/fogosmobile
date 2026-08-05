import SwiftUI

struct FireDetailView: View {
    let fire: Fire
    let userLat: Double?
    let userLng: Double?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                header
                Divider()
                stats
                if !fire.date.isEmpty || !fire.hour.isEmpty {
                    Divider()
                    HStack {
                        Image(systemName: "clock")
                        Text("\(fire.date) \(fire.hour)")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 4)
        }
        .navigationTitle(fire.city.isEmpty ? "Incidente" : fire.city)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(fire.statusText.isEmpty ? fire.nature : fire.statusText)
                .font(.headline)
            let location = [fire.district, fire.city, fire.town]
                .filter { !$0.isEmpty }
                .joined(separator: " · ")
            Text(location)
                .font(.caption)
                .foregroundStyle(.secondary)
            if let userLat, let userLng {
                let d = fire.distanceKm(from: userLat, userLng)
                Text(d < 1 ? "\(Int(d * 1000)) m de ti" : "\(Int(d.rounded())) km de ti")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var stats: some View {
        VStack(alignment: .leading, spacing: 6) {
            row(icon: "person.fill", label: "Operacionais", value: fire.human)
            row(icon: "car.fill", label: "Viaturas", value: fire.terrain)
            row(icon: "airplane", label: "Meios aéreos", value: fire.aerial)
        }
    }

    private func row(icon: String, label: String, value: Int) -> some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 20)
            Text(label)
                .font(.caption)
            Spacer()
            Text("\(value)")
                .font(.headline)
                .monospacedDigit()
        }
    }
}
