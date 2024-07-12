//
//  Kit.swift
//  kitfit
//
//  Created by 신병기 on 7/12/24.
//

import Foundation
import SwiftData

@Model
final class Kit {
    @Attribute(.unique) var id: Int
    var club: String
    var year: Int
    var name: String
    @Relationship(deleteRule: .cascade) var sizes: [KitSize] = []

    init(id: Int, club: String, year: Int, name: String) {
        self.id = id
        self.club = club
        self.year = year
        self.name = name
    }
}
