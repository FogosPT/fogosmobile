import SwiftUI
import MapKit

struct WatchMapView: View {
    @State private var vm = FiresViewModel()
    @State private var camera: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.5, longitude: -8.0),
        span: MKCoordinateSpan(latitudeDelta: 4, longitudeDelta: 4)
    ))
    @State private var selectedFire: Fire?

    var body: some View {
        Map(position: $camera, selection: $selectedFire) {
            ForEach(vm.fires) { fire in
                Marker(fire.city.isEmpty ? fire.district : fire.city,
                       systemImage: fire.isFire ? "flame.fill" : "exclamationmark.triangle.fill",
                       coordinate: CLLocationCoordinate2D(latitude: fire.lat, longitude: fire.lng))
                .tint(color(for: fire))
                .tag(fire)
            }
            UserAnnotation()
        }
        .navigationTitle("Mapa")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.load()
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(60))
                if Task.isCancelled { break }
                await vm.load()
            }
        }
        .onAppear { recenter() }
        .onChange(of: vm.fires) { _, _ in recenter() }
        .sheet(item: $selectedFire) { fire in
            NavigationStack {
                FireDetailView(fire: fire, userLat: vm.userLat, userLng: vm.userLng)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: WatchSessionManager.didUpdatePrefs)) { _ in
            Task { await vm.load() }
        }
    }

    private func color(for fire: Fire) -> Color {
        guard !fire.statusColor.isEmpty else { return .red }
        // statusColor comes as hex like "#FF0000"
        var hex = fire.statusColor
        if hex.hasPrefix("#") { hex.removeFirst() }
        guard hex.count == 6, let value = UInt32(hex, radix: 16) else { return .red }
        let r = Double((value >> 16) & 0xFF) / 255
        let g = Double((value >> 8) & 0xFF) / 255
        let b = Double(value & 0xFF) / 255
        return Color(red: r, green: g, blue: b)
    }

    private func recenter() {
        if let lat = vm.userLat, let lng = vm.userLng {
            let span = Double(vm.radiusKm) / 111.0 * 2
            camera = .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
            ))
        } else if !vm.fires.isEmpty {
            let lats = vm.fires.map { $0.lat }
            let lngs = vm.fires.map { $0.lng }
            let midLat = (lats.min()! + lats.max()!) / 2
            let midLng = (lngs.min()! + lngs.max()!) / 2
            let spanLat = max(lats.max()! - lats.min()!, 0.5) * 1.3
            let spanLng = max(lngs.max()! - lngs.min()!, 0.5) * 1.3
            camera = .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: midLat, longitude: midLng),
                span: MKCoordinateSpan(latitudeDelta: spanLat, longitudeDelta: spanLng)
            ))
        }
    }
}
