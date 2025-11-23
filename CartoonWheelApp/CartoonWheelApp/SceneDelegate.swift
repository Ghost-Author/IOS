//
//  SceneDelegate.swift
//  CartoonWheelApp
//
//  Created by liupeng on 2025/11/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let mainVC = MainViewController()
        let nav = UINavigationController(rootViewController: mainVC)
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
}
