import Foundation
import SwiftValidator
import UIKit
import WebKit

class NewOrUpdateNoteViewController: BaseFormSheetDisplayable {

  private var webView: WKWebView!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    guard let path = Bundle.main.path(forResource: "quill", ofType: ".html") else {
      LOG.error("Failed to load Quill HTML index file")
      return
    }
    let urlRequest = URLRequest(url: URL(fileURLWithPath: path))
    
    let configuration = WKWebViewConfiguration()
    configuration.applicationNameForUserAgent = "EcoDatum"
    
    webView = WKWebView(
      frame: view.frame,
      configuration: configuration)
    webView.navigationDelegate = self
    webView.load(urlRequest)
    webView.contentScaleFactor = 3.0
    
    view.addSubview(webView)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
  }
  
}

extension NewOrUpdateNoteViewController: WKNavigationDelegate {
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
  }
  
}
