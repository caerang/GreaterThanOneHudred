//
//  LoginInfoManager.swift
//  GreaterThanOneHundred
//
//  Created by stonecoldjuice on 2017. 1. 3..
//  Copyright © 2017년 dreamFactory. All rights reserved.
//

import Foundation
import Firebase

class LoginManager {
    
    static let sharedInstance = LoginManager()
    
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
    
    func loginWithExistingKey(completion: @escaping (FIRUser?, Error?) -> ()) -> Bool {
        guard let userID = KeychainWrapper.standard.string(forKey: ID_USERID),
            let password = KeychainWrapper.standard.string(forKey: ID_PASSWORD) else {
            return false
        }
        
        guard !userID.isEmpty && !password.isEmpty else {
            return false
        }
        
        login(id: userID, password: password, completion: completion)
        
        return true
    }
    
    func removeLoginInfo() {
        _ = KeychainWrapper.standard.removeAllKeys()
    }
    
    func login(id: String, password: String, completion: @escaping (FIRUser?, Error?) -> ()) {
        FIRAuth.auth()?.signIn(withEmail: id, password: password, completion: completion)
    }
    
    func logout() {
        do {
            try FIRAuth.auth()?.signOut()
            removeLoginInfo()
        } catch let logoutError {
            print(logoutError )
        }
    }
    
}
