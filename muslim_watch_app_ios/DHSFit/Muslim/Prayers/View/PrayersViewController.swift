//
//  PrayersViewController.swift
//  MuslimFit
//
//  Created by Karim on 12/07/2023.
//

import Foundation
import UIKit

class PrayAlarmSetModell: DHBaseModel {
    var userId:String
    var macAddr:String
    var alarmType:Int
    var isOpen:Bool
    var hour:Int
    var minute:Int
    
    override init() {
        
        self.userId = ConfigureModel.shareInstance().userId
        self.macAddr = ConfigureModel.shareInstance().macAddr
        self.alarmType = 0
        self.isOpen = true
        self.hour = Calendar.current.component(.hour, from: Date())
        self.minute = Calendar.current.component(.minute, from: Date())
        
        super.init()
        //        if (self != nil) {
        //        }
        //        return self
    }
    
        class func queryAllPrayAlarms() -> [PrayAlarmSetModell] {
            
            let alarms = PrayAlarmSetModell.find(byCriteria: "WHERE macAddr = \(ConfigureModel.shareInstance().macAddr) ORDER BY alarmType ASC") as? [PrayAlarmSetModell] ?? [PrayAlarmSetModell]()
            
//            let alarms = [PrayAlarmSetModell.findCount(withCriteria: "WHERE macAddr = '%@' ORDER BY alarmType ASC")
            
//            let alarms: [Array] = PrayAlarmSetModell.findWithFormat("WHERE macAddr = '%@' ORDER BY alarmType ASC", DHMacAddr)
            return alarms
        }
    
    //    class func deleteAllPrayAlarms() {
    //        let array:[AnyObject]! = PrayAlarmSetModell.queryAllPrayAlarms()
    //        if array.count {
    //            PrayAlarmSetModell.deleteObjects(array)
    //        }
    //    }
    
    class func getTableName() -> String! {
        return "t_device_prayalarm"
    }
}

class PrayersViewController: UIViewController {
    
    let muslimWorker: MuslimWorkerProtocol = MuslimWorker()
    var localTimeZoneIdentifier: String {
        return TimeZone.current.identifier
    }
    
    var dates = [Date]()
    
    //    var alarmCountDownNum: Int?
    var alarmHeadImageArr = [String]()
    //    var alarmArray = [Int]()
    var alarmCountDownTimer: Timer?
    var _alarmCountDownNum = 0
    var alarmCountDownNum:Int {
        get { return _alarmCountDownNum }
        set { _alarmCountDownNum = newValue }
    }
    var alarmArray: [PrayAlarmSetModell] = []
    
    
    var dateInfo1 = DateComponents()
    var dateInfo2 = DateComponents()
    var dateInfo3 = DateComponents()
    var dateInfo4 = DateComponents()
    var dateInfo5 = DateComponents()
    
    var triggers = [UNCalendarNotificationTrigger]()
    
    //    let triggerss = [UNCalendarNotificationTrigger(dateMatching: dateInfo1, repeats: true), UNCalendarNotificationTrigger(dateMatching: dateInfo2, repeats: true), UNCalendarNotificationTrigger(dateMatching: dateInfo3, repeats: true), UNCalendarNotificationTrigger(dateMatching: dateInfo4, repeats: true), UNCalendarNotificationTrigger(dateMatching: dateInfo5, repeats: true)]
    
    let bodies = ["Al-fajr", "Al-Dhuhr", "Al-Asr", "Al-Maghreb", "Al-Isha"]
    
    let content = UNMutableNotificationContent()
    let categoryIdentifire = "Delete Notification Type"
    
    lazy var containerView: PrayersContainerView = {
        var view = PrayersContainerView(view: self)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire
        
        self.alarmHeadImageArr = ["muslim_alarm_head_1", "muslim_alarm_head_2", "muslim_alarm_head_3", "muslim_alarm_head_4", "muslim_alarm_head_5"]
        
        self.alarmCountDownNum = 0
        
        getPrayAlarms()
        
//        containerView.onTapSwitch =
        
        containerView.onTapSwitch = { sender in
            let sectionIndex:Int = sender.tag
            let tAlarmModel:PrayAlarmSetModell! = self.alarmArray[sectionIndex]
            tAlarmModel.isOpen = sender.isOn
            self.calculateRecentAlarmClock()
            //            self.sendAlarmToDev()
        }
        
        //        let tDateF:DateFormatter! = DateFormatter()
        //        tDateF.dateFormat = "MM/dd EEEE"
        //        self.alarmWeekLb.text = tDateF.stringFromDate(Date())
        //        let tIslamicCalendar:NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.islamic)
        //        let tIslamicDateComp: Int = tIslamicCalendar.component([.year, .month, .day, .weekday], from: Date())//.components(NSCalendarUnitYear|NSCalendarUnitMonth)|NSCalendarUnitDay|NSCalendarUnitWeekday, fromDate:Date())
        
        self.calculateRecentAlarmClock()
        
        //        getPrayersTime(zone: localTimeZoneIdentifier.components(separatedBy: "/")[1])
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timerClean()
    }
    
