//
//  UniformViewModel.swift
//  kitfit
//
//  Created by 신병기 on 7/7/24.
//

import Foundation

class UniformViewModel: ObservableObject {
    private let userDefaults = UserDefaults.standard
    private enum UserDefaultsKeys {
        static let uniforms = "SavedUniforms"
        static let defaultUniformID = "DefaultUniformID"
    }
    
    @Published var uniforms: [Uniform] = [] {
        didSet {
            saveUniforms()
        }
    }
    
    @Published var defaultUniformID: UUID? {
        didSet {
            saveDefaultUniformID()
        }
    }
    
    init() {
        loadUniforms()
        loadDefaultUniformID()
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
    
    func setDefaultUniform(_ uniform: Uniform) {
        defaultUniformID = uniform.id
    }
    
    private func saveUniforms() {
        guard let encoded = try? JSONEncoder().encode(uniforms) else { return }
        userDefaults.set(encoded, forKey: UserDefaultsKeys.uniforms)
    }
    
    private func loadUniforms() {
        guard let savedUniforms = UserDefaults.standard.data(forKey: UserDefaultsKeys.uniforms),
              let decodedUniforms = try? JSONDecoder().decode([Uniform].self, from: savedUniforms) else { return }
        uniforms = decodedUniforms
    }
    
    private func saveDefaultUniformID() {
        userDefaults.set(defaultUniformID?.uuidString, forKey: UserDefaultsKeys.defaultUniformID)
    }
    
    private func loadDefaultUniformID() {
        guard let defaultIDString = userDefaults.string(forKey: UserDefaultsKeys.defaultUniformID),
              let defaultID = UUID(uuidString: defaultIDString) else { return }
        defaultUniformID = defaultID
    }
}
