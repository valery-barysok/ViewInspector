import XCTest
import SwiftUI
@testable import ViewInspector

#if os(macOS)

final class GroupBoxTests: XCTestCase {
    
    func testSingleEnclosedView() throws {
        let sampleView = Text("Test")
        let view = GroupBox { sampleView }
        let sut = try view.inspect().groupBox().text(0).content.view as? Text
        XCTAssertEqual(sut, sampleView)
    }
    
    func testSingleEnclosedViewIndexOutOfBounds() throws {
        let sampleView = Text("Test")
        let view = GroupBox { sampleView }
        XCTAssertThrows(
            try view.inspect().groupBox().text(1),
            "Enclosed view index '1' is out of bounds: '0 ..< 1'")
    }
    
    func testMultipleEnclosedViews() throws {
        let sampleView1 = Text("Test")
        let sampleView2 = Text("Abc")
        let sampleView3 = Text("XYZ")
        let view = GroupBox { sampleView1; sampleView2; sampleView3 }
        let view1 = try view.inspect().groupBox().text(0).content.view as? Text
        let view2 = try view.inspect().groupBox().text(1).content.view as? Text
        let view3 = try view.inspect().groupBox().text(2).content.view as? Text
        XCTAssertEqual(view1, sampleView1)
        XCTAssertEqual(view2, sampleView2)
        XCTAssertEqual(view3, sampleView3)
    }
    
    func testMultipleEnclosedViewsIndexOutOfBounds() throws {
        let sampleView1 = Text("Test")
        let sampleView2 = Text("Abc")
        let view = GroupBox { sampleView1; sampleView2 }
        XCTAssertThrows(
            try view.inspect().groupBox().text(2),
            "Enclosed view index '2' is out of bounds: '0 ..< 2'")
    }
    
    func testResetsModifiers() throws {
        let view = GroupBox { Text("Test") }.padding()
        let sut = try view.inspect().groupBox().text(0)
        XCTAssertEqual(sut.content.modifiers.count, 0)
    }
    
    func testExtractionFromSingleViewContainer() throws {
        let view = AnyView(GroupBox { Text("Test") })
        XCTAssertNoThrow(try view.inspect().anyView().groupBox())
    }
    
    func testExtractionFromMultipleViewContainer() throws {
        let view = GroupBox {
            GroupBox { Text("Test") }
            GroupBox { Text("Test") }
        }
        XCTAssertNoThrow(try view.inspect().groupBox().groupBox(0))
        XCTAssertNoThrow(try view.inspect().groupBox().groupBox(1))
    }
}

#endif