    func getPrayAlarms() {
//        self.alarmArray =
        let array = PrayAlarmSetModell.queryAllPrayAlarms()
        if (array.count != 0) {
            alarmArray.append(contentsOf: array)
        }
        else{
            //保存5个关闭的闹钟
            for i in 0...5 {
                let alarmModel:PrayAlarmSetModell! = PrayAlarmSetModell()

                alarmModel.isOpen = false
                alarmModel.hour = 0
                alarmModel.minute = 0
                alarmModel.alarmType = i
//                self.alarmArray.addObject(alarmModel)
                self.alarmArray.append(alarmModel)
             }

            PrayAlarmSetModell.save(alarmArray)
        }

        self.containerView.prayersTableView.reloadData()
    }
    
//    func saveModel(data:AnyObject!) {
//        PrayAlarmSetModell.deleteAllPrayAlarms()
//        let alarms:[AnyObject]! = data
//        self.alarmArray = NSMutableArray.array()
//        if alarms.count {
//            for var i:Int=0 ; i < alarms.count ; i++ {
//                let model:DHPrayAlarmSetModell! = alarms[i]
//                let alarmModel:PrayAlarmSetModell! = PrayAlarmSetModell()
//
//                alarmModel.isOpen = model.isOpen
//                alarmModel.hour = model.hour
//                alarmModel.minute = model.minute
//                alarmModel.alarmType = model.alarmType
//                self.alarmArray.addObject(alarmModel)
//             }
//            PrayAlarmSetModell.saveObjects(self.alarmArray)
//        }
//
//    }
    
    @objc func calculateRecentAlarmClock() {
        let tCalendar: Calendar! = Calendar.current
        let tDateComp = tCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        //        let tDateComp = tCalendar.components(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond, fromDate:NSDate.date())
        
        var tMinAlarm:PrayAlarmSetModell! = nil
        var tAlarmCountMin:Int = 999999
        var tAlarmMinIndex:Int = 0
        let tAlarmDateArr:NSMutableArray! = NSMutableArray(capacity: 0)
        //        NSLog("self.alarmArray.count count %d", self.alarmArray.count)
        
        for i in 0..<containerView.alarmArray.count {
            //            let model:PrayAlarmSetModell! = self.alarmArray[i]
            //            tDateComp.hour = model.hour
            //            tDateComp.minute = model.minute
            let tAlarmdate = tCalendar.date(from: tDateComp)
            var tAlarmDateTimeInterval: Double! = tAlarmdate?.timeIntervalSince1970
            if tAlarmDateTimeInterval <= Date().timeIntervalSince1970 {
                tAlarmDateTimeInterval = tAlarmDateTimeInterval + 24*3600
                tAlarmDateArr.add(tAlarmDateTimeInterval ?? 0.0)
            }
            else{
                tAlarmDateArr.add(tAlarmDateTimeInterval ?? 0.0)
            }
            
            //            if model.isOpen {
            if Int(tAlarmDateTimeInterval - Date().timeIntervalSince1970) < tAlarmCountMin {
                
                tAlarmMinIndex = i
                tAlarmCountMin = Int((tAlarmDateTimeInterval - Date().timeIntervalSince1970))
                //                    tMinAlarm = model
            }
            //            }
        }
        
        if !containerView.alarmArray.isEmpty {
            NSLog("tAlarmMinIndex %d", tAlarmMinIndex)
            self.alarmCountDownNum = tAlarmCountMin
            self.containerView.prayersTimeImage.image = UIImage(named: self.alarmHeadImageArr[tAlarmMinIndex%5])
            self.timerStart()
        }
        else{
            self.timerClean()
            self.alarmCountDownNum = 0
            self.containerView.prayersTime.text = "00:00:00"
            self.containerView.prayersTimeImage.image = UIImage(named: "muslim_alarm_head_1")
        }
    }
    
