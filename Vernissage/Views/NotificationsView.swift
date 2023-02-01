//
//  https://mczachurski.dev
//  Copyright © 2023 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//
    
import SwiftUI
import MastodonKit

struct NotificationsView: View {
    @EnvironmentObject var applicationState: ApplicationState

    @State var accountId: String
    @State private var notifications: [MastodonKit.Notification] = []
    @State private var allItemsLoaded = false
    @State private var state: ViewState = .loading
    
    @State private var minId: String?
    @State private var maxId: String?
    
    private let defaultPageSize = 40
    
    var body: some View {
        self.mainBody()
            .navigationBarTitle("Notifications")
    }
    
    @ViewBuilder
    private func mainBody() -> some View {
        switch state {
        case .loading:
            LoadingIndicator()
                .task {
                    await self.loadNotifications()
                }
        case .loaded:
            if self.notifications.isEmpty {
                NoDataView(imageSystemName: "bell", text: "Unfortunately, there is nothing here.")
            } else {
                List {
                    ForEach(notifications, id: \.id) { notification in
                        NotificationRow(notification: notification)
                    }
                    
                    if allItemsLoaded == false {
                        HStack {
                            Spacer()
                            LoadingIndicator()
                                .task {
                                    await self.loadMoreNotifications()
                                }
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    await self.loadNewNotifications()
                }
            }
        case .error(let error):
            ErrorView(error: error) {
                self.state = .loading
                await self.loadMoreNotifications()
            }
            .padding()
        }
    }
    
    func loadNotifications() async {
        do {            
            let linkable = try await NotificationService.shared.notifications(
                for: self.applicationState.account,
                maxId: maxId,
                minId: minId,
                limit: 5)

            self.minId = linkable.link?.minId
            self.maxId = linkable.link?.maxId
            self.notifications = linkable.data
            
            if linkable.data.isEmpty {
                self.allItemsLoaded = true
            }
            
            self.state = .loaded
        } catch {
            if !Task.isCancelled {
                ErrorService.shared.handle(error, message: "Error during download notifications from server.", showToastr: true)
                self.state = .error(error)
            } else {
                ErrorService.shared.handle(error, message: "Error during download notifications from server.", showToastr: false)
            }
        }
    }
    
    private func loadMoreNotifications() async {
        do {
            let linkable = try await NotificationService.shared.notifications(
                for: self.applicationState.account,
                maxId: self.maxId,
                limit: self.defaultPageSize)

            self.maxId = linkable.link?.maxId
            self.notifications.append(contentsOf: linkable.data)

            if linkable.data.isEmpty {
                self.allItemsLoaded = true
            }
        } catch {
            ErrorService.shared.handle(error, message: "Error during download notifications from server.", showToastr: !Task.isCancelled)
        }
    }
    
    private func loadNewNotifications() async {
        do {
            let linkable = try await NotificationService.shared.notifications(
                for: self.applicationState.account,
                minId: self.minId,
                limit: self.defaultPageSize)
            
            if let first = linkable.data.first, self.notifications.contains(where: { notification in notification.id == first.id }) {
                // We have all notifications, we don't have to do anything.
                return
            }
            
            self.minId = linkable.link?.minId
            self.notifications.insert(contentsOf: linkable.data, at: 0)
        } catch {
            ErrorService.shared.handle(error, message: "Error during download notifications from server.", showToastr: !Task.isCancelled)
        }
    }
}
