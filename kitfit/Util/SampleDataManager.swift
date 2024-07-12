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
        }

        // 변경사항 저장
        do {
            try modelContext.save()
        } catch {
            print("Failed to save sample data: \(error)")
        }
    }
}
