//
//  Device.swift
//  myDevices
//
//  Created by Aleksandr Pronin on 4/30/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import CoreData


class Device: NSManagedObject {
    
    var deviceDescription: String {
        return "\(name) (\(deviceType))"
    }
    
}
