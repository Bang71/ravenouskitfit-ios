//
//  KitSize.swift
//  kitfit
//
//  Created by 신병기 on 7/12/24.
//

import Foundation
import SwiftData

@Model
final class KitSize {
    @Attribute(.unique) var id: UUID
    var regionCode: String
    var sizeCode: String
    var chestWidth: Double
    var frontLength: Double
    var backLength: Double
    
    @Relationship(inverse: \Kit.sizes) var kit: Kit?
    
    init(regionCode: String, sizeCode: String, chestWidth: Double, frontLength: Double, backLength: Double) {
        self.id = UUID()
        self.regionCode = regionCode
        self.sizeCode = sizeCode
        self.chestWidth = chestWidth
        self.frontLength = frontLength
        self.backLength = backLength
    }
}
