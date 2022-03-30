import XCTest
@testable import ServiceStatus
// Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavoir
// Testing Structure: Given, When, Then

class ServiceStatusViewModel_Tests: XCTestCase {
    let vm = ServiceStatusViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_ServiceStatusViewModel_FetchSlackStatus_shouldReturnTrue() throws {
        
    }
    
    struct MockSlackStatusResponse {
        let mockSlackStatusResponse = """
        {
            "status":"ok",
            "date_created":"2022-03-24T14:23:10-07:00",
            "date_updated":"2022-03-24T14:23:10-07:00",
            "active_incidents":[]
        }
        """
    }

}
