//
//  dewbee_iosApp.swift
//  dewbee-ios
//
//  Created by 이연주 on 11/29/24.
//

import SwiftUI

@main
struct dewbee_iosApp: App {
    // 런치스크린 로딩 시간 클래스 호출
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // 웹뷰 호출
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
