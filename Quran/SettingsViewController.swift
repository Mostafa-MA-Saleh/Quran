//
//  SettingsViewController.swift
//  Quran
//
//  Created by Mostafa Saleh on 11/2/19.
//

import UIKit

class SettingsViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var textSizeLabel: UILabel!
    @IBOutlet var textSizePickerView: UIPickerView!

    private let textField = UITextField(frame: .zero)

    private let textSizes = Array(10 ... 50)

    override func viewDidLoad() {
        super.viewDidLoad()
        let savedFontSize = UserDefaults.standard.float(forKey: AppDelegate.KEY_FONT_SIZE)
        if savedFontSize == 0 {
            textSizeLabel.text = "\(Int(AppDelegate.DEFAULT_FONT_SIZE))"
        } else {
            textSizeLabel.text = "\(Int(savedFontSize))"
        }
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76 / 255, green: 217 / 255, blue: 100 / 255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "حفظ", style: UIBarButtonItem.Style.done, target: self, action: #selector(didClickDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "إلغاء", style: UIBarButtonItem.Style.plain, target: self, action: #selector(didClickDone))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textField.inputView = textSizePickerView
        textField.inputAccessoryView = toolBar
        textSizePickerView.selectRow(textSizes.index(of: Int(savedFontSize)) ?? 0, inComponent: 0, animated: false)
        view.addSubview(textField)
    }

    // MARK: Private functions

    @objc private func didClickDone(_ sender: UIBarButtonItem) {
        if sender.style == .done {
            let textSize = textSizes[textSizePickerView.selectedRow(inComponent: 0)]
            textSizeLabel.text = "\(textSize)"
            UserDefaults.standard.set(Float(textSize), forKey: AppDelegate.KEY_FONT_SIZE)
        }
        textField.resignFirstResponder()
    }

    // MARK: UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return textSizes.count
    }

    // MARK: UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(textSizes[row])"
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            textField.becomeFirstResponder()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
