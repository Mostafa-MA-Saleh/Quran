//
//  AppDelegate.swift
//  Quran
//
//  Created by Mostafa Saleh on 10/8/19.
//

import AlamofireNetworkActivityIndicator
import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    static let KEY_BOOKMARK_POSITION = "KeyBookmarkPosition"
    static let KEY_BOOKMARK_SURAH = "KeyBookmarkSurah"
    static let KEY_BOOKMARK_AYAH = "KeyBookmarkAyah"
    static let KEY_BOOKMARK_PAGE = "KeyBookmarkPage"
    static let KEY_FONT_SIZE = "FontSizeKey"
    static let DEFAULT_FONT_SIZE: Float = 26
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NetworkActivityIndicatorManager.shared.isEnabled = true
      
        
        return true
    }
}
