//
//  MainViewController.swift
//  Quran
//
//  Created by Admin on 11/30/19.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func bookMarkAction(_ sender: Any) {
        if UserDefaults.standard.object(forKey: AppDelegate.KEY_BOOKMARK_SURAH) != nil {
            performSegue(withIdentifier: "BookmarkSegue", sender: self)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let surahViewController = segue.destination as? SurahViewController {
             
                   surahViewController.isOpenedWithBookmark = true
               
           }
       }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
