//
//  HesnElmoslemDetailsViewController.swift
//  MuslimFit
//
//  Created by Karim on 16/07/2023.
//

import UIKit
import Kingfisher

class HesnElmoslemDetailsViewController: UIViewController {
    
    lazy var containerView: HesnElmoslemDetailsContainerView = {
        let view = HesnElmoslemDetailsContainerView(view: self)
        return view
    }()
    
    var header: Data?
    var body: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
//        if let url = URL(string: header ?? "") {
//            self.containerView.headerImage.kf.indicatorType = .activity
//            self.containerView.headerImage.kf.setImage(with: url)
//        }
        
        self.containerView.headerImage.image = UIImage(data: header ?? Data())
        
//        self.containerView.bodyLabel.text = body
//        self.containerView.bodyTableView.reloadData()
        
//        if let url = URL(string: body ?? "") {
//            self.containerView.bodyImage.kf.indicatorType = .activity
//            self.containerView.bodyImage.kf.setImage(with: url)
//        }
        loadHTMLContent(body ?? "")
    }
    
    override func loadView() {
        super.loadView()
        self.view = containerView
    }
    
    func loadHTMLContent(_ htmlContent: String) {
        let htmlStart = """
        <HTML>
        <HEAD>
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\">
        </HEAD>
        <BODY>
        """
        let htmlEnd = "</BODY></HTML>"
        let htmlString = "\(htmlStart)\(htmlContent)\(htmlEnd)"
        containerView.bodyWebView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
    }
}
