//
//  UniformRowView.swift
//  kitfit
//
//  Created by 신병기 on 7/11/24.
//

import SwiftUI

struct UniformRowView: View {
    @ObservedObject var viewModel: UniformViewModel
    let uniform: Uniform
    var onEdit: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                viewModel.setDefaultUniform(uniform)
            }) {
                Image(systemName: viewModel.defaultUniformID == uniform.id ? "largecircle.fill.circle" : "circle")
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
