//
//  PrayersContainerView.swift
//  MuslimFit
//
//  Created by Karim on 12/07/2023.
//

import Foundation
import UIKit

class PrayersContainerView: UIView {
    
    var today: Timings?
    
    let defaultsManager: UserDefaultsProtocol = UserDefaultsManager()
    
    var view = UIViewController()
    
    var alarmArray = [Int]()
    
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
        if LanguageManager.shareInstance().getHttpLanguageType() == "ar" || LanguageManager.shareInstance().getHttpLanguageType() == "ur" {
            button.transform = CGAffineTransform(rotationAngle: 180 - 45)
        }
        button.addTarget(self, action: #selector(didTappedBackBTN), for: .touchUpInside)
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Prayer time"
        return label
    }()
    
    lazy var prayersTimeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "muslim_alarm_head_1")
        return imageView
    }()
    
    lazy var prayersTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.text = "22:03:10"
        return label
    }()
    
    lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillEqually
        stack.alignment = .fill
        return stack
    }()
    
    lazy var dayHorizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    lazy var date: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "07/12"
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 999), for: .horizontal)
        return label
    }()
    
    lazy var weekday: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.backgroundColor = .clear
//        label.textAlignment = .
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "wednesday"
        return label
    }()
    
    lazy var hijriDateHorizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .equalCentering
        stack.alignment = .fill
        return stack
    }()
    
    lazy var hijriLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hijri Calender"
        label.textColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var hijriDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "1444-12-23"
        return label
    }()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    lazy var scrollContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var prayersTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(PrayersTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(PrayersTableViewCell.self))
        return tableView
    }()
    
    init(view: UIViewController) {
        self.view = view
        super.init(frame: .zero)
        
        if let prayersTimes: PrayersTimes = self.defaultsManager.valueStoreable(key: UserDefaultsKeys.prayerTimes) {
            self.today = prayersTimes.data?.timings
        }
        
        self.layoutUserInterFace()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUserInterFace() {
        self.addSubViews()
        self.setupBackground()
        self.setupBackBTN()
        self.setupTitleLabel()
        setupPrayersTimeImage()
        setupPrayersTime()
        setupVerticalStack()
        setupPrayersTableView()
    }

    private func addSubViews() {
        addSubview(background)
        addSubview(backBTN)
        addSubview(titleLabel)
        addSubview(prayersTimeImage)
        addSubview(prayersTime)
        addSubview(verticalStack)
        addSubview(prayersTableView)
        
        verticalStack.addArrangedSubview(dayHorizontalStack)
        verticalStack.addArrangedSubview(hijriDateHorizontalStack)
        
        dayHorizontalStack.addArrangedSubview(date)
        dayHorizontalStack.addArrangedSubview(weekday)
        
        hijriDateHorizontalStack.addArrangedSubview(hijriLabel)
        hijriDateHorizontalStack.addArrangedSubview(hijriDate)
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
    
    private func setupTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: backBTN.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func setupPrayersTimeImage() {
        NSLayoutConstraint.activate([
            prayersTimeImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13),
            prayersTimeImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            prayersTimeImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            prayersTimeImage.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func setupPrayersTime() {
        NSLayoutConstraint.activate([
            prayersTime.topAnchor.constraint(equalTo: prayersTimeImage.topAnchor, constant: 20),
            prayersTime.centerXAnchor.constraint(equalTo: prayersTimeImage.centerXAnchor)
        ])
    }
    
    private func setupVerticalStack() {
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: prayersTimeImage.bottomAnchor, constant: 13),
            verticalStack.leadingAnchor.constraint(equalTo: prayersTimeImage.leadingAnchor)
        ])
    }
    
    private func setupPrayersTableView() {
        NSLayoutConstraint.activate([
            prayersTableView.topAnchor.constraint(equalTo: verticalStack.bottomAnchor, constant: 25),
            prayersTableView.leadingAnchor.constraint(equalTo: prayersTimeImage.leadingAnchor),
            prayersTableView.trailingAnchor.constraint(equalTo: prayersTimeImage.trailingAnchor),
            prayersTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupScroll() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.verticalStack.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    private func setupScrollContainerView() {
        NSLayoutConstraint.activate([
            scrollContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContainerView.widthAnchor.constraint(equalTo: self.widthAnchor),
            scrollContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
    }
    
    @objc func didTappedBackBTN() {
        view.navigationController?.popViewController(animated: true)
    }
    
    var onTapSwitch: ((_ sender: UISwitch) -> Void)?
    
    @objc func alarmSwitchChange(sender:UISwitch!) {
//        let sectionIndex:Int = sender.tag
//        let tAlarmModel:PrayAlarmSetModel! = self.alarmArray[sectionIndex]
//        tAlarmModel.isOpen = sender.isOn

        onTapSwitch?(sender)
//        alarmArray.append(sender.tag)
        
//        self.calculateRecentAlarmClock()
//        self.sendAlarmToDev()
    }
    
//    @objc class Constant: NSObject {
//        private override init() {}
//
//        class func parseApplicationId() -> String { return today?.fajr ?? "" }
////        class func parseClientKey() -> String { return ParseClientKey }
////        class func appGreenColor() -> UIColor { return AppGreenColor }
//    }
}
