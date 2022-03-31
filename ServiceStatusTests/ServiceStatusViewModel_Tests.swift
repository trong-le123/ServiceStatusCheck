import XCTest
@testable import ServiceStatus
// Naming Structure: test_UnitOfWork_StateUnderTest_ExpectedBehavoir
// Testing Structure: Given, When, Then

class ServiceStatusViewModel_Tests: XCTestCase {
    let vm = ServiceStatusViewModel()
    let mockNetworkManager = NetworkMock()
        
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_ServiceStatusViewModel_FetchSlackStatus_shouldReturnTrue() async throws {
        let mockViewModel = ServiceStatusViewModel(networkManager: mockNetworkManager)
        let mockedResponse = await mockViewModel.fetchSlackSystemStatus()
        
        XCTAssertNotNil(mockedResponse)
        
        let getFirstResponseItem = mockedResponse.first
        
        XCTAssertEqual(getFirstResponseItem?.status, "ok")
        XCTAssertEqual(getFirstResponseItem?.dateCreated, "2018-09-07T18:34:15-07:00")
        XCTAssertEqual(getFirstResponseItem?.dateUpdated, "2018-09-07T18:34:15-07:00")

    }
    
    func test_ServiceStatusViewModel_FetchGithubStatus_shouldReturnTrue() async throws {
        let mockViewModel = ServiceStatusViewModel(networkManager: mockNetworkManager)
        let mockedResponse = await mockViewModel.fetchGithubSystemStatus()
        
        XCTAssertNotNil(mockedResponse)
        
        let getFirstResponseItem = mockedResponse.first

        XCTAssertEqual(getFirstResponseItem?.status, "partial_outage")
        XCTAssertEqual(getFirstResponseItem?.name, "API Requests")
        XCTAssertEqual(getFirstResponseItem?.description, "Requests for GitHub APIs")


    }
}
