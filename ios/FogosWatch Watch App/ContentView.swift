import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NearbyListView()
                .tabItem { Label("Perto", systemImage: "flame.fill") }
            WatchMapView()
                .tabItem { Label("Mapa", systemImage: "map.fill") }
            WarningsView()
                .tabItem { Label("Avisos", systemImage: "exclamationmark.triangle.fill") }
        }
    }
}

#Preview {
    ContentView()
}
