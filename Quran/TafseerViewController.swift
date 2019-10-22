//
//  TafseerViewController.swift
//  Quran
//
//  Created by Mostafa Saleh on 10/22/19.
//

import UIKit

class TafseerViewController: UIViewController {
    @IBOutlet var tabaryTafseerTextView: UITextView!
    @IBOutlet var ibnKatheerTafseerTextView: UITextView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var activityIndicatorViewContainer: UIView!

    var surahNumber: Int!
    var ayahNumber: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTafseer()
    }

    private func fetchTafseer() {
        TafseerApiManager.shared.fetch(for: ayahNumber, in: surahNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success((tabaryTafseer, ibnKatheerTafseer)):
                self.display(tafseer: tabaryTafseer, in: self.tabaryTafseerTextView)
                self.display(tafseer: ibnKatheerTafseer, in: self.ibnKatheerTafseerTextView)
            case let .failure(error):
                self.display(error: error)
            }
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorViewContainer.isHidden = true
        }
    }

    private func display(tafseer: Tafseer, in textView: UITextView) {
        let titleStyle = NSMutableParagraphStyle()
        titleStyle.alignment = .center
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 26),
            .paragraphStyle: titleStyle,
        ]
        let style = NSMutableParagraphStyle()
        style.alignment = .justified
        style.lineSpacing = 6
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 20),
            .paragraphStyle: style
        ]
        let tafseerAttributedString = NSMutableAttributedString(string: "\(tafseer.tafseerName)\n\n\(tafseer.text)")
        tafseerAttributedString.addAttributes(titleAttributes, range: NSRange(location: 0, length: tafseer.tafseerName.count))
        tafseerAttributedString.addAttributes(attributes, range: NSRange(location: tafseer.tafseerName.count + 2, length: tafseer.text.count))
        textView.attributedText = tafseerAttributedString
    }

    private func display(error: Error) {
        let alert = UIAlertController(title: "خطأ", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "موافق", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true, completion: nil)
    }
}
