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
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    
    [super tearDown];
}

- (void)testProductDetails {
    // Add sample Set
    [self addSetForID:@"41125"];
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.staticTexts[@"41125"] tap];
    
    XCTAssert(app.staticTexts[@"242001"].exists);
    
    // Tap the building instructions
    [tablesQuery.staticTexts[@"Building Instructions"] tap];
    
    // Wait for info to load
    [NSThread sleepForTimeInterval:5];
    
    XCTAssert([[app.collectionViews childrenMatchingType:XCUIElementTypeCell] containingType:XCUIElementTypeStaticText identifier:@"BI 3017 / 60+4 - 65/115g, 41125 2/2 V29"].element.exists);
    
    // Go back to set details
    [app.navigationBars[@"Instructions"].buttons[@"Set Details"] tap];

    // Return to Sets to delete
    [app.navigationBars[@"Set Details"].buttons[@"My Sets"] tap];
    
    // Delete sample Set
    [self deleteSetForID:@"41125"];
}

- (void)testMissingBrick {
    // Add sample Set
    [self addSetForID:@"41125"];
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    XCUIElementQuery *tabBarsQuery = app.tabBars;
    
    // Select a Set
    [tablesQuery.staticTexts[@"41125"] tap];
    
    // Swipe on a brick
    [tablesQuery.staticTexts[@"242001"] swipeLeft];
    
    // Set it to missing
    [tablesQuery.buttons[@"Mark Missing"] tap];
    
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
    
    // Set missing brick to Found
    [tablesQuery.staticTexts[@"242001"] swipeLeft];
    [tablesQuery.buttons[@"Mark Found"] tap];
    
    // Navigate back to Sets to delete set
    [app.navigationBars[@"Set Details"].buttons[@"My Sets"] tap];
    [tabBarsQuery.buttons[@"Sets"] tap];
    
    // Delete Set
    [self deleteSetForID:@"41125"];
}

- (void)testBrickSearch {
    // Add sample Set
    [self addSetForID:@"41125"];
    
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
    
    // Mark it missing
    [tablesQuery.staticTexts[@"Item No: 242001"] swipeLeft];
    [tablesQuery.buttons[@"Mark Missing"] tap];
    
    // Go to missing bricks and see if it shows up there
    [tabBarsQuery.buttons[@"Missing"] tap];
    XCTAssert(app.staticTexts[@"Item No: 242001"].exists);
    
    // Navigate back to sets to delete set
    [tabBarsQuery.buttons[@"Sets"] tap];
    
    // Delete Set
    [self deleteSetForID:@"41125"];
}

- (void)testRearrangingSets {
    // Add first Set
    [self addSetForID:@"41125"];
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    // Insert second Set
    [self addSetForID:@"10701"];
    
    // Assert the set exists
    XCTAssert(app.staticTexts[@"Gray Baseplate"].exists);
    
    // Tap the edit button in the navigation
    [app.navigationBars[@"My Sets"].buttons[@"Edit"] tap];
    
    XCUIElement *topButton = app.tables.buttons[@"Reorder Gray Baseplate, 10701"];
    XCUIElement *bottomButton = app.tables.buttons[@"Reorder Horse Vet Trailer, 41125"];
    
    // Drag the bottom button up to re-order
    [bottomButton pressForDuration:0.5 thenDragToElement:topButton];
    
    // Assert that the bottom one is now the top one
    XCUIElementQuery *tablesQuery = app.tables;
    XCUIElement *firstCell = [tablesQuery.cells elementBoundByIndex:0];
    XCTAssert(firstCell.staticTexts[@"Horse Vet Trailer"].exists);
    
    [app.navigationBars[@"My Sets"].buttons[@"Done"] tap];
    
    // Delete Sets
    [self deleteSetForID:@"10701"];
    [self deleteSetForID:@"41125"];
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

    //[app.staticTexts[@"Not Now"] tap];
    //[app.alerts.buttons[@"Not Now"] tap];
    //[NSThread sleepForTimeInterval:5];
    //XCTAssert(app.staticTexts[@"Not Now"].exists);
}

- (void)testDismissKeyboardByTappingScreen {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.tabBars.buttons[@"Search"] tap];
    
    XCUIElementQuery *tablesQuery = app.tables;
    
    // Assert keyboard appears
    XCTAssertEqual(app.keyboards.count, 1);
    [tablesQuery.textFields[@"setSearchTextField"] typeText:@"41125"];
    
    // Tap outside the text field
    XCUIElement *searchForSetTable = [app.tables containingType:XCUIElementTypeOther identifier:@"SEARCH FOR SET"].element;
    [searchForSetTable tap];
    
    // Assert keyboard dismissed
    XCTAssertEqual(app.keyboards.count, 0);
    
    // Tap the other text field
    [tablesQuery.textFields[@"brickSearchTextField"] tap];
    
    // Assert keyboard appears
    XCTAssertEqual(app.keyboards.count, 1);
    
    // Tap outside the text field
    [searchForSetTable tap];
    
    // Assert keyboard dismissed
    XCTAssertEqual(app.keyboards.count, 0);
}

- (void)testTapBrickToSearch {
    // Add the first set
    [self addSetForID:@"41125"];
    
    // Add another set that has at least one brick the same
    [self addSetForID:@"60072"];
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    // Tap Sets
    XCUIElementQuery *tabBarsQuery = app.tabBars;
    [tabBarsQuery.buttons[@"Sets"] tap];
    
    XCUIElementQuery *tablesQuery = app.tables;
    
    // Select a Set
    [tablesQuery.staticTexts[@"60072"] tap];
    
    // Tap on a brick
    [tablesQuery.staticTexts[@"300401"] tap];
    
    // Assert it goes to the Results view and the brick shows up for 2 sets
    XCTAssert(app.staticTexts[@"Set: Horse Vet Trailer"].exists);
    XCTAssert(app.staticTexts[@"Set: Demolition Starter Set"].exists);
    
    // Navigate back to sets to delete set
    [tabBarsQuery.buttons[@"Sets"] tap];
    
    // Delete the sets
    [self deleteSetForID:@"41125"];
    [self deleteSetForID:@"60072"];
}

#pragma mark - Helper methods

- (void)addSetForID:(NSString *)setID {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tabBarsQuery = app.tabBars;
    [tabBarsQuery.buttons[@"Search"] tap];
    
    // Clear the search text field if needed
    XCUIElementQuery *tablesQuery = app.tables;
    if (tablesQuery.buttons[@"Clear text"].exists) {
        [tablesQuery.buttons[@"Clear text"] tap];
    }
    
    // Search for a set and add it to the collection
    [tablesQuery.textFields[@"setSearchTextField"] typeText:setID];
    [[tablesQuery.cells containingType:XCUIElementTypeTextField identifier:@"setSearchTextField"].buttons[@"Search"] tap];
    
    // Wait for Add button to become tappable
    [NSThread sleepForTimeInterval:15];
    
    // Add the Set
    [app.navigationBars[@"Results"].buttons[@"Add"] tap];
    [app.alerts[@"Added!"].buttons[@"OK"] tap];
    
    // Tap anywhere to dismiss keyboard so tab bar becomes visible
    [[app.tables containingType:XCUIElementTypeOther identifier:@"SEARCH FOR SET"].element tap];
    
    // Tap the Sets button in the tab bar
    [tabBarsQuery.buttons[@"Sets"] tap];

}

- (void)deleteSetForID:(NSString *)setID {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    
    [tablesQuery.staticTexts[setID] swipeLeft];
    [tablesQuery.buttons[@"Delete"] tap];
}




@end
