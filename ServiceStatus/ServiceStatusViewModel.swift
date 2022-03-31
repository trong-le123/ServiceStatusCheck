import Foundation

// Slack Status
struct SlackSystemService: Codable, Identifiable {
    init(status: String?, dateCreated: String?, dateUpdated: String?, activeIncidents: [SlackActiveIncidents]) {
        self.id = UUID()
        self.status = status
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
        self.activeIncidents = activeIncidents
    }
    
    let id: UUID?
    let status: String?
    let dateCreated: String?
    let dateUpdated: String?
    let activeIncidents: [SlackActiveIncidents]
}


struct SlackActiveIncidents: Codable, Identifiable {
    let id: UUID?
    let date_created: String
    let date_updated: String
    let title: String
    let type: String
    let status: String
    let url: String
}

// Github Status
struct GithubSystemService: Codable, Identifiable {
    init(page: Page, components: [GithubSystemServiceComponents]) {
        self.id = UUID()
        self.page = page
        self.components = components
    }
    
    let id: UUID?
    let page: Page
    let components: [GithubSystemServiceComponents]
}

struct Page: Codable, Identifiable {
    let id: String
    let name: String
    let url: String
    let timeZone: String
    let updatedAt: String
}

struct GithubSystemServiceComponents: Codable, Identifiable {
    let id: String?
    let name: String?
    let status: String?
    let createdAt: String?
    let updatedAt: String?
    let position: Int?
    let description: String?
}

class ServiceStatusViewModel: ObservableObject {
    
    @Published var slackSystemStatus: [SlackSystemService] = []
    @Published var githubSystemStatus: [GithubSystemServiceComponents] = []
        
    let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager.sharedInstance) {
        self.networkManager = networkManager
    }
    
    func fetchSlackSystemStatus() async -> [SlackSystemService] {
        return await networkManager.fetchSlackServiceStatus()
    }
    
    func fetchGithubSystemStatus() async -> [GithubSystemServiceComponents] {
        return await networkManager.fetchGithubServiceStatus()
    }
}
