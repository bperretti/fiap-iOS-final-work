//
//  AppDelegate.swift
//  BarbaraPedroKauaTrabalhoFIAP
//
//  Created by Bárbara Perretti on 29/12/20.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.registerDefaultsFromSettingsBundle()
        return true
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "PurchaseDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Error load bd")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: -Setting bundles get default values
    
    func registerDefaultsFromSettingsBundle(){
       guard let settingsBundle = Bundle.main.path(forResource: "Settings", ofType: "bundle") else {
           print("Could not locate Settings.bundle")
           return
       }

       guard let settings = NSDictionary(contentsOfFile: settingsBundle+"/Root.plist") else {
           print("Could not read Root.plist")
           return
       }

       let preferences = settings["PreferenceSpecifiers"] as! NSArray
       var defaultsToRegister = [String: AnyObject]()
       for prefSpecification in preferences {
           if let post = prefSpecification as? [String: AnyObject] {
               guard let key = post["Key"] as? String,
                   let defaultValue = post["DefaultValue"] else {
                       continue
               }
               defaultsToRegister[key] = defaultValue
           }
       }
       UserDefaults.standard.register(defaults: defaultsToRegister)
   }

}

