//
//  PrayersContainerView+TableView.swift
//  MuslimFit
//
//  Created by Karim on 12/07/2023.
//

import Foundation
import UIKit

extension PrayersContainerView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(PrayersTableViewCell.self), for: indexPath) as? PrayersTableViewCell else {
            return UITableViewCell()
        }
        cell.timeImage.image = UIImage(named: "mu_alarm_\(indexPath.row + 1)")
        cell.toggleBTN.tag = indexPath.row
        cell.delegate = PrayersViewController()
        
        if (UserDefaults.standard.value(forKey: "info\(indexPath.row + 1)Hour") != nil) {
            cell.toggleBTN.setOn(true, animated: true)
        } else {
            cell.toggleBTN.setOn(false, animated: true)
        }
        
        cell.toggleBTN.addTarget(self, action: #selector(alarmSwitchChange), for: .valueChanged)
        
        switch indexPath.row {
        case 0:
            cell.prayerTime.text = "Al-fajr \(today?.fajr ?? "")"
            //            cell.prayerTime.text = "Al-fajr 16:07"
        case 1:
            cell.prayerTime.text = "Al-Dhuhr \(today?.dhuhr ?? "")"
            //            cell.prayerTime.text = "Al-Dhuhr 16:08"
        case 2:
            cell.prayerTime.text = "Al-Asr \(today?.asr ?? "")"
            //            cell.prayerTime.text = "Al-Asr 15:55"
        case 3:
            cell.prayerTime.text = "Al-Maghreb \(today?.maghrib ?? "")"
            //            cell.prayerTime.text = "Al-Maghreb 15:56"
        case 4:
            cell.prayerTime.text = "Al-Isha \(today?.isha ?? "")"
            //            cell.prayerTime.text = "Al-Isha 15:57"
        default:
            break
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
