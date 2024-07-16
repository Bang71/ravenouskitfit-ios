//
//  UniformViewModel.swift
//  kitfit
//
//  Created by 신병기 on 7/7/24.
//

import Foundation

class UniformViewModel: ObservableObject {
    private let userDefaults = UserDefaults.standard
    private let savedUniformsKey = "SavedUniforms"
    
    @Published var uniforms: [Uniform] = [] {
        didSet {
            saveUniforms()
        }
    }
    
    init() {
        loadUniforms()
    }
    
    func addUniform(_ uniform: Uniform) {
        uniforms.append(uniform)
    }
    
    func updateUniform(_ uniform: Uniform) {
        guard let index = uniforms.firstIndex(where: { $0.id == uniform.id }) else { return }
        uniforms[index] = uniform
    }
    
    func deleteUniform(_ uniform: Uniform) {
        uniforms.removeAll { $0.id == uniform.id }
    }
    
    private func saveUniforms() {
        guard let encoded = try? JSONEncoder().encode(uniforms) else { return }
        userDefaults.set(encoded, forKey: savedUniformsKey)
    }
    
    private func loadUniforms() {
        guard let savedUniforms = UserDefaults.standard.data(forKey: savedUniformsKey),
              let decodedUniforms = try? JSONDecoder().decode([Uniform].self, from: savedUniforms) else { return }
        uniforms = decodedUniforms
    }
}
