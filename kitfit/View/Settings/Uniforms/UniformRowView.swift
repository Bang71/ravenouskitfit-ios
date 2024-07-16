//
//  UniformRowView.swift
//  kitfit
//
//  Created by 신병기 on 7/11/24.
//

import SwiftUI

struct UniformRowView: View {
    @AppStorage("defaultUniformID") private var defaultUniformIDString: String = ""
    let uniform: Uniform
    var onEdit: () -> Void

    private var defaultUniformID: UUID? {
        UUID(uuidString: defaultUniformIDString)
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                defaultUniformIDString = uniform.id.uuidString
            }) {
                Image(systemName: defaultUniformID == uniform.id ? "largecircle.fill.circle" : "circle")
            }
            .foregroundColor(.blue)
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading) {
                Text(uniform.club)
                    .font(.headline)
                Text("\(String(uniform.year)) - \(uniform.kit)")
                    .font(.subheadline)
                Text("\(uniform.regionCode) \(uniform.sizeCode)")
                    .font(.subheadline)
            }
            
            Spacer()
            
            Button(action: onEdit) {
                Image(systemName: "pencil")
            }
            .foregroundColor(.blue)
            .buttonStyle(PlainButtonStyle())
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    UniformListView(viewModel: UniformViewModel())
        .environmentObject(AppData())
}
