//
//  constants.swift
//  FMAD
//
//  Created by Aritro Paul on 11/10/18.
//  Copyright © 2018 NotACoder. All rights reserved.
//

import Foundation
import UIKit

let grayColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
let almostWhite = UIColor(red: 250/255, green: 250/255, blue: 242/255, alpha: 1)

struct DeskLocations : Decodable {
    var lat: Double
    var long: Double
    var price : Double
    var id : String
    var name : String
    var address: String
    var desks : Int
}

struct Locations : Decodable {
    var data : [DeskLocations]
}
