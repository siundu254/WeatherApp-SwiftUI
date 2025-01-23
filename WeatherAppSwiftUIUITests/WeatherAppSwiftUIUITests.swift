//
//  WeatherAppSwiftUIUITests.swift
//  WeatherAppSwiftUIUITests
//
//  Created by Kevin on 26/01/2025.
//

import XCTest

final class WeatherAppSwiftUIUITests: XCTestCase {
    // This will be executed before each test.
    override func setUpWithError() throws {
        continueAfterFailure = false
        
    }
    
    // Test if the loading view appears initially
    func testLoadingView() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Check if the loading view is displayed
        let loadingLabel = app.staticTexts["Loading Weather Data..."]
        XCTAssertTrue(loadingLabel.exists)
    }
}
