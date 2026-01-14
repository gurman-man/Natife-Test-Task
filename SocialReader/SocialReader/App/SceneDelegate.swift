//
//  SceneDelegate.swift
//  SocialReader
//
//  Created by mac on 14.01.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // Перевіряємо, чи сцена є UIWindowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Створюємо вікно, використовуючи цю сцену
        let window = UIWindow(windowScene: windowScene)
        
        // Створюємо стартовий контролер
        let rootVC = ViewController()
        rootVC.view.backgroundColor = .white
        
        // Обгортаємо в NavigationController
        let naviagtionController = UINavigationController(rootViewController: rootVC)
        
        // Призначаємо кореневий контролер і показуємо вікно
        window.rootViewController = naviagtionController
        self.window = window
        window.makeKeyAndVisible()
    }


}

