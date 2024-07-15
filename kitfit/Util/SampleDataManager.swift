//
//  SampleDataManager.swift
//  kitfit
//
//  Created by 신병기 on 7/12/24.
//

import SwiftData
import SwiftUI

class SampleDataManager {
    static func addSampleData(to modelContext: ModelContext) {
        // 기존 데이터가 있는지 확인
        let kitDescriptor = FetchDescriptor<Kit>()
        guard (try? modelContext.fetch(kitDescriptor))?.isEmpty ?? true else {
            print("Sample data already exists")
            return
        }
        
        // 샘플 데이터 추가
        let sampleKits: [(Int, String, Int, String)] = [
            (1, "ULSAN", 1983, "HOME"),
            (2, "ULSAN", 1983, "AWAY"),
            (3, "ULSAN", 2024, "HOME"),
            (4, "ULSAN", 2024, "AWAY"),
            (5, "ULSAN", 2024, "THIRD"),
            (6, "Liverpool", 2023, "HOME"),
            (7, "Liverpool", 2023, "AWAY"),
            (8, "Liverpool", 2024, "HOME"),
            (9, "Real Madrid", 2023, "HOME"),
            (10, "Real Madrid", 2024, "HOME")
        ]
        
        for (id, club, year, name) in sampleKits {
            let kit = Kit(id: id, club: club, year: year, name: name)
            modelContext.insert(kit)
            
            addSampleKitSizes(for: kit, modelContext: modelContext)
        }
        
        // 변경사항 저장
        do {
            try modelContext.save()
        } catch {
            print("Failed to save sample data: \(error)")
        }
    }
    
    private static func addSampleKitSizes(for kit: Kit, modelContext: ModelContext) {
        let (sizes, regionCodes) = getSizesAndCodes(for: kit)
        
        for regionCode in regionCodes {
            for size in sizes {
                let kitSize = KitSize(
                    regionCode: regionCode,
                    sizeCode: size,
                    chestWidth: getRandomChestWidth(for: size),
                    frontLength: getRandomFrontLength(for: size),
                    backLength: getRandomBackLength(for: size)
                )
                kit.sizes.append(kitSize)
                modelContext.insert(kitSize)
            }
        }
    }
    
    private static func getSizesAndCodes(for kit: Kit) -> ([String], [String]) {
        switch kit.id {
        case 1: return (["S", "M", "L", "XL", "2XL", "3XL"], ["KR"])
        case 2: return (["S", "L", "XL", "3XL"], ["KR"])
        case 3: return (["S", "M", "L", "XL", "2XL", "3XL"], ["KR"])
        case 4: return (["S", "L", "XL", "3XL"], ["KR"])
        case 5: return (["M", "L", "XL", "2XL", "4XL"], ["KR"])
        case 6: return (["S", "M", "L", "XL", "2XL", "3XL", "4XL"], ["KR", "EU"])
        case 7: return (["S", "M", "L", "XL", "2XL", "3XL", "4XL"], ["KR", "EU"])
        case 8: return (["S", "M", "L", "XL", "2XL", "3XL"], ["KR", "EU"])
        case 9: return (["XS", "S", "L", "XL", "2XL", "3XL", "4XL", "5XL"], ["EU"])
        default: return (["XS", "S", "L", "XL", "2XL", "3XL", "4XL", "5XL"], ["EU"])
        }
    }
    
    private static func getRandomChestWidth(for size: String) -> Double {
        switch size {
        case "XS": return Double.random(in: 40...44)
        case "S":  return Double.random(in: 44...48)
        case "M":  return Double.random(in: 48...52)
        case "L":  return Double.random(in: 52...56)
        case "XL": return Double.random(in: 56...60)
        case "2XL":return Double.random(in: 60...64)
        default:   return Double.random(in: 50...54)
        }
    }
    
    private static func getRandomFrontLength(for size: String) -> Double {
        // 사이즈별 적절한 범위 설정
        switch size {
        case "XS": return Double.random(in: 65...68)
        case "S":  return Double.random(in: 68...71)
        case "M":  return Double.random(in: 71...74)
        case "L":  return Double.random(in: 74...77)
        case "XL": return Double.random(in: 77...80)
        case "2XL":return Double.random(in: 80...83)
        default:   return Double.random(in: 72...75)
        }
    }
    
    private static func getRandomBackLength(for size: String) -> Double {
        // 사이즈별 적절한 범위 설정 (일반적으로 앞길이보다 약간 길게)
        switch size {
        case "XS": return Double.random(in: 67...70)
        case "S":  return Double.random(in: 70...73)
        case "M":  return Double.random(in: 73...76)
        case "L":  return Double.random(in: 76...79)
        case "XL": return Double.random(in: 79...82)
        case "2XL":return Double.random(in: 82...85)
        default:   return Double.random(in: 74...77)
        }
    }
}
