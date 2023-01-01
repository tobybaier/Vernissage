//
//  https://mczachurski.dev
//  Copyright © 2023 Marcin Czachurski and the repository contributors.
//  Licensed under the MIT License.
//
    

import Foundation

class StatusDataHandler {
    func getStatusesData() -> [StatusData] {
        let context = CoreDataHandler.shared.container.viewContext
        let fetchRequest = StatusData.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error during fetching accounts")
            return []
        }
    }
    
    func getMaximumStatus() -> StatusData? {
        let context = CoreDataHandler.shared.container.viewContext
        let fetchRequest = StatusData.fetchRequest()

        fetchRequest.fetchLimit = 1
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let statuses = try context.fetch(fetchRequest)
            return statuses.first
        } catch {
            return nil
        }
    }
    
    func createStatusDataEntity() -> StatusData {
        let context = CoreDataHandler.shared.container.viewContext
        return StatusData(context: context)
    }
}