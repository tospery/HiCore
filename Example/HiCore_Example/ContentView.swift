//
//  ContentView.swift
//  HiCore_Example
//
//  Created by 杨建祥 on 2025/1/13.
//

import SwiftUI
import HiCore

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onTapGesture {
            print(UIDevice.current.deviceName)
        }
    }
}

#Preview {
    ContentView()
}
