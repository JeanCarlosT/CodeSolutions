//
//  ContentView.swift
//  FloatingButton
//
//  Created by Sioma on 28/03/23.
//

import SwiftUI

struct ContentView: View {
    
    enum FABStyles: String, Hashable,Identifiable, CaseIterable{
        var id: Self { self }
        case one = "First style"
        case two = "Second style"
    }
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(FABStyles.allCases) { style in
                    NavigationLink(value: style) {
                        Text(style.rawValue)
                    }
                }
            }
            .navigationTitle("Floating Action Button")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationDestination(for: FABStyles.self) { style in
                switch style{
                case .one:
                    FAButton1()
                case .two:
                    FAButton1()
                }
                
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

