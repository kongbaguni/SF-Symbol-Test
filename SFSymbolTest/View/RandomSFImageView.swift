//
//  RandomSFImageView.swift
//  SFSymbolTest
//
//  Created by 서창열 on 2023/01/03.
//

import SwiftUI

struct RandomSFImageView: View {
    @State var name:String? = nil
    
    var body: some View {
        Group {
            if let name = self.name {
                Image(systemName: name)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("??")
            }
        }
        .onAppear {
            changeName()
        }
    }
    
    func changeName() {
        name = GameManager.shared.names.randomElement()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            changeName()
        }
    }
}

struct RandomSFImageView_Previews: PreviewProvider {
    static var previews: some View {
        RandomSFImageView()
    }
}
