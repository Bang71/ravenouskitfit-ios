//
//  UniformListView.swift
//  kitfit
//
//  Created by 신병기 on 6/20/24.
//

import SwiftUI

struct UniformListView: View {
    @EnvironmentObject var appData: AppData
    @StateObject private var viewModel: UniformViewModel
    @State private var showingAddUniform = false
    @State private var editingUniform: Uniform?
    
    init(viewModel: UniformViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.uniforms.isEmpty {
                    Spacer()
                    Text("저장된 유니폼 없음")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(viewModel.uniforms) { uniform in
                            UniformRowView(viewModel: viewModel, uniform: uniform) {
                                editingUniform = uniform
                            }
                            .contentShape(Rectangle())
                        }
                        .onDelete { indexSet in
                            viewModel.uniforms.remove(atOffsets: indexSet)
                        }
                    }
                }
                Spacer()
                Button(action: {
                    showingAddUniform = true
                }) {
                    Text("유니폼 추가")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("유니폼 목록")
            .sheet(isPresented: $showingAddUniform) {
                EditUniformView(viewModel: viewModel, uniform: nil, isPresented: $showingAddUniform)
            }
            .sheet(item: $editingUniform) { uniform in
                EditUniformView(viewModel: viewModel, uniform: uniform, isPresented: Binding(
                    get: { editingUniform != nil },
                    set: { if !$0 { editingUniform = nil } }
                ))
            }
        }
    }
}

#Preview {
    UniformListView(viewModel: UniformViewModel())
        .environmentObject(AppData())
}
