import SwiftUI

struct ServiceStatusView: View {
    
    @StateObject var serviceStatusViewModel = ServiceStatusViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("Background").opacity(0.5), Color("Background")]), startPoint: .bottom, endPoint: .top)
                    .edgesIgnoringSafeArea(.all)
                GeometryReader { geo in
                    ScrollView {
                        VStack {
                            Divider().padding(.horizontal)
                            ForEach(serviceStatusViewModel.slackSystemStatus) { status in
                                SlackStatusCardView(geo: geo, status: status)
                            }
                            Spacer()
                            Divider().padding(.horizontal)
                            Text("Github Services").fontWeight(.semibold)
                            ForEach(serviceStatusViewModel.githubSystemStatus) { status in
                                GithubStatusCardView(geo: geo, status: status)
                            }
                            Spacer()
                        }
                        .task {
                            serviceStatusViewModel.slackSystemStatus = await serviceStatusViewModel.fetchSlackSystemStatus()
                            serviceStatusViewModel.githubSystemStatus = await serviceStatusViewModel.fetchGithubSystemStatus()
                        }
                    }
                }
            }
            .navigationTitle("Service Status")
        }
    }
}

struct SlackStatusCardView: View {
    
    let geo: GeometryProxy
    let status: SlackSystemService
    let circleSize: CGFloat = 50
    
    @State var isAnimating = false
    
    var body: some View {
        VStack {
            let frame = geo.frame(in: CoordinateSpace.local)
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 13)
                    .fill(Color("StatusCard"))
                    .padding(.horizontal)
                    .shadow(radius: 6)
                Circle()
                    .fill(Color("StatusCard"))
                    .background(
                        Circle()
                            .stroke(Color("StatusCard"), lineWidth: 2)
                            .background(
                                Circle()
                                    .fill(Color.blue)
                            )
                    )
                    .frame(width: circleSize, height: circleSize, alignment: .center)
                    .shadow(radius: 12)
                    .overlay(
                        VStack {
                            if status.active_incidents.count > 0 {
                                Image(systemName: "exclamationmark.icloud.fill")
                                    .font(.system(size: 29))
                                    .foregroundColor(Color("nord11"))
                                    .scaleEffect(self.isAnimating ? 1.2: 0.8)
                                    .animation(Animation.easeInOut(duration: 0.5).delay(0.5).repeatForever(), value: 1.0)
                                    .onAppear {
                                        self.isAnimating = true
                                    }
                            } else {
                                Image(systemName: "checkmark.icloud.fill")
                                   .font(.system(size: 29))
                                   .foregroundColor(Color("nord14"))
                            }
                        }
                    ).offset(y: frame.origin.y - circleSize / 2)
                
                HStack {
                    VStack(alignment: .center) {
                        Text("Slack").fontWeight(.semibold)
                        HStack {
                            Spacer()
                            Text("Last Update:")
                                .font(.subheadline)
                                .fontWeight(.thin)
                            Text(formatDate(date: Date()))
                                .font(.subheadline)
                                .fontWeight(.thin)
                                .padding(.top, 3)
                            Spacer()
                        }
                        if status.active_incidents.count > 0 {
                            Divider().padding(.horizontal, 20)
                            ForEach(status.active_incidents) { incidents in
                                VStack {
                                    AffectedServiceStatusView(string: "Type:", status: incidents.type)
                                    AffectedServiceStatusView(string: "Start Date:", status: incidents.date_created)
                                    AffectedServiceStatusView(string: "End Date:", status: incidents.date_updated)
                                    AffectedServiceStatusView(string: "Incident Status:", status: incidents.status)
                                    AffectedServiceStatusView(string: "Message:", status: incidents.title)
                                }.padding(.top, 8)
                            }
                        }
                    }
                    .padding(.top, 18)
                }
                .padding(.vertical)
                .padding(.horizontal, 26)
            }
        }
        .padding(.vertical, circleSize / 2)
    }
}

struct GithubStatusCardView: View {
    
    let geo: GeometryProxy
    let status: GithubSystemServiceComponents
    let circleSize: CGFloat = 50
    
    @State var isAnimating = false
    
    var body: some View {
        VStack {
            let frame = geo.frame(in: CoordinateSpace.local)
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 13)
                    .fill(Color("StatusCard"))
                    .padding(.horizontal)
                    .shadow(radius: 6)
                Circle()
                    .fill(Color("StatusCard"))
                    .background(
                        Circle()
                            .stroke(Color("StatusCard"), lineWidth: 2)
                            .background(
                                Circle()
                                    .fill(Color.blue)
                            )
                    )
                    .frame(width: circleSize, height: circleSize, alignment: .center)
                    .shadow(radius: 12)
                    .overlay(
                        VStack {
                            switch status.status {
                            case "operational":
                                Image(systemName: "checkmark.icloud.fill")
                                   .font(.system(size: 29))
                                   .foregroundColor(Color("nord14"))
                            case "degraded_performance":
                                Image(systemName: "exclamationmark.icloud.fill")
                                    .font(.system(size: 29))
                                    .foregroundColor(Color("nord13"))
                                    .scaleEffect(self.isAnimating ? 1.2: 0.8)
                                    .animation(Animation.easeInOut(duration: 0.5).delay(0.5).repeatForever(), value: 1.0)
                                    .onAppear {
                                        self.isAnimating = true
                                    }
                            case "partial_outage":
                                Image(systemName: "exclamationmark.icloud.fill")
                                    .font(.system(size: 29))
                                    .foregroundColor(Color("nord12"))
                                    .scaleEffect(self.isAnimating ? 1.2: 0.8)
                                    .animation(Animation.easeInOut(duration: 0.5).delay(0.5).repeatForever(), value: 1.0)
                                    .onAppear {
                                        self.isAnimating = true
                                    }
                            case "major_outage":
                                Image(systemName: "exclamationmark.icloud.fill")
                                    .font(.system(size: 29))
                                    .foregroundColor(Color("nord11"))
                                    .scaleEffect(self.isAnimating ? 1.2: 0.8)
                                    .animation(Animation.easeInOut(duration: 0.5).delay(0.5).repeatForever(), value: 1.0)
                                    .onAppear {
                                        self.isAnimating = true
                                    }
                            default:
                                Image(systemName: "questionmark.circle.fill")
                                   .font(.system(size: 29))
                                   .foregroundColor(Color("nord0"))
                            }
                        }
                    ).offset(y: frame.origin.y - circleSize / 2)
                
                HStack {
                    VStack(alignment: .center) {
                        Text(status.name ?? "").fontWeight(.semibold)
                        HStack {
                            Spacer()
                            Text("Last Update:")
                                .font(.subheadline)
                                .fontWeight(.thin)
                            Text(formatDate(date: Date()))
                                .font(.subheadline)
                                .fontWeight(.thin)
                                .padding(.top, 3)
                            Spacer()
                        }
                    }
                    .padding(.top, 18)
                }
                .padding(.vertical)
                .padding(.horizontal, 26)
            }
        }
        .padding(.vertical, circleSize / 2)
    }
}

struct AffectedServiceStatusView: View {
    let string: String
    let status: String
    
    var body: some View {
        HStack {
            Text(string)
            Spacer()
            Text(status)
        }
        .font(.caption)
        .foregroundColor(.secondary)
        .padding(.vertical, 0.04)
        .padding(.horizontal, 25)
    }
}

func formatDate(date: Date) -> String {
    let date = date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter.string(from: date)
}

struct ServiceStatusView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceStatusView()
        ServiceStatusView().colorScheme(.dark)
    }
}
