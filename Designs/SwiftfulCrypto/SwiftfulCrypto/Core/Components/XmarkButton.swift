//
//  XmarkButton.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 4/11/22.
//

import SwiftUI

struct XmarkButton: View {
    
    var action: ()->Void
    
    var body: some View {
        Button {
           action()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

struct XmarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XmarkButton(action: { })
    }
}
