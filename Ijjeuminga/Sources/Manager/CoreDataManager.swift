//
//  CoreManager.swift
//  Ijjeuminga
//
//  Created by 조성빈 on 7/7/24.
//

import UIKit
import CoreData

struct CoreDataManager {
    static var shared: CoreDataManager = CoreDataManager()
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "RecentBusInfo"
    
    mutating func getBusList() -> [RecentBusInfo] {
        var busList = [RecentBusInfo]()
        
        if let context = self.context {
            let dateSort = NSSortDescriptor(key: "lastDate", ascending: false)
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            fetchRequest.sortDescriptors = [dateSort]
            
            do {
                if let fetchResult = try context.fetch(fetchRequest) as? [RecentBusInfo] {
                    busList = fetchResult
                }
            } catch let error as NSError {
                print("\(error.userInfo)")
            }
        }
        
        return busList
    }
    
    mutating func saveBusInfo(busNumber: String, routeId: String, type: Int32, lastDate: String, onSuccess: @escaping ((Bool) -> Void)) {
        if let context = self.context, let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
            
            if let bus: RecentBusInfo = NSManagedObject(entity: entity, insertInto: context) as? RecentBusInfo {
                bus.busNumer = busNumber
                bus.routeId = routeId
                bus.type = type
                bus.lastDate = lastDate
                
                self.contextSave { success in
                    onSuccess(success)
                }
            }
        }
    }
    
    mutating func deleteBusInfo(id: Int64, onSuccess: @escaping ((Bool) -> Void)) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(id: id)
        
        do {
            if let results: [NSManagedObject] = try context?.fetch(fetchRequest) as? [NSManagedObject] {
                if results.count != 0 {
                    context?.delete(results[0])
                }
            }
        } catch let error as NSError {
            print("Could not fatch🥺: \(error), \(error.userInfo)")
            onSuccess(false)
        }
        
        contextSave { success in
            onSuccess(success)
        }
    }
}

extension CoreDataManager {
    fileprivate func filteredRequest(id: Int64) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
            = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        return fetchRequest
    }
    
    fileprivate mutating func contextSave(onSuccess: ((Bool) -> Void)) {
        do {
            try context?.save()
            onSuccess(true)
        } catch let error as NSError {
            print("Could not save🥶: \(error), \(error.userInfo)")
            onSuccess(false)
        }
    }
}
