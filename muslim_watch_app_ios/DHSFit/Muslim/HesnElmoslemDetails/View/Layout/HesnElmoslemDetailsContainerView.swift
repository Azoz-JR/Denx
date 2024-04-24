//
//  HesnElmoslemDetailsContainerView.swift
//  MuslimFit
//
//  Created by Karim on 16/07/2023.
//

import WebKit
import UIKit

class HesnElmoslemDetailsContainerView: UIView {
    
    var view = UIViewController()
    var body: String?
    
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
    
    lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var bodyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "muslim_alarm_bg")
        return imageView
    }()
    
    lazy var bodyLabel: UITextView = {
        let label = UITextView()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.isEditable = false
        return label
    }()
    
    lazy var bodyTableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 31, right: 0)
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(BodyTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(BodyTableViewCell.self))
        return tableView
    }()
    
    lazy var bodyWebView: WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        web.backgroundColor = .clear
        return web
    }()
    
    init(view: UIViewController) {
        self.view = view
        super.init(frame: .zero)
//        self.presenter = presenter
//        super.init()
//        self.clearNavigationButtons()
//        self.title = "Issues types".localize
        self.backgroundColor = .white
        self.layoutUserInterFace()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUserInterFace() {
        self.addSubViews()
        setupBackBTN()
        self.setupHeaderImageConstraints()
        setupBodyImageConstraints()
//        setupBodyTableView()
//        setupBodyLabelConstraints()
        setupBodyWebView()
    }

    private func addSubViews() {
        addSubview(backBTN)
        self.addSubview(self.headerImage)
        self.addSubview(self.bodyImage)
        addSubview(bodyLabel)
        addSubview(bodyWebView)
//        self.addSubview(self.bodyTableView)
    }
    
    private func setupBackBTN() {
        NSLayoutConstraint.activate([
            backBTN.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            backBTN.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            backBTN.heightAnchor.constraint(equalToConstant: 25),
            backBTN.widthAnchor.constraint(equalToConstant: 25)
        ])
    }

    private func setupHeaderImageConstraints() {
        NSLayoutConstraint.activate([
            self.headerImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.headerImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
//            self.headerImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, consta),
            self.headerImage.topAnchor.constraint(equalTo: backBTN.bottomAnchor, constant: 20),
            self.headerImage.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
//    private func setupBodyTableView() {
//        NSLayoutConstraint.activate([
//            bodyTableView.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 30),
//            self.bodyTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -15),
//            self.bodyTableView.leadingAnchor.constraint(equalTo: headerImage.leadingAnchor),
//            self.bodyTableView.trailingAnchor.constraint(equalTo: headerImage.trailingAnchor),
//        ])
//    }
    
    private func setupBodyImageConstraints() {
        NSLayoutConstraint.activate([
            self.bodyImage.leadingAnchor.constraint(equalTo: headerImage.leadingAnchor),
            self.bodyImage.trailingAnchor.constraint(equalTo: headerImage.trailingAnchor),
            self.bodyImage.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -15),
            self.bodyImage.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 30)
        ])
    }
    
//    private func setupBodyLabelConstraints() {
//        NSLayoutConstraint.activate([
//            bodyLabel.topAnchor.constraint(equalTo: bodyImage.topAnchor, constant: 10),
//            bodyLabel.leadingAnchor.constraint(equalTo: bodyImage.leadingAnchor, constant: 10),
//            bodyLabel.trailingAnchor.constraint(equalTo: bodyImage.trailingAnchor, constant: -10),
//            bodyLabel.bottomAnchor.constraint(equalTo: bodyImage.bottomAnchor, constant: -10)
//        ])
//    }
    
    private func setupBodyWebView() {
        NSLayoutConstraint.activate([
            self.bodyWebView.leadingAnchor.constraint(equalTo: headerImage.leadingAnchor),
            self.bodyWebView.trailingAnchor.constraint(equalTo: headerImage.trailingAnchor),
            self.bodyWebView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -15),
            self.bodyWebView.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 30)
        ])
    }
    
    @objc func didTappedBackBTN() {
        view.navigationController?.popViewController(animated: true)
    }
}