    func timerStart() {
        if (self.alarmCountDownTimer != nil) {
            self.alarmCountDownTimer?.invalidate()
            self.alarmCountDownTimer = nil
        }
        self.alarmCountDownTimer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector:Selector("timerOut:"), userInfo:nil, repeats:true)
    }
    
    func timerOut(timer: Timer) {
        _alarmCountDownNum -= 1
        self.containerView.prayersTime.text = String(format:"%02ld:%02ld:%02ld", _alarmCountDownNum/3600, (_alarmCountDownNum/60)%60, _alarmCountDownNum%60)
        if _alarmCountDownNum == 0 { //闹钟到时
            self.timerClean()
            
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            //            self.testAlertView()
            
            //            self.perform(#selector(calculateRecentAlarmClock), with:nil, afterDelay:1.0)
            //            self.perform(calculateRecentAlarmClock(), with: nil, afterDelay: 1.0)
            self.perform(#selector(calculateRecentAlarmClock), with: nil, afterDelay: 1.0)
        }
        
    }
    
    func timerClean() {
        if (self.alarmCountDownTimer != nil) {
            self.alarmCountDownTimer?.invalidate()
            self.alarmCountDownTimer = nil
//            self.alarmCountDownTimer.invalidate()
        }
    }
    
    override func loadView() {
        super.loadView()
        self.view = containerView
    }
    
    func getPrayersTime(zone: String) {
//        muslimWorker.prayerTimes(zone) { result in
//            switch result {
//            case let .success(responseModel):
//                //                self.containerView.today = responseModel?.today
//                self.containerView.prayersTableView.reloadData()
//            case let .failure(error):
//                print(error)
//            }
//        }
    }
}

