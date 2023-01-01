//
//  https://mczachurski.dev
//  Copyright © 2023 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//
    
//

import Foundation
import CoreData


extension AttachmentData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AttachmentData> {
        return NSFetchRequest<AttachmentData>(entityName: "AttachmentData")
    }

    @NSManaged public var blurhash: String?
    @NSManaged public var data: Data
    @NSManaged public var id: String
    @NSManaged public var previewUrl: URL?
    @NSManaged public var remoteUrl: URL?
    @NSManaged public var statusId: String
    @NSManaged public var text: String?
    @NSManaged public var type: String
    @NSManaged public var url: URL
    @NSManaged public var statusRelation: StatusData?

}

extension AttachmentData : Identifiable {

}