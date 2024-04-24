//
//  MuslimContainerView.swift
//  MuslimFit
//
//  Created by Karim on 12/07/2023.
//

import Foundation
import UIKit
import AppStructureFeature
import NoorUI

class MuslimContainerView: UIView {
    
//    var appDelegate = AppDelegate()
    
//    let windowScene = UIWindowScene(session: <#T##UISceneSession#>, connectionOptions: <#T##UIScene.ConnectionOptions#>)
    
//    var presenter: MuslimPresenterProtocol
    var view = UIViewController()
    var phoneCurLang = LanguageManager.shareInstance().getHttpLanguageType()
    let languages = ["ar", "de", "el", "en", "es", "fa", "fr", "he", "id", "it", "pl", "pt", "ru", "tr", "ur", "vi"]
    var launchStartup: LaunchStartup?
    let container = Container.shared
//    let downloadManagerContainer = DownloadManagerContainer.shared
    
    lazy var background: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "muslim_bg")
        return imageView
    }()
    
    lazy var muslimTableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 31, right: 0)
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(MuslimTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MuslimTableViewCell.self))
        return tableView
    }()
    
    init(view: UIViewController) {
        self.view = view
        super.init(frame: .zero)
//        self.presenter = presenter
//        super.init()
//        self.clearNavigationButtons()
//        self.title = "Issues types".localize
//        self.backgroundColor = .green
        self.layoutUserInterFace()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUserInterFace() {
        self.addSubViews()
        setupBackground()
        self.setupTableViewConstraints()
    }

    private func addSubViews() {
        addSubview(background)
        self.addSubview(self.muslimTableView)
    }

    private func setupBackground() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: self.topAnchor),
            background.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            self.muslimTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.muslimTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.muslimTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.muslimTableView.topAnchor.constraint(equalTo: self.topAnchor)
        ])
    }
}
