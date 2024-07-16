//
//  SettingsMainView.swift
//  kitfit
//
//  Created by 신병기 on 7/16/24.
//

import SwiftUI

struct SettingsMainView: View {
    @State private var path = NavigationPath()
    
    enum SettingsDestination: Hashable {
        case bodyInfo
        case uniformList
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section(header: Text("개인 설정")) {
                    NavigationLink(value: SettingsDestination.bodyInfo) {
                        HStack {
                            Image(systemName: "person.crop.circle")
                            Text("신체 정보 입력")
                        }
                    }
                }
                
                Section(header: Text("유니폼 관리")) {
                    NavigationLink(value: SettingsDestination.uniformList) {
                        HStack {
                            Image(systemName: "tshirt")
                            Text("내 유니폼 목록")
                        }
                    }
                }
                
                // 추가 설정 항목들을 여기에 넣을 수 있습니다.
            }
            .navigationTitle("설정")
            .navigationDestination(for: SettingsDestination.self) { destination in
                switch destination {
                case .bodyInfo:
                    BodyInfoInputView()
                case .uniformList:
                    UniformListView(viewModel: UniformViewModel())
                }
            }
        }
    }
}

#Preview {
    SettingsMainView()
}
