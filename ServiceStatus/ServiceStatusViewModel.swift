import Foundation

// Slack Status
struct SlackSystemService: Codable, Identifiable {
    let id = UUID()
    let status: String?
    let date_created: String?
    let date_updated: String?
    let active_incidents: [SlackActiveIncidents]

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case date_created = "date_created"
        case date_updated = "date_updated"
        case active_incidents = "active_incidents"
    }
}


struct SlackActiveIncidents: Codable, Identifiable {
    let id = UUID()
    let date_created: String
    let date_updated: String
    let title: String
    let type: String
    let status: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case date_created = "date_created"
        case date_updated = "date_updated"
        case title = "title"
        case type = "type"
        case status = "status"
        case url = "url"
    }
}

// Github Status
struct GithubSystemService: Codable, Identifiable {
    let id = UUID()
    let page: Page
    let components: [GithubSystemServiceComponents]

    enum CodingKeys: String, CodingKey {
        case components = "components"
        case page = "page"
    }
}

struct Page: Codable, Identifiable {
    let id: String
    let name: String
    let url: String
    let time_zone: String
    let updated_at: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case url = "url"
        case time_zone = "time_zone"
        case updated_at = "updated_at"
    }
}

struct GithubSystemServiceComponents: Codable, Identifiable {
    let id: String?
    let name: String?
    let status: String?
    let created_at: String?
    let updated_at: String?
    let position: Int?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case status = "status"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case position = "position"
        case description = "description"
    }
}

class ServiceStatusViewModel: ObservableObject {
    
    @Published var slackSystemStatus: [SlackSystemService] = []
    @Published var githubSystemStatus: [GithubSystemServiceComponents] = []
    
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    var slackSystemStatusURL = "https://status.slack.com/api/v2.0.0/current"
    var githubSystemStatusURL = "https://www.githubstatus.com/api/v2/components.json"
    
    func fetchSlackSystemStatus() async -> [SlackSystemService] {
        
        guard let url = URL(string: slackSystemStatusURL) else {
            return []
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("\(#function) \(response)")
                return []
            }
            
            let statusData = try JSONDecoder().decode(SlackSystemService.self, from: data)
            return [statusData]
        } catch {
            showErrorAlert = true
            errorMessage = ("Error: \(error.localizedDescription)")
            print("\(#function) \(error)")
            return []
        }
    }
    
    func fetchGithubSystemStatus() async -> [GithubSystemServiceComponents] {
        
        guard let url = URL(string: githubSystemStatusURL) else {
            return []
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("\(#function) \(response)")
                return []
            }
            
            let statusData = try JSONDecoder().decode(GithubSystemService.self, from: data)

            return statusData.components
        } catch {
            showErrorAlert = true
            errorMessage = ("Error: \(error)")
            print("\(#function) \(error)")
            return []
        }
    }
}
