//
//  AppDelegate.swift
//  HackerBooks
//
//  Created by Jacobo Enriquez Gabeiras on 24/6/16.
//  Copyright © 2016 KeepCoding. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func rootViewControllerForPhone(withModel model: Library) -> UIViewController{
        
        // Crear un Library VC de Favoritos
        let libVC = LibraryTableViewController(model: model)
        
        // Se mete Library VC en un Library Nav
        let libNav = UINavigationController(rootViewController: libVC)
        
        // Asignar delegados
        libVC.delegate = libVC
        
        return libNav
        
    }
    
    func rootViewControllerForPad(withModel model: Library) -> UIViewController {
        
        // Crear un Library VC de Favoritos
        let libVC = LibraryTableViewController(model: model)
        
        // Se mete Library VC en un Library Nav
        let libNav = UINavigationController(rootViewController: libVC)
        
        // Crear un Book VC
        let bookVC = BookViewController(model: model.bookAtIndex(0, forTag: model.tags[0])!)
        
        // Se mete BookVC en un Book Nav
        let bookNav = UINavigationController(rootViewController: bookVC)
        
        // Crear el Split View Controller
        let splitVC = UISplitViewController()
        splitVC.viewControllers = [libNav, bookNav]
        
        //poner el split como VC
        window?.rootViewController = splitVC
        
        // Asignar delegados
        libVC.delegate = bookVC
        
        return splitVC
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        print(NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])

        
        // Crear window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // Mirar si es la primera vez que se arranca la aplicación
        // Esto se hace con User defaults
        
        do{
            try downloadRemoteJSON()
            
        }catch{
            fatalError("Error while loading JSON")
        }
        
        // Crear el modelo
        let model = Library()
        
        var rootVC = UIViewController()
        
        if (!(IS_IPHONE)) {
            // Tableta
            rootVC = self.rootViewControllerForPad(withModel: model)
        } else {
            rootVC = self.rootViewControllerForPhone(withModel: model)
        }
        
        self.window?.rootViewController = rootVC
        
//        // Crear un Library VC de Favoritos
//        let libVC = LibraryTableViewController(model: model)
//        
//        // Se mete Library VC en un Library Nav
//        let libNav = UINavigationController(rootViewController: libVC)
//        
//        // Crear un Book VC
//        let bookVC = BookViewController(model: model.bookAtIndex(0, forTag: model.tags[0])!)
//        
//        // Se mete BookVC en un Book Nav
//        let bookNav = UINavigationController(rootViewController: bookVC)
//        
//        // Crear el Split View Controller
//        let splitVC = UISplitViewController()
//        splitVC.viewControllers = [libNav, bookNav]
//
//        //poner el split como VC
//        window?.rootViewController = splitVC
//        
//        // Asignar delegados
//        libVC.delegate = bookVC
        
        //Mostrar la window
        window?.makeKeyAndVisible()

        return true
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

