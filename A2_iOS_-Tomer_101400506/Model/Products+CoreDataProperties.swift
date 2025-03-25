//
//  Products+CoreDataProperties.swift
//  A2_iOS_-Tomer_101400506
//
//  Created by user271259 on 3/24/25.
//
//

import Foundation
import CoreData


extension Products {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Products> {
        return NSFetchRequest<Products>(entityName: "Products")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var provider: String?
    @NSManaged public var desc: String?
    @NSManaged public var price: Double

}

extension Products : Identifiable {

}
