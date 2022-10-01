//
//  UserDefaultsHelper.swift
//  mini-browser
//
//  Created by Mohamed Ali on 01/10/2022.
//

import Foundation


public enum UserDefaultKeys: String {
  case webViewUrl
  case webViewState
}

public extension UserDefaults {
  
  static func set<T>(value: T, key: UserDefaultKeys) {
    let defaults = UserDefaults.standard
    defaults.set(value, forKey: key.rawValue)
  }
  
  static func get<T>(type: T.Type, forKey: UserDefaultKeys) -> T? {
    let defaults = UserDefaults.standard
    let value = defaults.object(forKey: forKey.rawValue) as? T
    return value
  }
  
  static func remove(key: UserDefaultKeys) {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: key.rawValue)
  }
}
