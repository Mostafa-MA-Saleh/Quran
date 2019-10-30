//
//  SearchViewController.swift
//  Quran
//
//  Created by Admin on 10/9/19.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    // Do any additional setup after loading the view.

    var surahArray: [MainSura] = []
    var filteredSurahArray: [MainSura] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let jsonData = quarnIndexJsonString.data(using: .utf8)!
        surahArray.append(contentsOf: try! JSONDecoder().decode([MainSura].self, from: jsonData))
        filteredSurahArray.append(contentsOf: surahArray)
        navigationController?.title = "فهرس القران الكريم"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let surahViewController = segue.destination as? SurahViewController {
            if let rowNumber = tableView.indexPathForSelectedRow?.row {
                surahViewController.surahNumber = Int(filteredSurahArray[rowNumber].index)!
            } else {
                surahViewController.isOpenedWithBookmark = true
            }
        }
    }

    // MARK: UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSurahArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "search_cell", for: indexPath) as! SuraTableViewCell
        let surah = filteredSurahArray[indexPath.row]
        cell.label.text = surah.titleAr
        cell.ayaNumberLabel.text = "عدد الايات  \(surah.count)"
        cell.indexLabel.text = "(\(surah.index))"
        cell.typeLabel.text = surah.getType()
        return cell
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: Private functions

    @IBAction func textFieldDidChange(_ textField: UITextField) {
        filteredSurahArray.removeAll()
        if textField.text!.isEmpty {
            filteredSurahArray.append(contentsOf: surahArray)
        } else {
            filteredSurahArray.append(contentsOf: surahArray.filter { $0.titleAr.contains(textField.text!) })
        }
        tableView.reloadSections([0], with: .automatic)
    }

    @IBAction func didClickBookmark() {
        if UserDefaults.standard.object(forKey: SurahViewController.KEY_BOOKMARK_SURAH) != nil {
            performSegue(withIdentifier: "BookmarkSegue", sender: self)
        }
    }
}
