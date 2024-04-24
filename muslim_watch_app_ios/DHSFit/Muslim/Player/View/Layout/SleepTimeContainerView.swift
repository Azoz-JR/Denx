//
//  SleepTimeContainerView.swift
//  MuslimFit
//
//  Created by Karim on 21/10/2023.
//

import Foundation
import UIKit

class SleepTimeContainerView: UIView {
    
    var view = UIViewController()
    let sleepTime = ["Sleep in 10 minutes", "Sleep in 15 minutes", "Sleep in 30 minutes", "Sleep in 45 minutes", "Sleep in 1 hour"]
    
    lazy var background: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "muslim_alarm_bg")
        return imageView
    }()
    
    lazy var sleepTimeTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(SleepTimeTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(SleepTimeTableViewCell.self))
        return tableView
    }()
    
//    lazy var stack: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .vertical
//        stack.spacing = 0
//        stack.alignment = .fill
//        stack.distribution = .fill
//        return stack
//    }()
    
//    lazy var
    
    init(view: UIViewController) {
        self.view = view
        
        super.init(frame: .zero)
        
        self.layoutUserInterFace()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUserInterFace() {
        self.addSubViews()
        self.setupBackground()
        setupSleepTimeTableView()
    }
    
    private func addSubViews() {
        
        addSubview(background)
        addSubview(sleepTimeTableView)
        
    }
    
    private func setupBackground() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: self.topAnchor),
            background.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupSleepTimeTableView() {
        NSLayoutConstraint.activate([
            sleepTimeTableView.topAnchor.constraint(equalTo: self.topAnchor),
            sleepTimeTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            sleepTimeTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            sleepTimeTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension SleepTimeContainerView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sleepTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SleepTimeTableViewCell.self), for: indexPath) as? SleepTimeTableViewCell else {
            return UITableViewCell()
        }
        
//        cell.duaaLabel.text = adaih[indexPath.row].title
        cell.label.text = sleepTime[indexPath.row]
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var sleep = 0
        switch indexPath.row {
        case 0:
            sleep = 10 * 60
        case 1:
            sleep = 15 * 60
        case 2:
            sleep = 30 * 60
        case 3:
            sleep = 45 * 60
        case 4:
            sleep = 60 * 60
        default:
            break
        }
        view.dismiss(animated: true) {
            DispatchQueue.global(qos: .background).async {
                let timer = Timer(timeInterval: TimeInterval(sleep), repeats: false) { _ in
                        print("After \(sleep) seconds in the background")
//                    player = nil
                    NotificationCenter.default.post(name: NSNotification.Name("sleepTime"), object: nil)
                    }
                    let runLoop = RunLoop.current
                    runLoop.add(timer, forMode: .default)
                    runLoop.run()
                }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
