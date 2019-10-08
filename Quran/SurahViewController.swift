//
//  ViewController.swift
//  Quran
//
//  Created by Mostafa Saleh on 10/8/19.
//

import SwiftAudio
import UIKit

class SurahViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var textView: UITextView!

    var surahNumber = 1

    // MARK: UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        QuranApiManager.shared.fetch(surahNumber: surahNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(surah): self.display(surah)
            case let .failure(error): self.display(error)
            }
        }
    }

    // MARK: Private functions

    private func display(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    private func display(_ surah: Surah) {
        let surahHTML = surah.toHTML()
        let surahMutableAttributedString = NSMutableAttributedString(attributedString: surahHTML.htmlToAttributedString!)
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: 0,
            .font: UIFont(name: "me_quran", size: 24)!,
            .foregroundColor: UIColor.black,
        ]
        surahMutableAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: surahMutableAttributedString.length))
        textView.attributedText = surahMutableAttributedString
        textView.linkTextAttributes = attributes
        let textRange = textView.textRange(from: textView.beginningOfDocument, to: textView.endOfDocument)!
        textView.setBaseWritingDirection(.rightToLeft, for: textRange)
        textView.textAlignment = .justified
    }

    private func play(from ayahNumber: Int) {
        let url = "https://nuts-realignments.000webhostapp.com/test2/\(surahNumber)/\(ayahNumber).mp3"
        let player = AudioPlayer()
        let audioItem = DefaultAudioItem(audioUrl: url, sourceType: .stream)
        try! player.load(item: audioItem, playWhenReady: true)
    }

    // MARK: UITextViewDelegate

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if let ayahNumber = Int(URL.path.dropFirst()) {
            play(from: ayahNumber)
        }
        return false
    }
}
