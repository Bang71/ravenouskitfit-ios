//
//  KitDataManager.swift
//  kitfit
//
//  Created by 신병기 on 7/12/24.
//

import Foundation
import SwiftData

@MainActor
class KitDataManager {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addKit(id: Int, club: String, year: Int, name: String) throws {
        let kit = Kit(id: id, club: club, year: year, name: name)
        modelContext.insert(kit)
    }
    
    func addKitSize(kitId: Int, regionCode: String, sizeCode: String, chestWidth: Double, frontLength: Double, backLength: Double) throws {
        guard let kit = try getKit(id: kitId) else {
            throw KitDataError.kitNotFound
        }
        
        let size = KitSize(regionCode: regionCode, sizeCode: sizeCode, chestWidth: chestWidth, frontLength: frontLength, backLength: backLength)
        kit.sizes.append(size)
        size.kit = kit
    }
    
    func getKit(id: Int) throws -> Kit? {
        let descriptor = FetchDescriptor<Kit>(predicate: #Predicate { $0.id == id })
        return try modelContext.fetch(descriptor).first
    }
    
    func getKits(for club: String, in year: Int) throws -> [Kit] {
        let descriptor = FetchDescriptor<Kit>(predicate: #Predicate { $0.club == club && $0.year == year })
        return try modelContext.fetch(descriptor)
    }
    
    func getKitSizes(for kitId: Int) throws -> [KitSize] {
        guard let kit = try getKit(id: kitId) else {
            throw KitDataError.kitNotFound
        }
        return kit.sizes
    }
    
    func getAllClubs() async throws -> [String] {
        let descriptor = FetchDescriptor<Kit>(sortBy: [SortDescriptor(\.club)])
        let kits = try modelContext.fetch(descriptor)
        return Array(Set(kits.map { $0.club })).sorted()
    }
    
    func getYears(for club: String) async throws -> [Int] {
        let descriptor = FetchDescriptor<Kit>(
            predicate: #Predicate { $0.club == club }
        )
        let kits = try modelContext.fetch(descriptor)
        return Array(Set(kits.map { $0.year })).sorted(by: <)
    }
    
    func getKitNames(for club: String, in year: Int) async throws -> [String] {
        let descriptor = FetchDescriptor<Kit>(
            predicate: #Predicate { $0.club == club && $0.year == year }
        )
        let kits = try modelContext.fetch(descriptor)
        return kits.map { $0.name }
    }
    
    func getRegionCodes(for club: String, year: Int, kitName: String) async throws -> [String] {
        let descriptor = FetchDescriptor<Kit>(predicate: #Predicate {
            $0.club == club && $0.year == year && $0.name == kitName
        })
        let kit = try modelContext.fetch(descriptor).first
        let regionCodes = Set(kit?.sizes.map { $0.regionCode } ?? [])
        return Array(regionCodes).sorted()
    }
    
    func getSizeCodes(for club: String, year: Int, kitName: String, regionCode: String) async throws -> [String] {
        let descriptor = FetchDescriptor<Kit>(predicate: #Predicate {
            $0.club == club && $0.year == year && $0.name == kitName
        })
        let kit = try modelContext.fetch(descriptor).first
        let sizeCodes = kit?.sizes.filter { $0.regionCode == regionCode }.map { $0.sizeCode } ?? []
        return sizeCodes.sorted()
    }
    
    enum KitDataError: Error {
        case kitNotFound
    }
}
