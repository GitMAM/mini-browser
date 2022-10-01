//
//  mini_browserUITests.swift
//  mini-browserUITests
//
//  Created by Mohamed Ali on 30/09/2022.
//

import XCTest
//@testable import mini_browser

final class mini_browserUITests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  // a simple test case for illustration
  func testToolBarButtons() throws {
    
    let app = XCUIApplication()
    app.launchArguments = ["testMode"]
    app.launch()

    let toolbar = app.toolbars["Toolbar"]
    let rightButton = toolbar.buttons["Right"]
    let leftButton = toolbar.buttons["Left"]
    
    rightButton.tap()
    leftButton.tap()
    
    let startButton = app/*@START_MENU_TOKEN@*/.staticTexts["Tap to start"]/*[[".buttons[\"Tap to start\"].staticTexts[\"Tap to start\"]",".staticTexts[\"Tap to start\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists
    XCTAssertTrue(startButton)

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
