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


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // Crear window
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // Mirar si es la primera vez que se arranca la aplicación
        // Esto se hace con User defaults
        
        
        // crear una instancia de modelo
        // let data = NSData(contentsOfURL: NSURL(string: "https://t.co/K9ziV0z3SJ")!)
        
        
//        do{
//            let json = try loadFromURL()
//            print(json)
//            
//            var books = [Book]()
//            for dict in json{
//                do{
//                    let book = try decode(book: dict)
//                    books.append(book)
//                }catch{
//                    print("Error al procesar \(dict)")
//                }
//                
//            }
//
//            print(books.description)
//
//            var dicc = [Tag : [Book]]()
//            for eachBook in books{
//                for eachTag in eachBook.tags{
//                    dicc[eachTag]?.append(eachBook)
//                }
//            }
        
//            
//        for (key, value) in dicc {
//            print("Dictionary key \(key) -  Dictionary value \(value)")
//        }
        
            // Podemos crear el modelo
            //let model = StarWarsUniverse(characters: chars)
            let model = Library()
            // Crear un VC
        let libro = model.books[0]
//        let bVC = BookViewController(model: libro)
            let lVC = LibraryTableViewController(model: model)
        
            // Lo metemos en un Nav
            let nav = UINavigationController(rootViewController: lVC)
        
            //creamos book VC
//            let bookVC = BookViewController(model: model.bookAtIndex(0, forTag: model.tags[1])!)
        
            //meterlo en otro navVC
//            let charNav = UINavigationController(rootViewController: charVC)
            
            //crear el split view
//            let splitVC = UISplitViewController()
//            splitVC.viewControllers = [uNav, charNav]
//            
            //poner el split como VC
            
            window?.rootViewController = nav
        
            // Asignar delegados
//            libVC.delegate = bookVC
        
            window?.makeKeyAndVisible()

            return true
            
//        }catch{
//            fatalError("Error while loading JSON")
//        }
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

