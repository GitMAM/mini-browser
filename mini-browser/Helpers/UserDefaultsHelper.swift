//
//  UserDefaultsHelper.swift
//  mini-browser
//
//  Created by Mohamed Ali on 01/10/2022.
//

import Foundation


enum UserDefaultKeys: String {
  case webViewUrl
  case webViewState
}

extension UserDefaults {
  
  static func setData<T>(value: T, key: UserDefaultKeys) {
    let defaults = UserDefaults.standard
    defaults.set(value, forKey: key.rawValue)
  }
  
  static func getData<T>(type: T.Type, forKey: UserDefaultKeys) -> T? {
    let defaults = UserDefaults.standard
    let value = defaults.object(forKey: forKey.rawValue) as? T
    return value
  }
  
  static func removeData(key: UserDefaultKeys) {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: key.rawValue)
  }
}
