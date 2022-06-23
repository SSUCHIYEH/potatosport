//
//  ContentView.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/10.
//

import SwiftUI

struct ContentView: View {
    @State private var isPlaying = false
    var body: some View {
        if isPlaying{
            GameRunView()
           //
        }else{
            //RunActionView()
            MainView(isPlaying: self.$isPlaying)
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
