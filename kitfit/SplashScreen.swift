//
//  SplashScreen.swift
//  kitfit
//
//  Created by 신병기 on 6/19/24.
//

import SwiftUI

struct SplashScreen: View {
    @EnvironmentObject private var appData: AppData
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            Text("KITFIT")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 2.0)) {
                        opacity = 1.0
                    } completion: {
                        appData.isSplashFinished = true
                    }
                }
        }
    }
}
