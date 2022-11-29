//
//  MyDate.swift
//  SemesterProject
//
//  Created by Hana Bredstein on 11/29/22.
//

import Foundation
import CoreData

class MyDate : NSManagedObject{
    
    var name:String!
    var date:Date!
    var dateID:NSManagedObjectID?
}
