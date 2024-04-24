//
//  PrayersTableViewCell.swift
//  MuslimFit
//
//  Created by Karim on 12/07/2023.
//

import UIKit

protocol ReminderAction {
    func setReminderOn(tag: Int, prayerTime: String, toggleStatus: Bool)
}

class PrayersTableViewCell: UITableViewCell {
    
    var dateInfo1 = DateComponents()
    var dateInfo2 = DateComponents()
    var dateInfo3 = DateComponents()
    var dateInfo4 = DateComponents()
    var dateInfo5 = DateComponents()
    
    var delegate: ReminderAction?
    var toggleTapped = 0
    
    //var localNotifi = localNotification()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var timeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 2
        return stack
    }()
    
    lazy var prayerTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var toggleBTN: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.onTintColor = .yellow
        toggle.addTarget(self, action: #selector(didTappedToggle), for: .touchUpInside)
        //        toggle.tag =
        return toggle
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.layoutUserInterFace()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.timeImage)
        self.containerView.addSubview(self.horizontalStack)
        horizontalStack.addArrangedSubview(prayerTime)
        horizontalStack.addArrangedSubview(toggleBTN)
    }
    
    private func layoutUserInterFace() {
        self.addSubViews()
        self.setupContainerViewConstraints()
        self.setupTimeImage()
        setupHorizontalStack()
    }
    
    private func setupContainerViewConstraints() {
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    private func setupTimeImage() {
        NSLayoutConstraint.activate([
            timeImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            timeImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            timeImage.heightAnchor.constraint(equalToConstant: 25),
            timeImage.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setupHorizontalStack() {
        NSLayoutConstraint.activate([
            horizontalStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            horizontalStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    @objc func didTappedToggle() {
//        scheduleNotification(toggleTag: toggleBTN.tag)
//        toggleTapped+=1
        delegate?.setReminderOn(tag: toggleBTN.tag, prayerTime: prayerTime.text ?? "", toggleStatus: toggleBTN.isOn)
    }
    
    
    func scheduleNotification(toggleTag: Int) {
//        let bodies = ["Al-fajr", "Al-Dhuhr", "Al-Asr", "Al-Maghreb", "Al-Isha"]
//        let content = UNMutableNotificationContent()
//        let categoryIdentifire = "Delete Notification Type"
//        content.sound = UNNotificationSound.default
//        content.badge = 1
//        content.categoryIdentifier = categoryIdentifire
//        switch toggleTag {
//        case 0:
//
//            localNotifi.localNotifi(prayerTime: prayerTime.text ?? "")
//
//            //            dateInfo1.hour = 6
//            //            print(Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[0] ?? "") ?? 0)
//            //            print(Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[1] ?? "") ?? 0)
//            //            dateInfo1.hour = Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[0] ?? "") ?? 0
//            ////            let s = prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[0]
//            //            dateInfo1.minute = Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[1] ?? "") ?? 0
//        case 1:
//
//            localNotifi.localNotifi(prayerTime: prayerTime.text ?? "")
//
//            //            dateInfo2.hour = 8
//            //            dateInfo2.minute = 45
//            //            print(Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[0] ?? "") ?? 0)
//            //            print(Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[1] ?? "") ?? 0)
//            //            dateInfo2.hour = Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[0] ?? "") ?? 0
//            ////            let s = prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[0]
//            //            dateInfo2.minute = Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[1] ?? "") ?? 0
//        case 2:
//
//            localNotifi.localNotifi(prayerTime: prayerTime.text ?? "")
//
//            //            dateInfo3.hour = 11
//            //            dateInfo3.minute = 45
//            //            print(Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[0] ?? "") ?? 0)
//            //            print(Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[1] ?? "") ?? 0)
//            //            dateInfo3.hour = Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[0] ?? "") ?? 0
//            ////            let s = prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[0]
//            //            dateInfo3.minute = Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[1] ?? "") ?? 0
//        case 3:
//
//            localNotifi.localNotifi(prayerTime: prayerTime.text ?? "")
//
//            //            dateInfo4.hour = 14
//            //            dateInfo4.minute = 45
//            //            print(Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[0] ?? "") ?? 0)
//            //            print(Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[1] ?? "") ?? 0)
//            //            dateInfo4.hour = Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[0] ?? "") ?? 0
//            ////            let s = prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[0]
//            //            dateInfo4.minute = Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[1] ?? "") ?? 0
//        case 4:
//
//            localNotifi.localNotifi(prayerTime: prayerTime.text ?? "")
//
//            //            dateInfo5.hour = 17
//            //            dateInfo5.minute = 45
//            //            print(Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[0] ?? "") ?? 0)
//            //            print(Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[1] ?? "") ?? 0)
//            //            dateInfo5.hour = Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[0] ?? "") ?? 0
//            ////            let s = prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[0]
//            //            dateInfo5.minute = Int(prayerTime.text?.components(separatedBy: " ")[1].components(separatedBy: ":")[1] ?? "") ?? 0
//        default:
//            break
//        }
        // Compose New Notificaion
        
//        let triggers = [UNCalendarNotificationTrigger(dateMatching: dateInfo1, repeats: true), UNCalendarNotificationTrigger(dateMatching: dateInfo2, repeats: true), UNCalendarNotificationTrigger(dateMatching: dateInfo3, repeats: true), UNCalendarNotificationTrigger(dateMatching: dateInfo4, repeats: true), UNCalendarNotificationTrigger(dateMatching: dateInfo5, repeats: true)]
//
//        for x in 0 ... triggers.count - 1 {
//            content.body = bodies[x]
//            let identifier = "Local Notification\(x)"
//            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: triggers[x])
//
//            UNUserNotificationCenter.current().add(request) { error in
//                if let error = error {
//                    print("Error \(error.localizedDescription)")
//                }
//            }
//        }
        
        // Add Action button the Notification
        //        if notificationType == "Local Notification with Action" {
        //            let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        //            let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
        //            let category = UNNotificationCategory(identifier: categoryIdentifire,
        //                                                  actions: [snoozeAction, deleteAction],
        //                                                  intentIdentifiers: [],
        //                                                  options: [])
        //            UNUserNotificationCenter.current().setNotificationCategories([category])
        //        }
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

/*class localNotification {
    
    let bodies = ["Al-fajr", "Al-Dhuhr", "Al-Asr", "Al-Maghreb", "Al-Isha"]
    
    var dateInfo1 = DateComponents()
    
    let content = UNMutableNotificationContent()
    let categoryIdentifire = "Delete Notification Type"
    
    
    func localNotifi(prayerTime: String) {
        
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire
        
        dateInfo1.hour = Int(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[0]) ?? 0
        dateInfo1.minute = Int(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[1]) ?? 0
        
        let triggers = [UNCalendarNotificationTrigger(dateMatching: dateInfo1, repeats: true)]
        
        for x in 0 ... triggers.count - 1 {
            content.body = bodies[x]
            let identifier = "Local Notification\(x)"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: triggers[x])
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
}
*/
