//
//  AdaihViewController.swift
//  MuslimFit
//
//  Created by Karim on 14/07/2023.
//

import UIKit

class AdaihViewController: UIViewController {

    let muslimWorker: MuslimWorkerProtocol = MuslimWorker()
    lazy var containerView: AdaihContainerView = {
        let view = AdaihContainerView(view: self)
        return view
    }()
    
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    let defaultsManager: UserDefaultsProtocol = UserDefaultsManager()
    
    let coreDataManager = CoreDataManager()
    
    var language: String {
        switch LanguageManager.shareInstance().getHttpLanguageType() {
        case "ar":
            return "arabic"
        case "en":
            return "english"
        case "fr":
            return "french"
//        case "de":
//            return "german"
//        case "el":
//            return "greece"
        case "es":
            return "spanish"
//        case "fa":
//            return "persian"
//        case "he":
//            return "hebrew"
        case "id":
            return "indonesian"
//        case "it":
//            return "italy"
//        case "pl":
//            return "poland"
//        case "pt":
//            return "portugal"
        case "ru":
            return "russian"
        case "tr":
            return "turkish"
        case "ur":
            return "urdo"
//        case "vi":
//            return "vietnam"
        default:
            return "arabic"
        }
    }
    
    func getAdaih(lang: String) {
        
//        self.coreDataManager.clearLogs()
        
        muslimWorker.adaih(lang) { result in
            switch result {
            case let .success(responseModel):
//                self.containerView.adaih = responseModel?.data ?? []
                for i in responseModel ?? [] {
                    
                    guard let url = URL(string: "\(i.url ?? "")") else {
                            return
                        }
                    
//                    guard let data = try? Data(contentsOf: url) else { return }
//                    print(i.id)
                    
//                    self.coreDataManager.saveAdaih(id: "\(i.id ?? 0)", audio: url, title: i.title ?? "", played: i.played ?? false)
                    
//                    guard let audioURL = URL(string: url) else {
//                        print("Invalid audio URL")
//                        return
//                    }

//                    DispatchQueue.global().async {
                        self.downloadAudio(url: url) { (destinationURL) in
                            if let destinationURL = destinationURL {
                                // File downloaded successfully, use the destinationURL for offline playback
    //                            UserDefaults.standard.setValue(destinationURL, forKey: "url")
                                print(destinationURL)
    //                            self.containerView.urls.append(destinationURL)
//                                DispatchQueue.main.async {
                                    self.coreDataManager.saveAdaih(id: "\(i.id ?? 0)", audio: destinationURL, title: i.title ?? "", played: i.played ?? false)
//                                }
                                
                            } else {
                                // File download failed
                            }
                        }
//                    }
                    
                }
                
//                self.defaultsManager.writeStoreable(key: UserDefaultsKeys.adaih, value: responseModel)
                
                
//                self.containerView.adaihTableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func downloadAudio(url: URL, completion: @escaping (URL?) -> Void) {
        let session = URLSession(configuration: .default)
        let downloadTask = session.downloadTask(with: url) { (location, _, error) in
            guard let location = location, error == nil else {
                print("Failed to download audio file:", error?.localizedDescription ?? "")
                completion(nil)
                return
            }
            
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let destinationURL = URL(fileURLWithPath: documentsPath).appendingPathComponent(url.lastPathComponent)
            
            do {
                try FileManager.default.moveItem(at: location, to: destinationURL)
                print("Downloaded audio file:", destinationURL.path)
                completion(destinationURL)
            } catch {
                print("Failed to move audio file to destination:", error.localizedDescription)
                completion(nil)
            }
        }
        
        downloadTask.resume()
    }
    
    @objc func reloadData() {

        DispatchQueue.main.async {
            if self.coreDataManager.fetchAdaih().count < UserDefaults.standard.integer(forKey: "adaihCount") {
                self.containerView.adaihTableView.tableFooterView?.isHidden = false
            } else {
                self.containerView.adaihTableView.tableFooterView?.isHidden = true
            }
            self.containerView.adaihTableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if coreDataManager.fetchAdaih().count < UserDefaults.standard.integer(forKey: "adaihCount") {
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.containerView.adaihTableView.bounds.width, height: CGFloat(50))

            self.containerView.adaihTableView.tableFooterView = spinner
            self.containerView.adaihTableView.tableFooterView?.isHidden = false
        } else {
            self.containerView.adaihTableView.tableFooterView?.isHidden = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name("ReloadData"), object: nil)
        
        
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
//        self.containerView.adaihTableView.reloadData()
        
//        if defaultsManager.value(key: UserDefaultsKeys.Adaih) == nil {
//            getAdaih(lang: language)
//        }
        
        
//        if let adaih: AdaihModel = defaultsManager.valueStoreable(key: UserDefaultsKeys.adaih) {
//print("adaih")
//        } else {
//            getAdaih(lang: language)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.containerView.adaihTableView.reloadData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.containerView.audioPlayer = nil
//        self.containerView.timer = nil
    }
    
    override func loadView() {
        super.loadView()
        self.view = containerView
    }
    
//    func getAdaih(lang: String) {
//
//        muslimWorker.adaih(lang) { result in
//            switch result {
//            case let .success(responseModel):
////                self.containerView.adaih = responseModel?.data ?? []
////                for i in responseModel?.data ?? [] {
////                    self.coreDataManager.saveAdaih(id: "\(i.id ?? 0)", url: i.url ?? "", title: i.title ?? "", played: i.played ?? false)
////                }
//
//                self.defaultsManager.writeStoreable(key: UserDefaultsKeys.adaih, value: responseModel)
//
//
//                self.containerView.adaihTableView.reloadData()
//            case let .failure(error):
//                print(error)
//            }
//        }
//    }
}
