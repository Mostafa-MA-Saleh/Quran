//
//  MoveToPageViewController.swift
//  Quran
//
//  Created by alexlab on 11/23/19.
//

import UIKit

class MoveToPageViewController: UIViewController {
    
    @IBOutlet var pageTextField: UITextField!
    
    var selectedSura : MainSura?
    var selectedPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func moveToPageAction(_ sender: UIButton) {
        if let number = pageTextField.text{
            if !number.isEmpty {
                dismissKeyboard()
                sender.isHidden = true
                let jsonData = quarnIndexJsonString.data(using: .utf8)!
                let surahArray =  try! JSONDecoder().decode([MainSura].self, from: jsonData)
                selectedPage = Int(number) ?? 1
                for  item in surahArray{
                    if selectedPage >= item.startPage && selectedPage <= item.endPage {
                        selectedSura = item
                        break
                    }
                }
                sender.isHidden = false
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let surahViewController = segue.destination as? SurahViewController {
            
            surahViewController.surah = selectedSura
            surahViewController.currentPageNumber = selectedPage
            
        }
    }
}
