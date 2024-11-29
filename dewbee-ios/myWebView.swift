//
//  myWebview.swift
//  Monitor Test
//
//  Created by 이연주 on 1/31/24.
//

import SwiftUI
@preconcurrency import WebKit

// uikit의 uiview를 사용할 수 있도록 하는 것
// UIViewControllerRepresentable
struct MyWebView: UIViewRepresentable {

    var urlToLoad: String
    
    // ui view 만들기
    func makeUIView(context: Context) -> some WKWebView {
        
        // unwrapping
//        guard let url = URL(string: self.urlToLoad) else {
//            return WKWebView()
//        }
        
        // webview instance 생성
        let webview = WKWebView()
        
        // userAgent 설정: userAgent 값을 가져온 후 커스텀 값을 추가
        webview.evaluateJavaScript("navigator.userAgent") { (result, error) in
            if let userAgent = result as? String {
                print(userAgent)
                let customUserAgent =
                    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" + " APP_Dewbee"
//                let customUserAgent = userAgent + " APP_Dewbee"
                
                // 실제 사용하는 webView에 설정
                webview.customUserAgent = customUserAgent

                // 이제 URL 로드
                if let url = URL(string: self.urlToLoad) {
                    webview.load(URLRequest(url: url))
                }
            }
        }
        
        webview.uiDelegate = context.coordinator // UI 대리자 설정
        webview.navigationDelegate = context.coordinator // 내비게이션 대리자 설정
        // 스와이프 제스쳐
        webview.allowsBackForwardNavigationGestures = true
        
        return webview
    }
    
    // 업데이트 ui view
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<MyWebView>) {
    }

    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
            var parent: MyWebView

            init(_ parent: MyWebView) {
                self.parent = parent
            }
            
            func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
                if let url = navigationAction.request.url, url.scheme == "mailto" {
                    UIApplication.shared.open(url)
                    decisionHandler(.cancel) // WebView에서 기본 동작을 중지합니다.
                } else {
                    decisionHandler(.allow) // 기본 웹 뷰 탐색을 계속합니다.
                }
            }

            // 새 창 열기 처리
            func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
                // 새 창이나 팝업 링크의 경우 현재 웹뷰에서 로드
                if navigationAction.targetFrame == nil || !(navigationAction.targetFrame!.isMainFrame) {
                    webView.load(navigationAction.request)
                }
                return nil
            }
            // 필요에 따라 추가 WKUIDelegate 및 WKNavigationDelegate 메소드 구현
        }
  
    // 메일 링크 처리
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == "mailto" {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url) { success in
                    if success {
                        print("메일 앱 열기 성공")
                    } else {
                        print("메일 앱을 열 수 없습니다.")
                    }
                }
            } else {
                print("이 디바이스에서는 mailto 링크를 처리할 수 없습니다.")
            }
            decisionHandler(.cancel) // WebView에서 기본 동작을 중지합니다.
        } else {
            decisionHandler(.allow) // 기본 웹 뷰 탐색을 계속합니다.
        }
    }
    
    // 새 창 열기 처리
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // 새 창이나 팝업 링크의 경우 현재 웹뷰에서 로드
        if navigationAction.targetFrame == nil || !(navigationAction.targetFrame!.isMainFrame) {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

struct MyWebView_Previews: PreviewProvider {
    static var previews: some View {
        MyWebView(urlToLoad: "https://dewbee.dewdew.world")
            .edgesIgnoringSafeArea(.bottom)
            .scrollIndicators(.never, axes: [.vertical, .horizontal])
    }
}

