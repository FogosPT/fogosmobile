import SwiftUI

@main
struct FogosWatch_Watch_AppApp: App {
    @WKApplicationDelegateAdaptor(FogosWatchAppDelegate.self) var appDelegate

    init() {
        WatchSessionManager.shared.activate()
        // Scheduling the first background refresh happens in
        // FogosWatchAppDelegate.applicationDidFinishLaunching — at App.init()
        // the delegate isn't installed yet so scheduleBackgroundRefresh crashes.
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        WKNotificationScene(
            controller: FireNotificationController.self,
            category: "fogos-fire"
        )
        .backgroundTask(.appRefresh(BackgroundRefreshService.taskIdentifier)) {
            await BackgroundRefreshService.performRefresh()
            BackgroundRefreshService.scheduleNext()
        }
    }
}