extension PrayersViewController: ReminderAction {
    func setReminderOn(tag: Int, prayerTime: String, toggleStatus: Bool) {
        
        switch tag {
        case 0:
            dateInfo1.hour = Int(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[0]) ?? 0
            dateInfo1.minute = Int(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[1]) ?? 0
            
            if toggleStatus {
                
                print(prayerTime.components(separatedBy: " ")[1].toDate())
                
                dates.append(prayerTime.components(separatedBy: " ")[1].toDate() ?? Date())
                
                UserDefaults.standard.set(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[0], forKey: "info1Hour")
                UserDefaults.standard.set(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[1], forKey: "info1Minute")
            } else {
                
                dates.removeAll { x in
                    x == prayerTime.components(separatedBy: " ")[1].toDate() ?? Date()
                }
                
                UserDefaults.standard.removeObject(forKey: "info1Hour")
                UserDefaults.standard.removeObject(forKey: "info1Minute")
            }
            
            //            triggers.append(UNCalendarNotificationTrigger(dateMatching: dateInfo1, repeats: true))
        case 1:
            dateInfo2.hour = Int(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[0]) ?? 0
            dateInfo2.minute = Int(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[1]) ?? 0
            
            if toggleStatus {
                
                dates.append(prayerTime.components(separatedBy: " ")[1].toDate() ?? Date())
                
                UserDefaults.standard.set(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[0], forKey: "info2Hour")
                UserDefaults.standard.set(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[1], forKey: "info2Minute")
            } else {
                
                dates.removeAll { x in
                    x == prayerTime.components(separatedBy: " ")[1].toDate() ?? Date()
                }
                
                UserDefaults.standard.removeObject(forKey: "info2Hour")
                UserDefaults.standard.removeObject(forKey: "info2Minute")
            }
            
            //            triggers.append(UNCalendarNotificationTrigger(dateMatching: dateInfo2, repeats: true))
        case 2:
            dateInfo3.hour = Int(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[0]) ?? 0
            dateInfo3.minute = Int(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[1]) ?? 0
            
            if toggleStatus {
                
                print(prayerTime.components(separatedBy: " ")[1].toDate())
                
                dates.append(prayerTime.components(separatedBy: " ")[1].toDate() ?? Date())
                
                UserDefaults.standard.set(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[0], forKey: "info3Hour")
                UserDefaults.standard.set(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[1], forKey: "info3Minute")
            } else {
                
                dates.removeAll { x in
                    x == prayerTime.components(separatedBy: " ")[1].toDate() ?? Date()
                }
                
                UserDefaults.standard.removeObject(forKey: "info3Hour")
                UserDefaults.standard.removeObject(forKey: "info3Minute")
            }
            
            //            triggers.append(UNCalendarNotificationTrigger(dateMatching: dateInfo3, repeats: true))
        case 3:
            dateInfo4.hour = Int(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[0]) ?? 0
            dateInfo4.minute = Int(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[1]) ?? 0
            
            if toggleStatus {
                
                dates.append(prayerTime.components(separatedBy: " ")[1].toDate() ?? Date())
                
                UserDefaults.standard.set(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[0], forKey: "info4Hour")
                UserDefaults.standard.set(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[1], forKey: "info4Minute")
            } else {
                
                dates.removeAll { x in
                    x == prayerTime.components(separatedBy: " ")[1].toDate() ?? Date()
                }
                
                UserDefaults.standard.removeObject(forKey: "info4Hour")
                UserDefaults.standard.removeObject(forKey: "info4Minute")
            }
            
            //            triggers.append(UNCalendarNotificationTrigger(dateMatching: dateInfo4, repeats: true))
        case 4:
            dateInfo5.hour = Int(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[0]) ?? 0
            dateInfo5.minute = Int(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[1]) ?? 0
            
            if toggleStatus {
                
                print(prayerTime.components(separatedBy: " ")[1])
                print(prayerTime.components(separatedBy: " ")[1].toDate())
                
                dates.append(prayerTime.components(separatedBy: " ")[1].toDate() ?? Date())
                
                UserDefaults.standard.set(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[0], forKey: "info5Hour")
                UserDefaults.standard.set(prayerTime.components(separatedBy: " ")[1].components(separatedBy: ":")[1], forKey: "info5Minute")
            } else {
                
                dates.removeAll { x in
                    x == prayerTime.components(separatedBy: " ")[1].toDate() ?? Date()
                }
                
                UserDefaults.standard.removeObject(forKey: "info5Hour")
                UserDefaults.standard.removeObject(forKey: "info5Minute")
            }
            
            //            triggers.append(UNCalendarNotificationTrigger(dateMatching: dateInfo5, repeats: true))
        default:
            break
        }
        
        //        let cal = Calendar.current
        //        let nowComponents = cal.dateComponents([Calendar.Component.hour, Calendar.Component.minute], from: Date())
        //        let nowMinsIntoDay = (nowComponents.hour ?? 0) * 60 + (nowComponents.minute ?? 0)
        //        // Create a new list of tuples including the date and the minutes from now
        //        let datesWithMinsFromNow = dates.map { (date) -> (Date, Int) in
        //            let comp = cal.dateComponents([Calendar.Component.hour, Calendar.Component.minute], from: date)
        //            let minsFromNow = (comp.hour ?? 0) * 60 + (comp.minute ?? 0) - nowMinsIntoDay
        //            return (date, minsFromNow)
        //        }
        //        // Filter out any pairs that are earlier in the day than now
        //        let datesLaterThanNow = datesWithMinsFromNow.filter { return $0.1 >= 0 }
        //        // Sort the remaining items
        //        let sortedDates = datesLaterThanNow.sorted { $0.1 < $1.1 }
        //        // Take the first item
        //        let closest = sortedDates.first?.0
        
        //        switch tag {
        //        case 0:
        //            if closest == prayerTime.components(separatedBy: " ")[1].toDate() ?? Date() {
        //                self.containerView.prayersTimeImage.image = UIImage(named: "muslim_alarm_head_1")
        //            }
        //        case 1:
        //            if closest == prayerTime.components(separatedBy: " ")[1].toDate() ?? Date() {
        //                self.containerView.prayersTimeImage.image = UIImage(named: "muslim_alarm_head_2")
        //            }
        //        case 2:
        //            if closest == prayerTime.components(separatedBy: " ")[1].toDate() ?? Date() {
        //                self.containerView.prayersTimeImage.image = UIImage(named: "muslim_alarm_head_3")
        //            }
        //        case 3:
        //            if closest == prayerTime.components(separatedBy: " ")[1].toDate() ?? Date() {
        //                self.containerView.prayersTimeImage.image = UIImage(named: "muslim_alarm_head_4")
        //            }
        //        case 4:
        //            print(closest)
        //            print(prayerTime.components(separatedBy: " ")[1].toDate())
        //            if closest == prayerTime.components(separatedBy: " ")[1].toDate() ?? Date() {
        //                DispatchQueue.main.async {
        //                    self.containerView.prayersTimeImage.image = UIImage(named: "muslim_alarm_head_5")
        //                }
        //            }
        //        default:
        //            break
        //        }
        
        //        triggers = UNCalendarNotificationTrigger(dateMatching: <#T##DateComponents#>, repeats: <#T##Bool#>)
        
        print(dateInfo1)
        print(dateInfo2)
        
        triggers = [UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: UserDefaults.standard.integer(forKey: "info1Hour"), minute: UserDefaults.standard.integer(forKey: "info1Minute")), repeats: true), UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: UserDefaults.standard.integer(forKey: "info2Hour"), minute: UserDefaults.standard.integer(forKey: "info2Minute")), repeats: true), UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: UserDefaults.standard.integer(forKey: "info3Hour"), minute: UserDefaults.standard.integer(forKey: "info3Minute")), repeats: true), UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: UserDefaults.standard.integer(forKey: "info4Hour"), minute: UserDefaults.standard.integer(forKey: "info4Minute")), repeats: true), UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: UserDefaults.standard.integer(forKey: "info5Hour"), minute: UserDefaults.standard.integer(forKey: "info5Minute")), repeats: true)]
        
        
        //        let triggers = [UNCalendarNotificationTrigger(dateMatching: dateInfo1, repeats: true), UNCalendarNotificationTrigger(dateMatching: dateInfo2, repeats: true), UNCalendarNotificationTrigger(dateMatching: dateInfo3, repeats: true), UNCalendarNotificationTrigger(dateMatching: dateInfo4, repeats: true), UNCalendarNotificationTrigger(dateMatching: dateInfo5, repeats: true)]
        
        
        
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

