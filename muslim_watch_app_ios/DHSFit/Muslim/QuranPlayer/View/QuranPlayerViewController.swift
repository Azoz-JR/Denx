//
//  QuranPlayerViewController.swift
//  MuslimFit
//
//  Created by Karim on 26/09/2023.
//

import UIKit

class QuranPlayerViewController: UIViewController {

    let muslimWorker: MuslimWorkerProtocol = MuslimWorker()
    lazy var containerView: QuranPlayerContainerView = {
        let view = QuranPlayerContainerView(view: self)
        return view
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        getQuran(lang: language)
    }
    
    override func loadView() {
        super.loadView()
        self.view = containerView
    }
    
    func getQuran(lang: String) {
        muslimWorker.quran(lang) { result in
            switch result {
            case let .success(responseModel):
                self.containerView.quran = responseModel ?? []
                self.containerView.quranPlayerTableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getAdaih(lang: String) {
                
        muslimWorker.adaih(lang) { result in
            switch result {
            case let .success(responseModel):
                self.containerView.adaih = responseModel ?? []
                self.containerView.quranPlayerTableView.reloadData()
//                for i in responseModel?.data ?? [] {
//
////                    guard let url = URL(string: "https://denx.suppwhey.net\(i.url ?? "")") else {
////                            return
////                        }
//
//                }
                
//                self.defaultsManager.writeStoreable(key: UserDefaultsKeys.adaih, value: responseModel)
                
                
//                self.containerView.adaihTableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }

}
