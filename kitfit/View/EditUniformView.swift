//
//  EditUniformView.swift
//  kitfit
//
//  Created by 신병기 on 6/20/24.
//

import SwiftUI

struct EditUniformView: View {
    @ObservedObject var viewModel: UniformViewModel
    @State private var uniformData: Uniform
    @Binding var isPresented: Bool
    
    private let isNewUniform: Bool
    
    init(viewModel: UniformViewModel, uniform: Uniform?, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self._uniformData = State(initialValue: uniform ?? Uniform(
            id: UUID(),
            club: Uniform.clubs.first ?? "",
            year: Calendar.current.component(.year, from: Date()),
            kit: Uniform.kits.first ?? "",
            regionCode: Uniform.regionCodes.first ?? "",
            size: Uniform.sizes.first ?? ""
        ))
        self._isPresented = isPresented
        self.isNewUniform = uniform == nil
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("유니폼 정보")) {
                    Picker("구단", selection: $uniformData.club) {
                        ForEach(Uniform.clubs, id: \.self) { club in
                            Text(club).tag(club)
                        }
                    }
                    Picker("년도", selection: $uniformData.year) {
                        ForEach(1862...Calendar.current.component(.year, from: Date()), id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                    Picker("Kit 종류", selection: $uniformData.kit) {
                        ForEach(Uniform.kits, id: \.self) { kit in
                            Text(kit).tag(kit)
                        }
                    }
                }
                
                Section(header: Text("사이즈 정보")) {
                    Picker("지역 코드", selection: $uniformData.regionCode) {
                        ForEach(Uniform.regionCodes, id: \.self) { code in
                            Text(code).tag(code)
                        }
                    }
                    Picker("사이즈", selection: $uniformData.size) {
                        ForEach(Uniform.sizes, id: \.self) { size in
                            Text(size).tag(size)
                        }
                    }
                }
            }
            .navigationBarTitle(isNewUniform ? "유니폼 추가" : "유니폼 수정")
            .navigationBarItems(
                leading: Button("취소") { isPresented = false },
                trailing: Button("저장") { saveUniform() }
            )
        }
    }
    
    private func saveUniform() {
        if isNewUniform {
            viewModel.addUniform(uniformData)
        } else {
            viewModel.updateUniform(uniformData)
        }
        isPresented = false
    }
}

#Preview {
    EditUniformView(viewModel: UniformViewModel(), uniform: nil, isPresented: .constant(true))
        .environmentObject(AppData())
}
