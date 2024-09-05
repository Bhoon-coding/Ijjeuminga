//
//  RecentBusInfo+CoreDataProperties.swift
//  Ijjeuminga
//
//  Created by 조성빈 on 7/21/24.
//
//

import Foundation
import CoreData


extension RecentBusInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentBusInfo> {
        return NSFetchRequest<RecentBusInfo>(entityName: "RecentBusInfo")
    }

    @NSManaged public var busNumer: String?
    @NSManaged public var routeId: String?
    @NSManaged public var type: Int32
    @NSManaged public var lastDate: String?

}

extension RecentBusInfo : Identifiable {

}
