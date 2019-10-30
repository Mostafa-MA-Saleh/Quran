//
//  ViewController.swift
//  Quran
//
//  Created by Mostafa Saleh on 10/8/19.
//

import AVFoundation
import Soundable
import UIKit

class SurahViewController: UIViewController, UITextViewDelegate, PMyPlayer {
    @IBOutlet var textView: UITextView!
    @IBOutlet var playerButton: UIButton!

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    var surahNumber = 1
    var ayaNumber = 1
    var maxAya = 1
    var AyahInSura = 7 // this variable contian number of ayah in sura
    var player = MyPlayer2()
    var activityIndicator: ActivityIndicator?

    var playerStatus = PlayerStatus.stop

    private var fontSize: CGFloat = 23 {
        didSet {
            if fontSize > 50 {
                fontSize = 50
            } else if fontSize < 10 {
                fontSize = 10
            }
        }
    }

    private let fontName = "me_quran"

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator = ActivityIndicator(view: view, navigationController: nil, tabBarController: nil)
        activityIndicator?.showActivityIndicator()
        QuranApiManager.shared.fetch(surahNumber: surahNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(surah):
                self.display(surah)
                self.activityIndicator?.stopActivityIndicator()
                break
            case let .failure(error):
                self.activityIndicator?.stopActivityIndicator()
                self.display(error)
            }
        }
        player.p = self
        player.vc = self
        titleLabel.font = UIFont(name: "me_quran", size: 25)!
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.stop()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tafseerViewController = segue.destination as? TafseerViewController, let ayahNumber = sender as? Int {
            tafseerViewController.surahNumber = surahNumber
            tafseerViewController.ayahNumber = ayahNumber
        }
    }

    @IBAction func playButtonAction(_ sender: Any) {
        switch playerStatus {
        case .stop:
            // play audio
            ayaNumber = 1
            playerStatus = .playing
            loadingIndicator.startAnimating()
            playerButton.isHidden = true
            play(from: ayaNumber)

            break
        case .playing:
            // stop audio
            player.pause()
            playerStatus = .pause
            if let image = UIImage(named: "play") {
                playerButton.setImage(image, for: .normal)
            }

            break
        case .resume:
            playerStatus = .pause
            player.resume()
            break
        case .pause:
            playerStatus = .playing
            player.resume()
            if let image = UIImage(named: "pause") {
                playerButton.setImage(image, for: .normal)
            }
        default:
            break
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
        maxAya = surah.ayahs.count + 1
        let surahHTML = surah.toHTML()
        let surahMutableAttributedString = NSMutableAttributedString(attributedString: surahHTML.htmlToAttributedString!)
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: 0,
            .font: UIFont(name: fontName, size: fontSize)!,
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
//        let url = "https://nuts-realignments.000webhostapp.com/test2/\(surahNumber)/\(ayahNumber).mp3"
//        let player = AudioPlayer()
//        let audioItem = DefaultAudioItem(audioUrl: url, sourceType: .stream)
//        try! player.load(item: audioItem, playWhenReady: true)
        print("downloadFile")
        downloadFile()
    }

    // MARK: UITextViewDelegate

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if let ayahNumber = Int(URL.path.dropFirst()) {
            displayOptions(for: ayahNumber)
        }
        return false
    }

    private func displayOptions(for ayahNumber: Int) {
        let alert = UIAlertController(title: "خيارات الاية", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "استماع", style: .default) { [weak self] _ in
            self?.play(ayahNumber: ayahNumber)
        })
        alert.addAction(UIAlertAction(title: "تفسير", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: "TafseerSegue", sender: ayahNumber)
        })
        alert.addAction(UIAlertAction(title: "الغاء", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func play(ayahNumber: Int) {
        if playerStatus == .playing || player.player?.isPlaying == true {
            player.stop()
        }
        ayaNumber = ayahNumber
        playerStatus = .playing
        loadingIndicator.startAnimating()
        playerButton.isHidden = true
        play(from: ayaNumber)
    }

    private func downloadFile() {
        createFolderQuran()
        createFolderSura(sura: surahNumber)
        guard let audioUrl = URL(string: "http://husseinelyakhendy.com/test2/\(surahNumber)/\(ayaNumber).mp3") else { return }

        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("quran/\(self.surahNumber)/\(self.ayaNumber).mp3") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                player.play(url: pathComponent)
                DispatchQueue.main.async {
                    self.playerStatus = .playing
                    if let image = UIImage(named: "pause") {
                        self.playerButton.setImage(image, for: .normal)
                    }
                    self.loadingIndicator.stopAnimating()
                    self.playerButton.isHidden = false
                }

                let newAyah = ayaNumber + 1
                repeatDownload(sura: surahNumber, ayah: newAyah)

            } else {
                print("FILE NOT AVAILABLE")
                // you can use NSURLSession.sharedSession to download the data asynchronously

                URLSession.shared.downloadTask(with: audioUrl) { [weak self] location, _, error in
                    guard let self = self, let location = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: location, to: pathComponent)
                        print("File moved to documents folder")
                        self.player.play(url: pathComponent)
                        DispatchQueue.main.async {
                            self.playerStatus = .playing
                            if let image = UIImage(named: "pause") {
                                self.playerButton.setImage(image, for: .normal)
                            }
                            self.loadingIndicator.stopAnimating()
                            self.playerButton.isHidden = false
                        }
                        let newAyah = self.ayaNumber + 1
                        self.repeatDownload(sura: self.surahNumber, ayah: newAyah)
                    } catch {
                        self.printLN(error.localizedDescription)
                        self.playerStatus = .stop
                        DispatchQueue.main.sync {
                            if let image = UIImage(named: "play") {
                                self.playerButton.setImage(image, for: .normal)
                            }
                            self.loadingIndicator.stopAnimating()
                            self.playerButton.isHidden = false
                        }
                    }
                }.resume()
            }
        } else {
            printLN("FILE PATH NOT AVAILABLE")
        }
    }

    func printLN(_ msg: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "الغاء", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func repeatDownload(sura: Int, ayah: Int) {
        print("sura= \(sura) aya = \(ayah)")
        guard let audioUrl = URL(string: "http://husseinelyakhendy.com/test2/\(sura)/\(ayah).mp3") else { return }
        if ayah <= maxAya {
            let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent("quran/\(sura)/\(ayah).mp3") {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    let newAyah = ayah + 1
                    repeatDownload(sura: sura, ayah: newAyah)
                } else {
                    printLN("FILE NOT AVAILABLE")
                    // you can use NSURLSession.sharedSession to download the data asynchronously

                    URLSession.shared.downloadTask(with: audioUrl) { [weak self] location, _, error in
                        guard let self = self, let location = location, error == nil else { return }
                        do {
                            // after downloading your file you need to move it to your destination url
                            try FileManager.default.moveItem(at: location, to: pathComponent)
                            print("File moved to documents folder")
                            let newAyah = ayah + 1
                            self.repeatDownload(sura: sura, ayah: newAyah)
                        } catch {
                            self.printLN(error.localizedDescription)
                        }
                    }.resume()
                }

            } else {
                printLN("FILE PATH NOT AVAILABLE")
            }
        }
    }

    func finish() {
        ayaNumber += 1
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("quran/\(surahNumber)/\(ayaNumber).mp3") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                player.play(url: pathComponent)
            } else {
                print("FILE NOT AVAILABLE")
                // you can use NSURLSession.sharedSession to download the data asynchronously

                if let audioUrl = URL(string: "https://nuts-realignments.000webhostapp.com/test2/\(surahNumber)/\(ayaNumber).mp3") {
                    URLSession.shared.downloadTask(with: audioUrl) { location, _, error in
                        guard let location = location, error == nil else { return }
                        do {
                            // after downloading your file you need to move it to your destination url
                            try FileManager.default.moveItem(at: location, to: pathComponent)
                            print("File moved to documents folder")
                        } catch {
                            self.printLN(error.localizedDescription)
                        }
                    }.resume()
                }
            }
        } else {
            // playingState = .paused
        }
    }

    private func createFolderQuran() {
        let fileManager = FileManager.default
        if let tcachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let filePath = tcachesDirectory.appendingPathComponent("quran")
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                    print(" created ")
                } catch {
                    printLN(error.localizedDescription)
                }
            }
            print("Document directory is \(filePath)")
        }
    }

    private func createFolderSura(sura: Int) {
        let fileManager = FileManager.default
        if let tcachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let filePath = tcachesDirectory.appendingPathComponent("quran/\(sura)")
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                    print(" created ")
                } catch {
                    printLN("Couldn't create document directory")
                }
            }
            print("Document directory is \(filePath)")
        }
    }

    func activityIndicator(_ title: String) {
        var strLabel = UILabel()
        var activityIndicator = UIActivityIndicatorView()
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)

        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width / 2, y: view.frame.midY - strLabel.frame.height / 2, width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true

        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()

        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }

    @IBAction func didClickSmallerFont() {
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText!)
        fontSize -= 2
        attributedString.addAttribute(.font, value: UIFont(name: fontName, size: fontSize)!, range: NSRange(location: 0, length: attributedString.length))
        textView.attributedText = attributedString
    }

    @IBAction func didClickLargerFont() {
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText!)
        fontSize += 2
        attributedString.addAttribute(.font, value: UIFont(name: fontName, size: fontSize)!, range: NSRange(location: 0, length: attributedString.length))
        textView.attributedText = attributedString
    }
}

class MyPlayer2: NSObject, AVAudioPlayerDelegate {
    var player: AVAudioPlayer?
    var p: PMyPlayer?
    var vc: UIViewController?

    func play(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])

            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
            player.delegate = self
        } catch let error as NSError {
            self.printLN(error.description)
            self.printLN(error.localizedDescription)
        }
    }

    func printLN(_ msg: String) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "الغاء", style: .destructive, handler: nil))
        vc!.present(alert, animated: true, completion: nil)
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        p?.finish()
    }

    func stop() {
        guard let p = player else { return }
        p.stop()
    }

    func pause() {
        guard let p = player else { return }
        p.pause()
    }

    func resume() {
        guard let p = player else { return }
        p.play()
    }
}

protocol PMyPlayer {
    func finish()
}
