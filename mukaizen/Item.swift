//
//  Item.swift
//  mukaizen
//
//  Created by 田口友暉 on 2026/02/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
