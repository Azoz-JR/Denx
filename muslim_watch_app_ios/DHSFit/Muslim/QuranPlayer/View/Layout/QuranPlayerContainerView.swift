//
//  QuranPlayerContainerView.swift
//  MuslimFit
//
//  Created by Karim on 26/09/2023.
//

import Foundation
import UIKit

class QuranPlayerContainerView: UIView {
    
    var view = UIViewController()
    var adaih = [AdaihModel]()
    var quran = [QuranModel]()
    let coreDataManager = CoreDataManager()
    var fetchedQuran = [Quran]()
    var fetchedQuranIds = [String]()
    
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
    
    lazy var favouritedBTN: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "favourited"), for: .normal)
//        button.tintColor = .black
        button.addTarget(self, action: #selector(didTappedFavouriteBTN), for: .touchUpInside)
        return button
    }()
    
    lazy var quranPlayerTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(QuranPlayerTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(QuranPlayerTableViewCell.self))
        return tableView
    }()
    
    init(view: UIViewController) {
        self.view = view
        super.init(frame: .zero)
        fetchedQuran = coreDataManager.fetchQuran()
        for i in fetchedQuran {
            fetchedQuranIds.append(i.id ?? "")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reloadFetchQuranData), name: NSNotification.Name("ReloadFetchedQuranData"), object: nil)
        self.layoutUserInterFace()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUserInterFace() {
        self.addSubViews()
        self.setupBackground()
        self.setupBackBTN()
        setupFavouriteBTN()
        setupAdaihTableViewConstraints()
    }

    private func addSubViews() {
        addSubview(background)
        addSubview(backBTN)
        addSubview(favouritedBTN)
        addSubview(self.quranPlayerTableView)
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
    
    private func setupFavouriteBTN() {
        NSLayoutConstraint.activate([
            favouritedBTN.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            favouritedBTN.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            favouritedBTN.heightAnchor.constraint(equalToConstant: 25),
            favouritedBTN.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setupAdaihTableViewConstraints() {
        NSLayoutConstraint.activate([
            self.quranPlayerTableView.topAnchor.constraint(equalTo: backBTN.bottomAnchor, constant: 50),
            self.quranPlayerTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.quranPlayerTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.quranPlayerTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func didTappedBackBTN() {
//        audioPlayer?.pause()
        view.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTappedFavouriteBTN() {
//        audioPlayer?.pause()
//        view.navigationController?.popViewController(animated: true)
        let vc = FavouriteViewController()
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func reloadFetchQuranData() {

        fetchedQuran = self.coreDataManager.fetchQuran()
        fetchedQuranIds = [String]()
        for i in fetchedQuran {
            fetchedQuranIds.append(i.id ?? "")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){
//        DispatchQueue.main.async {
            self.quranPlayerTableView.reloadData()
//        }
        }
        
//        DispatchQueue.main.async {
//            if self.coreDataManager.fetchAdaih().count < 7 {
//                self.containerView.adaihTableView.tableFooterView?.isHidden = false
//            } else {
//                self.containerView.adaihTableView.tableFooterView?.isHidden = true
//            }
//            self.containerView.adaihTableView.reloadData()
//        }
        
    }
}
