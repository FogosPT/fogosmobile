import Foundation
import WatchKit

/// `WKApplicationDelegate` required by `WKApplication.scheduleBackgroundRefresh(...)`.
/// Runtime task delivery is routed through SwiftUI's `.backgroundTask(.appRefresh(...))`
/// modifier on `FogosWatch_Watch_AppApp`; `handle(_:)` here just satisfies the
/// framework contract and marks any tasks SwiftUI didn't already claim as done.
///
/// Also handles the initial refresh scheduling: called from `applicationDidFinishLaunching`
/// so the delegate is guaranteed to be installed before `scheduleBackgroundRefresh` runs.
final class FogosWatchAppDelegate: NSObject, WKApplicationDelegate {
    func applicationDidFinishLaunching() {
        BackgroundRefreshService.scheduleNext()
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            task.setTaskCompletedWithSnapshot(false)
        }
    }
}
