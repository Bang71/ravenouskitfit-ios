//
//  AppData.swift
//  kitfit
//
//  Created by 신병기 on 6/19/24.
//

import SwiftUI

class AppData: ObservableObject {
    @Published var isSplashFinished: Bool = false
    @Published var uniformViewModel: UniformViewModel
    
    init() {
        self.uniformViewModel = UniformViewModel()
    }
}
