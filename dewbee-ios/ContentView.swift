//
//  ContentView.swift
//  Dewbee IOS
//
//  Created by 이연주 on 11/20/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MyWebView(urlToLoad: "https://dewbee.dewdew.world")
            .ignoresSafeArea()
            .scrollIndicators(/*@START_MENU_TOKEN@*/.never/*@END_MENU_TOKEN@*/, axes: /*@START_MENU_TOKEN@*/[.vertical, .horizontal]/*@END_MENU_TOKEN@*/)
    }
}
