//
//  MycarApp.swift
//  Mycar
//
//  Created by Alireza on 24/09/2025.
//

import SwiftUI
import Combine
struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? Color.blue.opacity(0.7) : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: Color.blue.opacity(0.2), radius: 4, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0) // کوچک‌تر هنگام فشار
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

final class AppDate: ObservableObject {
    let launchDateString: String
    
    init() {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        self.launchDateString = f.string(from: Date())
    }
}

@main
struct MycarApp: App {
    
    @StateObject private var appDate = AppDate()
  
    
    var body: some Scene {
        WindowGroup {
            Mainpage()
                .environmentObject(appDate)
        }
    }
}

