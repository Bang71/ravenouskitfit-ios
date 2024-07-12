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
    @State private var editedUniform: Uniform
    @State private var selectedClub: String = ""
    @State private var selectedYear: Int?
    @State private var selectedKit: String = ""
    
    @State private var availableClubs: [String] = []
    @State private var availableYears: [Int] = []
    @State private var availableKits: [String] = []
    
    private let kitDataManager: KitDataManager
    
    init(viewModel: UniformViewModel, uniform: Binding<Uniform?>, isPresented: Binding<Bool>, modelContext: ModelContext) {
        self.viewModel = viewModel
        self._uniform = uniform
        self._isPresented = isPresented
        self.kitDataManager = KitDataManager(modelContext: modelContext)
        
        let initialUniform = uniform.wrappedValue ?? Uniform(id: UUID(), club: "", year: Calendar.current.component(.year, from: Date()), kit: "", regionCode: "", sizeCode: "")
        self._editedUniform = State(initialValue: initialUniform)
        self._selectedClub = State(initialValue: initialUniform.club)
        self._selectedYear = State(initialValue: initialUniform.year)
        self._selectedKit = State(initialValue: initialUniform.kit)
    }
    
    //    init(viewModel: UniformViewModel, uniform: Binding<Uniform?>, isPresented: Binding<Bool>) {
    //        self.viewModel = viewModel
    //        self._uniform = uniform
    //        self._isPresented = isPresented
    //        self._editedUniform = State(initialValue: uniform.wrappedValue ?? Uniform(
    //            id: UUID(),
    //            club: Uniform.clubs.first ?? "",
    //            year: Calendar.current.component(.year, from: Date()),
    //            kit: Uniform.kits.first ?? "",
    //            regionCode: Uniform.regionCodes.first ?? "",
    //            sizeCode: Uniform.sizeCodes.first ?? ""
    //        ))
    //    }
    
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
                }
                
                Section(header: Text("사이즈 정보")) {
                    Picker("지역 코드", selection: $editedUniform.regionCode) {
                        ForEach(Uniform.regionCodes, id: \.self) { code in
                            Text(code).tag(code)
                        }
                    }
                    Picker("사이즈", selection: $editedUniform.sizeCode) {
                        ForEach(Uniform.sizeCodes, id: \.self) { size in
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
            if !availableClubs.isEmpty && selectedClub.isEmpty {
                selectedClub = availableClubs[0]
                await loadYears()
            }
        } catch {
            print("Error loading clubs: \(error)")
        }
    }
    
    private func loadYears() async {
        do {
            availableYears = try await kitDataManager.getYears(for: selectedClub)
            if !availableYears.isEmpty {
                selectedYear = availableYears[0]
                await loadKits()
            }
        } catch {
            print("Error loading years: \(error)")
        }
    }
    
    private func loadKits() async {
        do {
            if let year = selectedYear {
                availableKits = try await kitDataManager.getKitNames(for: selectedClub, in: year)
                if !availableKits.isEmpty && !availableKits.contains(selectedKit) {
                    selectedKit = availableKits[0]
                }
            }
        } catch {
            print("Error loading kits: \(error)")
        }
    }
    
    private func saveUniform() {
        editedUniform.club = selectedClub
        editedUniform.year = selectedYear ?? Calendar.current.component(.year, from: Date())
        editedUniform.kit = selectedKit
        
        if uniform == nil {
            viewModel.addUniform(editedUniform)
        } else {
            viewModel.updateUniform(editedUniform)
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
