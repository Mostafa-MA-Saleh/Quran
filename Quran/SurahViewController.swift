//
//  ViewController.swift
//  Quran
//
//  Created by Mostafa Saleh on 10/8/19.
//

import SwiftAudio
import UIKit
import AVFoundation


class SurahViewController: UIViewController, UITextViewDelegate ,PMyPlayer {
    @IBOutlet var textView: UITextView!
    @IBOutlet weak var playerButton: UIButton!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var surahNumber = 2
    var ayaNumber = 1
    var maxAya = 1
    var AyahInSura = 7 // this variable contian number of ayah in sura
    var player = MyPlayer2()
    var activityIndicator : ActivityIndicator?
    
    var playerStatus  = PlayerStatus.stop
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = ActivityIndicator(view:view, navigationController:nil,tabBarController: nil)
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
    }
  
    @IBAction func playButtonAction(_ sender: Any) {

        switch playerStatus {
        case .stop:
            //play audio
            ayaNumber = 1
            playerStatus = .playing
            loadingIndicator.startAnimating()
            playerButton.isHidden = true
            play(from: ayaNumber)
            
            
            break
        case .playing:
            //stop audio
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
            .font: UIFont(name: "Traditional Arabic", size: 23)!,
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
            let alert = UIAlertController(title: "", message: "هل تريد الاستماع الى هذه الاية", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "نعم", style: .default, handler: { action in
                alert.dismiss(animated: true, completion: nil)
                self.ayaNumber = ayahNumber
                self.playerStatus = .playing
                self.loadingIndicator.startAnimating()
                self.playerButton.isHidden = true
                self.play(from: self.ayaNumber)
            }))
            alert.addAction(UIAlertAction(title: "لا", style: .cancel, handler: { action in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        return false
    }
    
    
    private func downloadFile(){
        createFolderQuran();
        createFolderSura(sura: surahNumber)
        guard let audioUrl =  URL(string: "https://nuts-realignments.000webhostapp.com/test2/\(surahNumber)/\(ayaNumber).mp3") else {return}
       
                let path = NSSearchPathForDirectoriesInDomains(.musicDirectory, .userDomainMask, true)[0] as String
                let url = NSURL(fileURLWithPath: path)
                if let pathComponent = url.appendingPathComponent("quran/\(self.surahNumber)/\(self.ayaNumber).mp3") {
                    let filePath = pathComponent.path
                    let fileManager = FileManager.default
                    if fileManager.fileExists(atPath: filePath) {
                        print("FILE AVAILABLE")
                        
                        self.player.play(url:pathComponent)
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
                        
                        
                    } else {
                        print("FILE NOT AVAILABLE")
                        // you can use NSURLSession.sharedSession to download the data asynchronously
                        
                        
                        URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
                            guard let location = location, error == nil else { return }
                            do {
                                // after downloading your file you need to move it to your destination url
                                try FileManager.default.moveItem(at: location, to: pathComponent)
                                print("File moved to documents folder")
                                self.player.play(url:pathComponent)
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
                                print(error)
                            }
                            }.resume()
                    }
                } else {
                    print("FILE PATH NOT AVAILABLE")
                }
            
        
        
    }
    
    
    func repeatDownload(sura:Int,ayah:Int){
        print("sura= \(sura) aya = \(ayah)")
        guard let audioUrl =  URL(string: "https://nuts-realignments.000webhostapp.com/test2/\(sura)/\(ayah).mp3") else {return}
            if (ayah <= maxAya){
                let path = NSSearchPathForDirectoriesInDomains(.musicDirectory, .userDomainMask, true)[0] as String
                let url = NSURL(fileURLWithPath: path)
                if let pathComponent = url.appendingPathComponent("quran/\(sura)/\(ayah).mp3") {
                    let filePath = pathComponent.path
                    let fileManager = FileManager.default
                    if fileManager.fileExists(atPath: filePath) {
                        let newAyah = ayah + 1
                        self.repeatDownload(sura: sura, ayah: newAyah)
                    } else {
                        print("FILE NOT AVAILABLE")
                        // you can use NSURLSession.sharedSession to download the data asynchronously
                        
                        URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
                            guard let location = location, error == nil else { return }
                            do {
                                // after downloading your file you need to move it to your destination url
                                try FileManager.default.moveItem(at: location, to: pathComponent)
                                print("File moved to documents folder")
                                let newAyah = ayah + 1
                                self.repeatDownload(sura: sura, ayah: newAyah)
                            } catch {
                                print(error)
                                
                            }
                            }.resume()
                    }
                    
                } else {
                    print("FILE PATH NOT AVAILABLE")
                }
            
        }
    }
    
    func finish() {
        ayaNumber += 1
        let path = NSSearchPathForDirectoriesInDomains(.musicDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("quran/\(surahNumber)/\(ayaNumber).mp3") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                print("FILE AVAILABLE")
                
                player.play(url:pathComponent)
            } else {
                print("FILE NOT AVAILABLE")
                // you can use NSURLSession.sharedSession to download the data asynchronously
                
                if let audioUrl = URL(string:"https://nuts-realignments.000webhostapp.com/test2/\(surahNumber)/\(ayaNumber).mp3"){
                    
                    URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
                        guard let location = location, error == nil else { return }
                        do {
                            // after downloading your file you need to move it to your destination url
                            try FileManager.default.moveItem(at: location, to: pathComponent)
                            print("File moved to documents folder")
                        } catch {
                            print(error)
                        }
                        }.resume()
                }
            }
        }else {
           // playingState = .paused
        }
    }
    private func createFolderQuran(){
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .musicDirectory, in: .userDomainMask).first {
            let filePath =  tDocumentDirectory.appendingPathComponent("quran")
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                    print(" created ")
                } catch {
                    print("Couldn't create document directory")
                }
            }
            print("Document directory is \(filePath)")
        }
    }
    
    private func createFolderSura(sura:Int){
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .musicDirectory, in: .userDomainMask).first {
            let filePath =  tDocumentDirectory.appendingPathComponent("quran/\(sura)")
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                    print(" created ")
                } catch {
                    print("Couldn't create document directory")
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
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
  
}

class MyPlayer2: NSObject,AVAudioPlayerDelegate {
    
    var player :AVAudioPlayer?
    var p:PMyPlayer?
    
    
    func play(url:URL) {
        
        do{
            player = try AVAudioPlayer(contentsOf: url)
            
            guard let player = player else { return }
            player.prepareToPlay()
            player.play()
            player.delegate = self
        }catch let error as NSError {
            print(error.description)
            print(error.localizedDescription)
            
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        p?.finish()
    }
    
    func stop() {
        guard let p = player else {return}
        p.stop()
    }
    
    func pause() {
        guard let p = player else {return}
        p.pause()
    }
    
    func resume(){
        guard let p = player else {return}
        p.play()
    }
    
}

protocol PMyPlayer {
    func finish()
}


