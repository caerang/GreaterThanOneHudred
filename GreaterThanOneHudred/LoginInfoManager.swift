//
//  LoginInfoManager.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 3..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import Foundation

class LoginInfoManager {
    
    static let sharedInstance = LoginInfoManager()
    
    let ID_USERID = "userID"
    let ID_PASSWORD = "password"
    
    func saveLoginInfo(id: String, password: String) -> Bool {
        guard !id.isEmpty && !password.isEmpty else {
            return false
        }
        
        if KeychainWrapper.standard.set(id, forKey: ID_USERID) {
            _ = KeychainWrapper.standard.set(password, forKey: ID_PASSWORD)
        }
        
        return true
    }
    
    func hasLoginInfo() -> Bool {
        guard let userID = KeychainWrapper.standard.string(forKey: ID_USERID) else {
            return false
        }
        
        guard !userID.isEmpty else {
            return false
        }
        
        return true
    }
    
    func removeLoginInfo() {
        _ = KeychainWrapper.standard.removeAllKeys()
    }
}
