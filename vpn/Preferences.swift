//
// Created by Anton Turko on 2019-02-07.
// Copyright (c) 2019 Anton Turko. All rights reserved.
//

import Foundation

class Preferences {

    static let (serverKey, loginKey, passwordKey) = ("server", "login", "password")

    func save(server: String, login: String, password: String) {
        let userDefault = UserDefaults.standard;
        userDefault.set(server, forKey: Preferences.serverKey)
        userDefault.set(login, forKey: Preferences.loginKey)
        userDefault.set(password, forKey: Preferences.passwordKey)
    }

    func server() -> String {
        return UserDefaults.standard.string(forKey: Preferences.serverKey)!
    }

    func login() -> String {
        return UserDefaults.standard.string(forKey: Preferences.loginKey)!
    }

    func password() -> String {
        return UserDefaults.standard.string(forKey: Preferences.passwordKey)!
    }

}
