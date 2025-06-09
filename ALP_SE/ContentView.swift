//
//  ContentView.swift
//  ALP_SE
//
//  Created by Calvin Laiman on 26/05/25.
//

import SwiftUI

struct ContentView: View {
    //buat navbar disini
    var body: some View {
        VStack {
            Image(systemName: "globes")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
