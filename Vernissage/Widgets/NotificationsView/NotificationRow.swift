//
//  https://mczachurski.dev
//  Copyright © 2023 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//

import SwiftUI
import MastodonKit
import NukeUI

struct NotificationRow: View {
    @EnvironmentObject var applicationState: ApplicationState

    @State public var notification: MastodonKit.Notification
    
    private let contentWidth = Int(UIScreen.main.bounds.width) - 150
    
    var body: some View {
        HStack (alignment: .top, spacing: 8) {
            ZStack {
                HStack {
                    Spacer()
                    UserAvatar(accountId: self.notification.account.id, accountAvatar: self.notification.account.avatar, width: 48, height: 48)
                }
                self.notificationBadge()
            }
            .frame(width: 56, height: 56)
            
            VStack (alignment: .leading, spacing: 0) {
                HStack (alignment: .top) {
                    Text(self.notification.account.displayNameWithoutEmojis)
                        .foregroundColor(.mainTextColor)
                        .font(.footnote)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text(self.notification.createdAt.toRelative(.isoDateTimeMilliSec))
                        .foregroundColor(.lightGrayColor)
                        .font(.footnote)
                }

                Text(self.getTitle())
                    .foregroundColor(.lightGrayColor)
                    .font(.footnote)
                    .fontWeight(.light)
                
                
                switch self.notification.type {
                case .favourite, .reblog, .mention:
                    if let status = self.notification.status, let statusViewModel = StatusViewModel(status: status) {
                        HStack(alignment: .top) {
                            Spacer()
                            if let attachment = statusViewModel.mediaAttachments.filter({ attachment in
                                attachment.type == Attachment.AttachmentType.image
                            }).first {
                                if let cachedImage = CacheImageService.shared.getImage(for: attachment.id) {
                                    cachedImage
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                } else {
                                    EmptyView()
                                }
                            } else {
                                EmptyView()
                            }
                        }
                    }
                case .follow:
                    if let note = self.notification.account.note {
                        HTMLFormattedText(note, withFontSize: 12, andWidth: contentWidth)
                            .padding(.top, -4)
                            .padding(.leading, -4)
                    } else {
                        EmptyView()
                    }
                }
            }
        }
    }
    
    private func notificationBadge() -> some View {
        VStack {
            HStack {
                ZStack {
                    Circle()
                        .strokeBorder(Color.white.opacity(0.85), lineWidth: 2)
                        .background(Circle().fill(self.getColor().opacity(0.85)))
                        .frame(width: 28, height: 28)
                    Image(systemName: self.getImage())
                        .foregroundColor(.white)
                        .font(.caption)
                        .fontWeight(.bold)
                }
                Spacer()
            }
            Spacer()
        }
    }
    
    private func getTitle() -> String {
        switch notification.type {
        case .follow:
            return "followed you"
        case .mention:
            return "mentioned you"
        case .reblog:
            return "boosted"
        case .favourite:
            return "favourited"
        }
    }
    
    private func getImage() -> String {
        switch notification.type {
        case .follow:
            return "person.badge.plus"
        case .mention:
            return "at"
        case .reblog:
            return "paperplane"
        case .favourite:
            return "hand.thumbsup"
        }
    }
    
    private func getColor() -> Color {
        switch notification.type {
        case .follow:
            return Color.accentColor3
        case .mention:
            return Color.accentColor4
        case .reblog:
            return Color.accentColor5
        case .favourite:
            return Color.accentColor6
        }
    }
}
