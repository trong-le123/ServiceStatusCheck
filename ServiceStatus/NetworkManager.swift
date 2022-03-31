import Foundation

protocol NetworkProtocol: AnyObject {
    func fetchSlackServiceStatus() async -> [SlackSystemService]
    func fetchGithubServiceStatus() async -> [GithubSystemServiceComponents]
}

class NetworkManager {
    static let sharedInstance = NetworkManager()
    
    private init() {}
}

extension NetworkManager: NetworkProtocol {
    
    func fetchSlackServiceStatus() async -> [SlackSystemService] {
        let slackSystemStatusURL = "https://status.slack.com/api/v2.0.0/current"

        guard let url = URL(string: slackSystemStatusURL) else {
            return []
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("\(#function) \(response)")
                return []
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let statusData = try decoder.decode(SlackSystemService.self, from: data)
            return [statusData]
        } catch {
            print("\(#function) \(error)")
            return []
        }
    }
    
    func fetchGithubServiceStatus() async -> [GithubSystemServiceComponents] {
        let githubSystemStatusURL = "https://www.githubstatus.com/api/v2/components.json"

        guard let url = URL(string: githubSystemStatusURL) else {
            return []
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                print("\(#function) \(response)")
                return []
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let statusData = try decoder.decode(GithubSystemService.self, from: data)

            return statusData.components
        } catch {
            print("\(#function) \(error)")
            return []
        }
    }
}

class NetworkMock: NetworkProtocol {
    func fetchSlackServiceStatus() async -> [SlackSystemService] {
        let mockResponse = SlackSystemService(
            status: "ok",
            dateCreated: "2018-09-07T18:34:15-07:00",
            dateUpdated: "2018-09-07T18:34:15-07:00",
            activeIncidents: []
        )
        
        return [mockResponse]
    }
    
    func fetchGithubServiceStatus() async -> [GithubSystemServiceComponents]{
        let mockResponse = GithubSystemServiceComponents(
            id: "b13yz5g2cw10",
            name: "API Requests",
            status: "partial_outage",
            createdAt: "2014-05-03T01:22:07.274Z",
            updatedAt: "2014-05-14T20:34:43.340Z",
            position: 1,
            description: "Requests for GitHub APIs"
        )
        
        return [mockResponse]
    }
}
