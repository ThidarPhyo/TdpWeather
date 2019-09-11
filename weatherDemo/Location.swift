//
//  Location.swift
//  weatherDemo
//
//  Created by Thidar Phyo on 9/6/19.
//  Copyright © 2019 Thidar Phyo. All rights reserved.
//

import Foundation

class Location {
    static var sharedInstance = Location()
    var longitude: Double!
    var latitude: Double!
}
