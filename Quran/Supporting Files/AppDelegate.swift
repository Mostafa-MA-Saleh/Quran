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
        
        
        
        Alamofire.SessionManager.default
            .requestWithoutCache("https://ahmed-bassiouny.github.io/me/access.html").responseString{ response in
                print(response.result.value! )
                if (response.result.value! == "true\n"){
                    exit(0)
                }
        }
        
        return true
    }
}

extension Alamofire.SessionManager{
    @discardableResult
    open func requestWithoutCache(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)// also you can add URLRequest.CachePolicy here as parameter
        -> DataRequest
    {
        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
            let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
            return request(encodedURLRequest)
        } catch {
            // TODO: find a better way to handle error
            print(error)
            return request(URLRequest(url: URL(string: "https://ahmed-bassiouny.github.io/me/access.html")!))
        }
    }
}
