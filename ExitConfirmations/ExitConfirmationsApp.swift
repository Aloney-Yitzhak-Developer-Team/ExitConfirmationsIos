//
//  ExitConfirmationsApp.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskiy on 23/05/2023.
//

import SwiftUI
import Firebase
import FirebaseCore

@main
struct ExitConfirmationsApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            StartView()
        }
    }
}
