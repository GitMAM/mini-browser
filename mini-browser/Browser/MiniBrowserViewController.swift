//
//  MiniBrowserViewController.swift
//  mini-browser
//
//  Created by Mohamed Ali on 01/10/2022.
//

import UIKit
import WebKit

final class MiniBrowserViewController: UIViewController, WKNavigationDelegate {
  
  // Handle VC State
  private var state: WebViewState = .initialState {
    didSet {
      if let currentUrl = webView.url {
        UserDefaults.set(value: currentUrl.absoluteString, key: .webViewUrl)
      }
      UserDefaults.set(value: state.rawValue, key: .webViewState)
      handleToolBarButtonsState(with: state)
    }
  }
  
  // ToolBar Button Items
  private var backButton: UIBarButtonItem!
  private var forwardButton: UIBarButtonItem!
  
  // Initial State Button
  private let initialStateButton: UIButton = {
    let button = UIButton()
    button.setTitle("Tap to start", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 5
    button.addTarget(self, action: #selector(didTapInitialStateButton), for: .touchUpInside)
    return button
  }()
  
  // WebView
  private lazy var webView: WKWebView = {
    let webView = WKWebView(frame: .zero)
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.allowsBackForwardNavigationGestures = true
    webView.navigationDelegate = self
    webView.isHidden = true
    return webView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    addSubViews()
    makeConstraints()
    setToolBar()
    webViewObservers()
    handleAppLaunch()
  }
  
  // determine the state of the app after launch (i.e load last visited website)
  private func handleAppLaunch() {
    
    if let stateRawValue = UserDefaults.get(type: String.self, forKey: .webViewState), let savedState =  WebViewState(rawValue: stateRawValue) {
      
      state = savedState
      
      switch savedState {
        
      case .initialState, .backToInitialState:
        break
      case .loaded, .backToMainWebPage:
        if let url = UserDefaults.get(type: String.self, forKey: .webViewUrl) {
          loadWebView(with: URL(string: url)!)
        }
      }
    } else {
      state = .initialState
    }
    
  }
  
  // set toolBar
  private func setToolBar() {
    
    navigationController?.setToolbarHidden(false, animated: true)
    
    let backButton = UIBarButtonItem(
      image: UIImage(systemName: "arrow.left")?.withTintColor(.blue, renderingMode: .alwaysTemplate),
      style: .plain,
      target: self,
      action: #selector(handleBackButton))
    
    let forwardButton = UIBarButtonItem(
      image: UIImage(systemName: "arrow.right")?.withTintColor(.blue, renderingMode: .alwaysTemplate),
      style: .plain,
      target: self,
      action: #selector(handleForwardButton))
    
    self.backButton = backButton
    self.forwardButton = forwardButton
    
    self.toolbarItems = [backButton, forwardButton]
  }
  
  // observe webview canGoBack and canGoForward
  private func webViewObservers() {
    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)
  }
  
  // handle the observation
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if webView.canGoBack || webView.canGoForward {
      state = .loaded
    } else if !webView.canGoBack && !webView.canGoForward {
      if (webView.url != nil) {
        state = .backToInitialState
      } else {
        state = .initialState
      }
    }
  }
  
  // add the subViews
  private final func addSubViews() {
    view.addSubview(initialStateButton)
    view.addSubview(webView)
  }
  
  // make constrains for the views
  private final func makeConstraints() {
    
    NSLayoutConstraint.activate([
      initialStateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      initialStateButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      initialStateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
      initialStateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
      initialStateButton.heightAnchor.constraint(equalToConstant: 60)
    ])
    
    NSLayoutConstraint.activate([
      webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
  
  // handle tapping the initial state button
  @objc final func didTapInitialStateButton() {
    switchBetweenViews(show: .web)
  }
  
  // handle switching between intial state and web view modes
  private func switchBetweenViews(show mode: ViewMode) {
    
    if mode == .web {
      if (webView.url != nil) {
        transitionBetweenModes(with: .web)
      } else {
        loadWebView(with: URL(string: "https://stil.kurir.rs/moda/157971/ovo-su-najstilizovanije-zene-sveta-koja-je-po-vama-br-1-anketa?fbclid=IwAR2PTN710ur9KniJ6LXSgKaqw4QbpveWe2GkRZ1cU0J0CSQbXyoxPTmYghU")!)
      }
      state = .loaded
    } else {
      transitionBetweenModes(with: .initialState)
      if (webView.url != nil) {
        state = .backToInitialState
      } else {
        state = .initialState
      }
    }
  }
  
  // load webview with url and change state
  private func loadWebView(with url: URL) {
    
    transitionBetweenModes(with: .web)

    webView.load(URLRequest(url: url))
    
    state = .loaded
  }
  
  // Transition between button mode and webview mode
  private func transitionBetweenModes(with mode: ViewMode) {
    
    var hideWebView: Bool
    var hideButton: Bool
    
    switch mode {
    case .web:
      hideWebView = false
      hideButton = true
    case .initialState:
      hideWebView = true
      hideButton = false
    }
    
    self.initialStateButton.isHidden = hideButton
    self.webView.isHidden = hideWebView
    
  }
  
  // handle forward button
  @objc func handleForwardButton(sender: UIBarButtonItem) {
    if webView.canGoForward {
      if state == .backToInitialState || state == .initialState {
        switchBetweenViews(show: .web)
      } else {
        webView.goForward()
      }
    } else {
      switchBetweenViews(show: .web)
    }
  }
  
  // handle backward button
  @objc func handleBackButton(sender: UIBarButtonItem) {
    if webView.canGoBack {
      webView.goBack()
    } else {
      switchBetweenViews(show: .initialState)
    }
  }
  
  // handle tool bar buttons state (when the state changes enable/disable buttons)
  private func handleToolBarButtonsState(with state: WebViewState) {
    
    var backButtonEnabled: Bool
    var forwardButtonEnabled: Bool
    
    switch state {
    case .initialState:
      backButtonEnabled = false
      forwardButtonEnabled = false
    case .backToMainWebPage, .loaded :
      if webView.canGoForward {
        backButtonEnabled = true
        forwardButtonEnabled = true
      } else {
        backButtonEnabled = true
        forwardButtonEnabled = false
      }
    case .backToInitialState:
      backButtonEnabled = false
      forwardButtonEnabled = true
    }
    
    backButton.isEnabled = backButtonEnabled
    forwardButton.isEnabled = forwardButtonEnabled
  }
}


