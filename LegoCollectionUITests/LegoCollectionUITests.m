//
//  LegoCollectionUITests.m
//  LegoCollectionUITests
//
//  Created by Morgan Davison on 3/30/17.
//  Copyright © 2017 Morgan Davison. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface LegoCollectionUITests : XCTestCase

@end

@implementation LegoCollectionUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tabBarsQuery = app.tabBars;
    [tabBarsQuery.buttons[@"Search"] tap];
    
    // Search for a set and add it to the collection
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.textFields[@"setSearchTextField"] typeText:@"41125"];
    [[tablesQuery.cells containingType:XCUIElementTypeTextField identifier:@"setSearchTextField"].buttons[@"Search"] tap];
    [app.navigationBars[@"Results"].buttons[@"Add"] tap];
    [app.alerts[@"Added!"].buttons[@"OK"] tap];
    [[app.tables containingType:XCUIElementTypeOther identifier:@"SEARCH FOR SET"].element tap];
    [tabBarsQuery.buttons[@"Sets"] tap];
    XCTAssert(app.staticTexts[@"Horse Vet Trailer"].exists);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    XCUIElementQuery *tablesQuery = app.tables;

    // Delete set
    [tablesQuery.staticTexts[@"41125"] swipeLeft];
    [tablesQuery.buttons[@"Delete"] tap];
    XCTAssert(!app.staticTexts[@"Horse Vet Trailer"].exists);
    
    [super tearDown];
}

- (void)testProductDetails {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.staticTexts[@"41125"] tap];
    
    XCTAssert(app.staticTexts[@"242001"].exists);
    [app.navigationBars[@"Set Details"].buttons[@"My Sets"] tap];
}

- (void)testMissingBrick {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    XCUIElementQuery *tabBarsQuery = app.tabBars;
    XCUIElementQuery *toolBarsQuery = app.toolbars;
    
    // Select a Set
    [tablesQuery.staticTexts[@"41125"] tap];
    
    // Select a Brick
    [tablesQuery.staticTexts[@"242001"] tap];
    
    // "Missing" toolbar button should be enabled
    XCTAssert(toolBarsQuery.buttons[@"Missing"].isEnabled);
    // "Found" toolbar button should not be enabled
    XCTAssert(!toolBarsQuery.buttons[@"Found"].isEnabled);
    
    // Set it to missing
    [toolBarsQuery.buttons[@"Missing"] tap];
    
    // Go to missing bricks and see if it shows up there
    [app.navigationBars[@"Set Details"].buttons[@"My Sets"] tap];
    [tabBarsQuery.buttons[@"Missing"] tap];
    XCTAssert(app.staticTexts[@"Item No: 242001"].exists);
    
    // View sets brick belongs to
    [app.staticTexts[@"Item No: 242001"] tap];
    XCTAssert(app.staticTexts[@"Horse Vet Trailer"].exists);
    
    // Go back to the Set details
    [tabBarsQuery.buttons[@"Sets"] tap];
    [tablesQuery.staticTexts[@"41125"] tap];
    
    // Select the missing brick
    [tablesQuery.staticTexts[@"242001"] tap];
    
    // "Found" toolbar button should be enabled
    XCTAssert(toolBarsQuery.buttons[@"Found"].isEnabled);
    // "Missing" toolbar button should not be enabled
    XCTAssert(!toolBarsQuery.buttons[@"Missing"].isEnabled);
    
    // Set missing brick to Found
    [toolBarsQuery.buttons[@"Found"] tap];
    
    // Select a different brick and set to Missing
    [tablesQuery.staticTexts[@"3003941"] tap];
    XCTAssert(toolBarsQuery.buttons[@"Missing"].isEnabled);
    [toolBarsQuery.buttons[@"Missing"] tap];
    
    // Select both a missing and a found brick and assert that neither toolbar button is enabled
    [tablesQuery.staticTexts[@"242001"] tap];
    [tablesQuery.staticTexts[@"3003941"] tap];
    XCTAssert(!toolBarsQuery.buttons[@"Missing"].isEnabled);
    XCTAssert(!toolBarsQuery.buttons[@"Found"].isEnabled);
    
    // Navigate back to sets so tear-down can delete set
    [app.navigationBars[@"Set Details"].buttons[@"My Sets"] tap];
    [tabBarsQuery.buttons[@"Sets"] tap];
}

- (void)testBrickSearch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tabBarsQuery = app.tabBars;
    [tabBarsQuery.buttons[@"Search"] tap];
    
    // Search for a brick
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.textFields[@"brickSearchTextField"] tap];
    [tablesQuery.textFields[@"brickSearchTextField"] typeText:@"242001"];
    [[tablesQuery.cells containingType:XCUIElementTypeTextField identifier:@"brickSearchTextField"].buttons[@"Search"] tap];
    
    // Assert the brick is in the Horse Vet Trailer set
    XCTAssert(app.staticTexts[@"Set: Horse Vet Trailer"].exists);
    
    // Navigate back to sets so tear-down can delete set
    [tabBarsQuery.buttons[@"Sets"] tap];
}


@end
