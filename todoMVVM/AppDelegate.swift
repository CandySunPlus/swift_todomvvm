//
//  AppDelegate.swift
//  todoMVVM
//
//  Created by niksun on 2019-01-07.
//  Copyright © 2019 niksun. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var services: ViewModelServicesProtocol?

    var presenting: UIViewController? {
        return navigationStack.last
    }
    private var navigationStack: [UIViewController] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)

        services = ViewModelServices(delegate: self)
        let vm = TodoTableViewModel(services: services!)
        services?.push(viewModel: vm)

        let rootNavigationController = UINavigationController()
        navigationStack.append(rootNavigationController)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

    }


    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

    }


    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: ViewModelServicesDelegate {
    func services(_ services: ViewModelServicesProtocol, navigate: NavigationEvent) {
        DispatchQueue.main.async {
            switch navigate {
            case .Push(let vc, let style):
                switch style {
                case .Push:
                    if let top = self.presenting as? UINavigationController {
                        top.pushViewController(vc, animated: true)
                    }
                case .Modal:
                    if let top = self.presenting {
                        let navigationController = UINavigationController(rootViewController: vc)
                        self.navigationStack.append(navigationController)
                        top.present(navigationController, animated: true, completion: nil)
                    }
                }
            case .Pop:
                if let navigationController = self.presenting as? UINavigationController {
                    if navigationController.viewControllers.count > 1 {
                        navigationController.popViewController(animated: true)
                    } else if self.navigationStack.count > 1 {
                        self.navigationStack.popLast()?.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self.navigationStack.popLast()?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
