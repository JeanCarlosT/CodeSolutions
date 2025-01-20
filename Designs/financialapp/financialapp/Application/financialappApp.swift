//
//  financialappApp.swift
//  financialapp
//
//  Created by Sioma on 7/03/22.
//

import SwiftUI

@main
struct financialappApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView{
                LoginRegisterView()
                    .environmentObject(ProjectViewModel())
            }
        }
    }
}
