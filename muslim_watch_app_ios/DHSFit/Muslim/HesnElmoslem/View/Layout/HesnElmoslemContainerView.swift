//
//  HesnElmoslemContainerView.swift
//  MuslimFit
//
//  Created by Karim on 14/07/2023.
//

import Foundation
import UIKit

class HesnElmoslemContainerView: UIView {
    
    var view = UIViewController()
    var hesnElmoslem = [HesnElmoslemData]()
    let defaultsManager: UserDefaultsProtocol = UserDefaultsManager()
    let coreDataManager = CoreDataManager()
    
    lazy var background: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "muslim_alarm_bg")
        return imageView
    }()
    
    lazy var backBTN: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "home_date_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        if LanguageManager.shareInstance().getHttpLanguageType() == "ar" {
            button.transform = CGAffineTransform(rotationAngle: 180 - 45)
        }
        button.addTarget(self, action: #selector(didTappedBackBTN), for: .touchUpInside)
        return button
    }()
    
    lazy var HesnElmoslemTableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 31, right: 0)
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(HesnElmoslemTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(HesnElmoslemTableViewCell.self))
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
        setupBackBTN()
        self.setupTableViewConstraints()
    }

    private func addSubViews() {
        addSubview(background)
        addSubview(backBTN)
        self.addSubview(self.HesnElmoslemTableView)
    }
    
    private func setupBackground() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: self.topAnchor),
            background.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupBackBTN() {
        NSLayoutConstraint.activate([
            backBTN.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            backBTN.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            backBTN.heightAnchor.constraint(equalToConstant: 25),
            backBTN.widthAnchor.constraint(equalToConstant: 25)
        ])
    }

    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            self.HesnElmoslemTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.HesnElmoslemTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.HesnElmoslemTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.HesnElmoslemTableView.topAnchor.constraint(equalTo: backBTN.bottomAnchor, constant: 10)
        ])
    }
    
    @objc func didTappedBackBTN() {
        view.navigationController?.popViewController(animated: true)
    }
}
