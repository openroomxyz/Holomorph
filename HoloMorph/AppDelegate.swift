
//
//  AppDelegate.swift
//  Holoss
//
//  Created by Rok Kosuta on 07/10/2017.
//  Copyright © 2017 Rok Kosuta. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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
        //added code
        print("AppDelegate.applicationDidBecomeActive")
        UIApplication.shared.isIdleTimerDisabled = true //screen will not go to sleep!
        //end added code
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        //self.saveContext() //added from CoreData web example
        print("Time to save things!")
        (self.window!.rootViewController as! ViewController).appDelegate_call_save_things_before_app_terminates()
    }
    
    //OPENING FROM URL
    //not working
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
        print("WOW FROM MAIL FROM MAIL")
        print(url)
        
        var storeData = ""
        
        do {
            storeData = try String(contentsOfFile : url.path)
        }
        catch let error as NSError
        {
            print("read error due to :" + error.localizedDescription)
        }
        
        //print(storeData)
        
        let vc = self.window!.rootViewController as! ViewController
        //vc.recivedTextFromAppDelegate(text: storeData)
        //vc.recivedURLFRomAppDelegate(url : url)
        vc.event_from_open_in(url : url, str : storeData)
        return true
    }
    
    /*
     func application(application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: Any?) -> Bool {
     //url contains a URL to the file your app shall open
     
     //In my EXAMPLE I would want to read the file as a dictionary
     //let dictionary = NSDictionary.init(contentsOfURL: url)
     print("open URL rok")
     return true
     }
     */
    
    //CoreData copy / paste code from url :
    
    // MARK: - Core Data stack
    /*
     lazy var applicationDocumentsDirectory: NSURL = {
     // The directory the application uses to store the Core Data store file. This code uses a directory named "uk.co.plymouthsoftware.core_data" in the application's documents Application Support directory.
     let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
     return urls[urls.count-1] as NSURL
     }()
     
     lazy var managedObjectModel: NSManagedObjectModel = {
     // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
     let modelURL = Bundle.main.url(forResource: "MyDataModel", withExtension: "momd")!
     return NSManagedObjectModel(contentsOf: modelURL)!
     }()
     
     lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
     // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
     // Create the coordinator and store
     let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
     let url = self.applicationDocumentsDirectory.appendingPathComponent("Holoss.sqlite")
     var failureReason = "There was an error creating or loading the application's saved data."
     do {
     try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
     } catch {
     // Report any error we got.
     var dict = [String: AnyObject]()
     dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
     dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
     
     dict[NSUnderlyingErrorKey] = error as NSError
     let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
     // Replace this with code to handle the error appropriately.
     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
     NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
     abort()
     }
     
     return coordinator
     }()
     
     lazy var managedObjectContext: NSManagedObjectContext = {
     // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
     let coordinator = self.persistentStoreCoordinator
     var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
     managedObjectContext.persistentStoreCoordinator = coordinator
     return managedObjectContext
     }()
     
     // MARK: - Core Data Saving support
     
     func saveContext () {
     if managedObjectContext.hasChanges {
     do {
     try managedObjectContext.save()
     } catch {
     // Replace this implementation with code to handle the error appropriately.
     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
     let nserror = error as NSError
     NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
     abort()
     }
     }
     }
     */
    //end CoreData copy / paste code from url :
    
}



//
//  AppDelegate.swift
//  HoloMorph
//
//  Created by Rok Kosuta on 20/03/2018.
//  Copyright © 2018 Rok Kosuta. All rights reserved.
//
/*
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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
*/
