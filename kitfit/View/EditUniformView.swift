//
//  EditUniformView.swift
//  kitfit
//
//  Created by 신병기 on 6/20/24.
//

import SwiftUI
import SwiftData

struct EditUniformView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: UniformViewModel
    @Binding var uniform: Uniform?
    @Binding var isPresented: Bool
    
    @State private var selectedClub: String = ""
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedKit: String = ""
    @State private var selectedRegionCode: String = ""
    @State private var selectedSizeCode: String = ""
    
    @State private var availableClubs: [String] = []
    @State private var availableYears: [Int] = []
    @State private var availableKits: [String] = []
    @State private var availableRegionCodes: [String] = []
    @State private var availableSizeCodes: [String] = []
    
    private let kitDataManager: KitDataManager
    
    init(viewModel: UniformViewModel, uniform: Binding<Uniform?>, isPresented: Binding<Bool>, modelContext: ModelContext) {
        self.viewModel = viewModel
        self._uniform = uniform
        self._isPresented = isPresented
        self.kitDataManager = KitDataManager(modelContext: modelContext)
        
        if let uniformValue = uniform.wrappedValue {
            _selectedClub = State(initialValue: uniformValue.club)
            _selectedYear = State(initialValue: uniformValue.year)
            _selectedKit = State(initialValue: uniformValue.kit)
            _selectedRegionCode = State(initialValue: uniformValue.regionCode)
            _selectedSizeCode = State(initialValue: uniformValue.sizeCode)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("유니폼 정보")) {
                    Picker("구단", selection: $selectedClub) {
                        ForEach(availableClubs, id: \.self) { club in
                            Text(club).tag(club)
                        }
                    }
                    .onChange(of: selectedClub) { oldValue, newValue in
                        Task {
                            await loadYears()
                        }
                    }
                    
                    Picker("년도", selection: $selectedYear) {
                        ForEach(availableYears, id: \.self) { year in
                            Text(String(year)).tag(year as Int?)
                        }
                    }
                    .onChange(of: selectedYear) { oldValue, newValue in
                        Task {
                            await loadKits()
                        }
                    }
                    
                    Picker("Kit 종류", selection: $selectedKit) {
                        ForEach(availableKits, id: \.self) { kit in
                            Text(kit).tag(kit)
                        }
                    }
                    .onChange(of: selectedKit) { oldValue, newValue in
                        Task {
                            await loadRegionCodes()
                        }
                    }
                }
                
                Section(header: Text("사이즈 정보")) {
                    Picker("지역 코드", selection: $selectedRegionCode) {
                        ForEach(availableRegionCodes, id: \.self) { code in
                            Text(code).tag(code)
                        }
                    }
                    .onChange(of: selectedRegionCode) { oldValue, newValue in
                        Task {
                            await loadSizeCodes()
                        }
                    }
                    
                    Picker("사이즈", selection: $selectedSizeCode) {
                        ForEach(availableSizeCodes, id: \.self) { size in
                            Text(size).tag(size)
                        }
                    }
                }
            }
            .navigationBarTitle(uniform == nil ? "유니폼 추가" : "유니폼 수정")
            .navigationBarItems(
                leading: Button("취소") { isPresented = false },
                trailing: Button("저장") { saveUniform() }
            )
        }
        .task {
            await loadClubs()
        }
    }
    
    private func loadClubs() async {
        do {
            availableClubs = try await kitDataManager.getAllClubs()
            if selectedClub.isEmpty && !availableClubs.isEmpty, let firstClub = availableClubs.first {
                selectedClub = firstClub
            }
            await loadYears()
        } catch {
            print("Error loading clubs: \(error)")
        }
    }
    
    private func loadYears() async {
        do {
            availableYears = try await kitDataManager.getYears(for: selectedClub)
            if !availableYears.contains(selectedYear), let firstYear = availableYears.first {
                selectedYear = firstYear
            }
            await loadKits()
        } catch {
            print("Error loading years: \(error)")
        }
    }
    
    private func loadKits() async {
        do {
            availableKits = try await kitDataManager.getKitNames(for: selectedClub, in: selectedYear)
            if selectedKit.isEmpty || !availableKits.contains(selectedKit), let firstKit = availableKits.first {
                selectedKit = firstKit
            }
            await loadRegionCodes()
        } catch {
            print("Error loading kits: \(error)")
        }
    }
    
    private func loadRegionCodes() async {
        do {
            availableRegionCodes = try await kitDataManager.getRegionCodes(for: selectedClub, year: selectedYear, kitName: selectedKit)
            if !availableRegionCodes.contains(selectedRegionCode), let firstRegionCode = availableRegionCodes.first {
                selectedRegionCode = firstRegionCode
            }
            await loadSizeCodes()
        } catch {
            print("Error loading region codes: \(error)")
        }
    }
    
    private func loadSizeCodes() async {
        do {
            availableSizeCodes = try await kitDataManager.getSizeCodes(for: selectedClub, year: selectedYear, kitName: selectedKit, regionCode: selectedRegionCode)
            if !availableSizeCodes.contains(selectedSizeCode), let firstSizeCode = availableSizeCodes.first {
                selectedSizeCode = firstSizeCode
            }
        } catch {
            print("Error loading size codes: \(error)")
        }
    }
    
    private func saveUniform() {
        let updatedUniform = Uniform(
            id: uniform?.id ?? UUID(),
            club: selectedClub,
            year: selectedYear,
            kit: selectedKit,
            regionCode: selectedRegionCode,
            sizeCode: selectedSizeCode
        )
        
        if uniform == nil {
            viewModel.addUniform(updatedUniform)
        } else {
            viewModel.updateUniform(updatedUniform)
        }
        isPresented = false
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Kit.self, KitSize.self, configurations: config)
        
        // 임시 데이터 생성
        let sampleKit = Kit(id: 1, club: "Sample Club", year: 2024, name: "HOME")
        container.mainContext.insert(sampleKit)
        
        let viewModel = UniformViewModel()
        let appData = AppData()
        
        return EditUniformView(viewModel: viewModel,
                               uniform: .constant(nil),
                               isPresented: .constant(true),
                               modelContext: container.mainContext)
            .environmentObject(appData)
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
