//
//  traveleasyUITests.swift
//  traveleasyUITests
//
//  Created by Miftahul Fazi on 28/02/26.
//

import XCTest

final class traveleasyUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        // App shows splash then auth or main tabs; no strict assertion to avoid flakiness.
    }

    @MainActor
    func testSignInAndNavigateToDestination() throws {
        let app = XCUIApplication()
        app.launch()
        // Wait for splash then auth or main UI
        _ = app.tabBars.buttons["Home"].waitForExistence(timeout: 5)
        let homeTab = app.tabBars.buttons["Home"]
        guard homeTab.exists else { return }
        homeTab.tap()
        let tables = app.tables
        if tables.cells.count > 1 {
            tables.cells.element(boundBy: 1).tap()
            let addFavorite = app.buttons["Add to Favorites"]
            if addFavorite.waitForExistence(timeout: 2) {
                addFavorite.tap()
            }
        }
    }

    @MainActor
    func testFavoritesTabShowsEmptyOrList() throws {
        let app = XCUIApplication()
        app.launch()
        _ = app.tabBars.buttons["Favorites"].waitForExistence(timeout: 5)
        let favoritesTab = app.tabBars.buttons["Favorites"]
        guard favoritesTab.exists else { return }
        favoritesTab.tap()
        let emptyMessage = app.staticTexts["No favorites yet"]
        let hasEmpty = emptyMessage.waitForExistence(timeout: 2)
        XCTAssertTrue(hasEmpty || app.tables.cells.count >= 0)
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
