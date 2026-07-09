//
//  FogosWatch_Watch_AppUITestsLaunchTests.swift
//  FogosWatch Watch AppUITests
//
//  Created by João Pina on 09/07/2026.
//  Copyright © 2026 The Chromium Authors. All rights reserved.
//

import XCTest

final class FogosWatch_Watch_AppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
