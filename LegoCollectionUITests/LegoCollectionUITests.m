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
    // Wait for Add button to become tappable
    [NSThread sleepForTimeInterval:7];
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
    
    // Tap the building instructions
    [tablesQuery.staticTexts[@"Building Instructions"] tap];
    
    // Wait for info to load
    [NSThread sleepForTimeInterval:3];
    
    XCTAssert([[app.collectionViews childrenMatchingType:XCUIElementTypeCell] containingType:XCUIElementTypeStaticText identifier:@"BI 3017 / 60+4 - 65/115g, 41125 2/2 V29"].element.exists);
    
    // Go back to set details
    [app.navigationBars[@"Instructions"].buttons[@"Set Details"] tap];

    // Return to Sets so tear-down can delete
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

- (void)testRearrangingSets {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    // Insert another set to make sure we have more than 1
    XCUIElementQuery *tabBarsQuery = app.tabBars;
    [tabBarsQuery.buttons[@"Search"] tap];
    XCUIElementQuery *tablesQuery = app.tables;
    // Clear the search text field
    [tablesQuery.buttons[@"Clear text"] tap];
    // Enter the new set to search for
    [tablesQuery.textFields[@"setSearchTextField"] typeText:@"10701"];
    [[tablesQuery.cells containingType:XCUIElementTypeTextField identifier:@"setSearchTextField"].buttons[@"Search"] tap];
    // Wait for Add button to become tappable
    [NSThread sleepForTimeInterval:3];
    [app.navigationBars[@"Results"].buttons[@"Add"] tap];
    [app.alerts[@"Added!"].buttons[@"OK"] tap];
    [[app.tables containingType:XCUIElementTypeOther identifier:@"SEARCH FOR SET"].element tap];
    [tabBarsQuery.buttons[@"Sets"] tap];
    // Assert the set exists
    XCTAssert(app.staticTexts[@"Gray Baseplate"].exists);
    
    // Tap the edit button in the navigation
    [app.navigationBars[@"My Sets"].buttons[@"Edit"] tap];
    
    XCUIElement *topButton = app.tables.buttons[@"Reorder Gray Baseplate, 10701"];
    XCUIElement *bottomButton = app.tables.buttons[@"Reorder Horse Vet Trailer, 41125"];
    
    // Drag the bottom button up to re-order
    [bottomButton pressForDuration:0.5 thenDragToElement:topButton];
    
    // Assert that the bottom one is now the top one
    XCUIElement *firstCell = [tablesQuery.cells elementBoundByIndex:0];
    XCTAssert(firstCell.staticTexts[@"Horse Vet Trailer"].exists);
    
    [app.navigationBars[@"My Sets"].buttons[@"Done"] tap];
    
    // Delete the second set (tear-down will delete the first set)
    [tablesQuery.staticTexts[@"10701"] swipeLeft];
    [tablesQuery.buttons[@"Delete"] tap];
}

- (void)testInfoScreen {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tabBarsQuery = app.tabBars;
    [tabBarsQuery.buttons[@"Info"] tap];
    
    XCUIElementQuery *tablesQuery = app.tables;
    // Check that all the links are there
    XCTAssert(tablesQuery.buttons[@"https://icons8.com"].exists);
    XCTAssert(tablesQuery.buttons[@"https://makeappicon.com"].exists);
    XCTAssert(tablesQuery.buttons[@"https://morgandavison.com/apps"].exists);
    
    // Tap the Rate button
    [tablesQuery.buttons[@"Rate"] tap];
    [[[app childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0].otherElements[@"Rating"] tap];
    XCTAssert(app.staticTexts[@"Cancel"].exists);
    [app.staticTexts[@"Cancel"] tap];
    
    // Navigate back to sets so tear-down can delete set
    [tabBarsQuery.buttons[@"Sets"] tap];
}


@end
