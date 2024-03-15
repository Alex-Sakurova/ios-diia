//
//  DiiaOSUITests.swift
//  DiiaOSUITests
//
//  Created by Oleksandra Sakurova on 14.03.2024.
//

import XCTest

final class DiiaOSUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPolicyLinkIsOpenedInSafari() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.scrollViews.staticTexts["text_conditions_auth"].waitForExistence(timeout: 4))
        app.scrollViews.links.firstMatch.tap()
        XCTAssertTrue(app.alerts.buttons["Скасувати"].exists)
        XCTAssertTrue(app.alerts.buttons["Відкрити"].exists)
        app.alerts.buttons["Відкрити"].tap()
        
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
                guard safari.wait(for: .runningForeground, timeout: 10) else {
                    XCTFail("could not open Safari")
                    return
                }
                // we use CONTAINS because at first, only the base URL is displayed inside the text field. For example, if the URL is https://myapp.com/something, the value of the address bar would be 'myapp.com'
                let pred = NSPredicate(format: "value CONTAINS[cd] %@", "diia.gov.ua")
                let addressBar = safari.textFields.element(matching: pred)
                // tap is needed to reveal the full URL string inside the address bar
                addressBar.tap()
                
                let textField = safari.textFields.element(matching: pred)
                XCTAssertEqual(textField.value as? String, "https://diia.gov.ua/app_policy")
        
        app.activate()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