enum UserDefaultsKeys: String, UserDefaultsKeysProtocol {
    case prayerTimes
    case adaih
    case hesnElmoslem
}

protocol UserDefaultsKeysProtocol {
    var rawValue: String { get }
}

protocol Storeable {
    var storeData: Data? { get }
    
    init?(storeData: Data?)
}

protocol UserDefaultsProtocol: AnyObject {
    func value<T>(key: UserDefaultsKeysProtocol) -> T?
    func write<T>(key: UserDefaultsKeysProtocol, value: T?)
    func remove(key: UserDefaultsKeysProtocol)
    
    func valueStoreable<T>(key: UserDefaultsKeysProtocol) -> T? where T: Storeable
    func writeStoreable<T>(key: UserDefaultsKeysProtocol, value: T?) where T: Storeable
    func wipe()
}

class UserDefaultsManager: UserDefaultsProtocol {
    fileprivate let userDefaults = UserDefaults.standard
    
    func value<T>(key: UserDefaultsKeysProtocol) -> T? {
        self.userDefaults.object(forKey: key.rawValue) as? T
    }
    
    func write<T>(key: UserDefaultsKeysProtocol, value: T?) {
        self.userDefaults.set(value, forKey: key.rawValue)
    }
    
    func remove(key: UserDefaultsKeysProtocol) {
        self.userDefaults.set(nil, forKey: key.rawValue)
    }
    
    func valueStoreable<T>(key: UserDefaultsKeysProtocol) -> T? where T: Storeable {
        let data: Data? = self.userDefaults.data(forKey: key.rawValue)
        return T(storeData: data)
    }
    
    func writeStoreable<T>(key: UserDefaultsKeysProtocol, value: T?) where T: Storeable {
        self.userDefaults.set(value?.storeData, forKey: key.rawValue)
    }
    
    func wipe() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
}

extension String {
    // MARK: - Convert from string
    
    func toDate(locale: Locale = Locale.current) -> Date? {
        let formatter = DateFormatter()
        //        formatter.dateStyle = .none
        //        formatter.timeStyle = .short
        //        formatter.dateFormat = "HH:mm"
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        //        formatter.timeZone = TimeZone.current
        formatter.locale = locale
        return formatter.date(from: self)
        //        return removeTimeStamp(fromDate: formatter.date(from: self) ?? Date())
    }
    
    //    func toDate(timeFormat: String, dateFromat: Date, defaultDate: Date = Date(), timeZone: Date, locale: Locale = Locale.current) -> Date? {
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = "HH:mm"
    ////        formatter.timeZone = timeZone.timezo
    //        formatter.locale = locale
    //
    //        var calendar = Calendar.current
    ////        if let timeZone = timeZone.timeZone {
    ////            calendar.timeZone = timeZone
    ////        }
    //
    //        guard let timeDate: Date = formatter.date(from: self),
    //              let hour: Int = timeDate.component(.hour, timeZone: timeZone), let minute: Int = timeDate.component(.minute, timeZone: timeZone),
    //              let date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: defaultDate)
    //        else {
    //            return nil
    //        }
    //
    //        if let dateFromat = dateFromat {
    //            formatter.dateFormat = dateFromat.stringFormat
    //            let newDateString = formatter.string(from: defaultDate)
    //            return formatter.date(from: newDateString)
    //        }
    //        return date
    //    }
}

public func removeTimeStamp(fromDate: Date) -> Date {
    guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.hour, .minute], from: fromDate)) else {
        fatalError("Failed to strip time from Date object")
    }
    return date
}
