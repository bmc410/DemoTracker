//
//  Person+CoreDataProperties.swift
//  DemographicsTracker
//
//  Created by Bill McCoy on 5/23/16.
//  Copyright © 2016 WellSpan Health. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Person {

    @NSManaged var personID: NSNumber?
    @NSManaged var mrn: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var personAddr: Address?

}
