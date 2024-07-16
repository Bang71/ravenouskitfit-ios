//
//  BodyInfoView.swift
//  kitfit
//
//  Created by 신병기 on 7/16/24.
//

import SwiftUI

struct BodyInfoInputView: View {
    @AppStorage("userHeight") private var height: String = ""
    @AppStorage("userBodyType") private var bodyType: BodyType = .average
    @AppStorage("userPreferredFit") private var preferredFit: FitType = .regular
    @AppStorage("userChest") private var chestCircumference: String = ""
    @AppStorage("userWaist") private var waistCircumference: String = ""
    
    @FocusState private var focusedField: FocusField?
    
    enum FocusField: Hashable {
        case height, chest, waist
    }
    
    var body: some View {
        Form {
            Section(header: Text("기본 정보")) {
                HStack {
                    Text("키 (cm)")
                    Spacer()
                    TextField("", text: $height)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .height)
                        .onChange(of: height) {  }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = .height
                }
                
                Picker("체형", selection: $bodyType) {
                    ForEach(BodyType.allCases, id: \.self) { type in
                        Text(type.description).tag(type)
                    }
                }
            }
            
            Section(header: Text("상세 치수 (선택사항)")) {
                HStack {
                    Text("가슴둘레 (cm)")
                    Spacer()
                    TextField("", text: $chestCircumference)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .chest)
                        .onChange(of: chestCircumference) {  }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = .chest
                }
                
                HStack {
                    Text("허리둘레 (cm)")
                    Spacer()
                    TextField("", text: $waistCircumference)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .focused($focusedField, equals: .waist)
                        .onChange(of: waistCircumference) {  }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedField = .waist
                }
            }
            
            Section(header: Text("선호 핏")) {
                Picker("핏", selection: $preferredFit) {
                    ForEach(FitType.allCases, id: \.self) { fit in
                        Text(fit.description).tag(fit)
                    }
                }
            }
        }
        .navigationTitle("신체 정보 입력")
    }
}

enum BodyType: String, CaseIterable {
    case slim, average, athletic, large
    
    var description: String {
        switch self {
        case .slim: return "마른 체형"
        case .average: return "보통 체형"
        case .athletic: return "운동선수 체형"
        case .large: return "큰 체형"
        }
    }
}

enum FitType: String, CaseIterable {
    case tight, regular, loose
    
    var description: String {
        switch self {
        case .tight: return "타이트핏"
        case .regular: return "레귤러핏"
        case .loose: return "루즈핏"
        }
    }
}

#Preview {
    NavigationView {
        BodyInfoInputView()
    }
}
