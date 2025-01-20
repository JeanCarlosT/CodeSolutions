//
//  LoadingView.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 3/11/22.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack(spacing: 5) {
            ProgressView()
            Text("Synchronizing")
        }.font(.headline)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
