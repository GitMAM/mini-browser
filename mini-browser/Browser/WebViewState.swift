//
//  WebViewState.swift
//  mini-browser
//
//  Created by Mohamed Ali on 30/09/2022.
//

import Foundation

enum WebViewState: String {
  case initialState
  case backToMainWebPage
  case loaded
  case backToInitialState
}

enum ViewMode {
  case web
  case initialState
}
