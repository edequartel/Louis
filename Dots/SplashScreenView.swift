//
//  SplashScreenView.swift
//  Braille
//
//  Created by Eric de Quartel on 03/06/2022.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                VStack {
                    Image(systemName: "hand.point.up.braille.fill")
                        .font(.system(size:100))
                        .foregroundColor(.red)
                    Text("dots")
                        .font(.custom(
                            "bartimeus6dots",
                            fixedSize: 64))
                        .foregroundColor(.blue.opacity(0.80))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.80)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation {
                                    self.isActive = true
                                }
                            }
                        }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
