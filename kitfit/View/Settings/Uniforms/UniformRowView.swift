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
    
    private var isDefaultUniform: Bool {
        defaultUniformIDString == uniform.id.uuidString
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                defaultUniformIDString = uniform.id.uuidString
            }) {
                Image(systemName: isDefaultUniform ? "largecircle.fill.circle" : "circle")
            }
            .foregroundColor(.blue)
            .buttonStyle(PlainButtonStyle())
            
            VStack(alignment: .leading) {
                HStack {
                    Text(uniform.club)
                        .font(.headline)
                    if isDefaultUniform {
                        Text("(기본)")
                            .font(.subheadline)
                            .foregroundColor(Color(.white))
                    }
                }
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
