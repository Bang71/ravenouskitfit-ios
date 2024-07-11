//
//  Uniform.swift
//  kitfit
//
//  Created by 신병기 on 6/20/24.
//

import SwiftUI

struct Uniform: Codable, Identifiable {
    var id = UUID()
    var club: String
    var year: Int
    var kit: String
    var regionCode: String
    var size: String
    
    static let clubs = ["ULSAN HD", "LIVERPOOL"]
    static let kits = ["HOME", "AWAY", "THIRD", "CLASSIC", "BRAND"]
    static let regionCodes = ["KR", "EUR", "US", "CH", "JP"]
    static let sizes = ["XS", "S", "M", "L", "XL", "2XL", "3XL"]
}
