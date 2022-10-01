# mini-browser

## This is a simple web browser like app

https://user-images.githubusercontent.com/22305049/193428865-641d98b8-46a7-4faa-8e45-9a176940a54d.mp4


| Features  |
|-----------------
| Initial State.
| Toolbar to control webview and initial state navigation
| State presistence using Userdefaults

The app uses state enum extensively in the browser view controller to control the state and enabling and disabling buttons.

Simple UI tests is added
  

## WebViewState

Is used to control the state of the app (Loading, initial state .. etc) this is used to control the back and forward toolbar buttons and switching between intial and web view states. 

The app starts when first installed with initialState (Button in the middle of the screen) Once the button is tapped, the state changes to .loaded, this allows the back button to be enabled by setting the state which in turns enables/disable the back and forward buttons. 

User can then navigate further into the app, the app saves the state in userdefaults everytime the state changes using set() helper method.

The apps has an observer for two keypaths, canGoFoward and canGoBackward, the state changes when those keypaths change, the forward button is enabled when canGoForward or when the app is backToInitialState.

The zooming feature is enabled by default in WKWebView so it didn't need to be reimplemented.

There is a simple UI test added to with a launchArgument.

The app doesn't use storyboard. 
