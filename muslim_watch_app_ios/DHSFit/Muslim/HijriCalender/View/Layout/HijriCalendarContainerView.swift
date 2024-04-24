//
//  HijriCalendarContainerView.swift
//  MuslimFit
//
//  Created by Karim on 13/07/2023.
//

import Foundation
import UIKit
import FSCalendar

class HijriCalendarContainerView: UIView {
    
    var view = UIViewController()
    //    let datenow = Date()
    //    let islamic = NSCalendar(identifier:NSCalendar.Identifier(rawValue: NSCalendar.Identifier.islamicCivil.rawValue))!
    
    //    let islamic = NSCalendar(identifier: NSCalendar.Identifier.islamicCivil)
    //
    //    let components = islamic?.components(NSCalendar.Unit(rawValue: UInt.max), from: datenow)
    
    //    let islamicc = NSCalendar(identifier: NSCalendar.Identifier.islamic)
    
    //    let components = islamic.components(NSCalendarUnit(rawValue: UInt.max), fromDate: datenow as Date)
    //    let components = islamicc?.components(NSCalendar(, from: Date())
    
    lazy var hijriDay: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let islamic = NSCalendar(identifier: NSCalendar.Identifier.islamicCivil)
        let components = islamic?.components(NSCalendar.Unit(rawValue: UInt.max), from: Date())
        if LanguageManager.shareInstance().getHttpLanguageType() == "ar" {
            label.text = "\(components?.day ?? 0)".convertedDigitsToLocale(Locale(identifier: "ar"))
        } else {
            label.text = "\(components?.day ?? 0)"
        }
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 150)
        return label
    }()
    
    lazy var hijriStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .horizontal
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fill
//        stack.alignment = .fill
        stack.alignment = .center
        return stack
    }()
    
    lazy var hijriMonth: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let islamic = NSCalendar(identifier: NSCalendar.Identifier.islamicUmmAlQura)
        islamic?.locale = Locale(identifier: LanguageManager.shareInstance().getHttpLanguageType())
        let components = islamic?.components(NSCalendar.Unit(rawValue: UInt.max), from: Date())
        
//        print("components?.month \(components?.month)")
        //        label.text = "\(components?.month ?? 0)"
        label.text = getHijriMonth(month: components?.month ?? 0)
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 40)
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.5
        return label
    }()
    
    lazy var hijriYear: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let islamic = NSCalendar(identifier: NSCalendar.Identifier.islamicCivil)
        var components = islamic?.components(NSCalendar.Unit(rawValue: UInt.max), from: Date())
        
        if LanguageManager.shareInstance().getHttpLanguageType() == "ar" {
            label.text = "\(components?.year ?? 0)".convertedDigitsToLocale(Locale(identifier: "ar"))
        } else {
            label.text = "\(components?.year ?? 0)"
        }
        //        label.text = "\(components.year ?? 0)"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    
    //    lazy var calenderView: FSCalendar = {
    //        var calender = FSCalendar()
    ////        calender.formatter = DateFormatter(dateFormat: <#T##String#>, allowNaturalLanguage: <#T##Bool#>)
    ////        calender.minimumDate = Calendar(identifier: .islamic)
    ////        calender.restorationIdentifier = NSCalendar.Identifier.islamicUmmAlQura.rawValue
    //        calender.backgroundColor = .white
    //        calender.allowsMultipleSelection = false
    //        calender.layer.cornerRadius = 10
    ////        if LocalizationManager.currentLanguage().contains("ar") {
    ////            calender.locale = Locale(identifier: "en")
    //        calender.locale = Locale(identifier: "ar")
    ////        }
    //        calender.scrollEnabled = false
    //        //  calender.firstWeekday = 6
    //        calender.appearance.headerTitleColor = .black
    //        calender.appearance.headerMinimumDissolvedAlpha = 0
    //        calender.appearance.borderSelectionColor = .black
    //        calender.appearance.selectionColor = .systemBlue
    //        calender.appearance.weekdayTextColor = .black
    //        calender.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 13)
    //        calender.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 10)
    //
    //        calender.appearance.titleFont = UIFont.boldSystemFont(ofSize: 15)
    //
    //        calender.appearance.caseOptions = .headerUsesUpperCase
    ////        calender.locale = Locale(identifier: "ar_SA")
    ////        calender.identifier = NSCalendar.Identifier.islamicUmmAlQura.rawValue
    //
    //        calender.delegate = self
    //        calender.dataSource = self
    //        calender.translatesAutoresizingMaskIntoConstraints = false
    //        return calender
    //    }()
    
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
    
    //    lazy var calendar: BSIslamicCalendar = {
    //        let calendar = BSIslamicCalendar(frame: CGRect(x: 30, y: 100, width: 350, height: 300))
    ////        let calendar = BSIslamicCalendar()
    //        calendar?.backgroundColor = .yellow
    //        calendar?.delegate = self
    //        self.calendar.setIslamicDatesInArabicLocale(true)
    //        self.calendar.setShowIslamicMonth(true)
    //        return calendar ?? BSIslamicCalendar()
    //    }()
    
    lazy var calendar: BSIslamicCalendar = {
        //        let calendar = BSIslamicCalendar(frame: CGRect(x: 60, y: 200, width: 300, height: 500))
        let calendar = BSIslamicCalendar()
        calendar?.translatesAutoresizingMaskIntoConstraints = false
        calendar?.delegate = self
        calendar?.setIslamicDatesInArabicLocale(true)
        calendar?.setShowIslamicMonth(true)
        return calendar ?? BSIslamicCalendar()
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
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUserInterFace() {
        self.addSubViews()
        setupBackground()
        self.setupBackBTN()
        setupHijriDay()
        setupHijriStack()
        setupCalenderViewConstraints()
    }
    
    private func addSubViews() {
        //        addSubview(self.calenderView)
        addSubview(background)
        addSubview(backBTN)
        //        addSubview(calenderView)
        addSubview(hijriDay)
        addSubview(hijriStack)
        
        hijriStack.addArrangedSubview(hijriMonth)
        hijriStack.addArrangedSubview(hijriYear)
        addSubview(calendar)
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
    
    private func setupHijriDay() {
        NSLayoutConstraint.activate([
            hijriDay.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hijriDay.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
        ])
    }
    
    private func setupHijriStack() {
        NSLayoutConstraint.activate([
            hijriStack.topAnchor.constraint(equalTo: hijriDay.bottomAnchor, constant: 10),
            hijriStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hijriStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            hijriStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupCalenderViewConstraints() {
        //        NSLayoutConstraint.activate([
        //            self.calenderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
        //            self.calenderView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
        //            self.calenderView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
        //            self.calenderView.heightAnchor.constraint(equalToConstant: 280)
        //        ])
        
        NSLayoutConstraint.activate([
            self.calendar.topAnchor.constraint(equalTo: hijriStack.bottomAnchor, constant: 50),
            //            self.topAnchor.constraint(equalTo: self.topAnchor, constant: 200),
            //            self.calendar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            //            self.calendar.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            //            self.calendar.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.calendar.heightAnchor.constraint(equalToConstant: 500),
            self.calendar.widthAnchor.constraint(equalToConstant: 300),
            //            self.calendar.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
//            self.calendar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 55),
            self.calendar.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            
            //            self.calendar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
        //        self.calenderHeightAnchor = self.calenderView.heightAnchor.constraint(equalToConstant: 280)
        //        self.calenderHeightAnchor?.isActive = true
    }
    
    @objc func didTappedBackBTN() {
        view.navigationController?.popViewController(animated: true)
    }
    
    func getHijriMonth(month: Int) -> String {
        
        var hijriMonths: [String] = []
        
        if LanguageManager.shareInstance().getHttpLanguageType() == "ar" {
            hijriMonths = [
                "محرم",
                "صفر",
                "ربيع الأول",
                "ربيع الثاني",
                "جمادى الأولى",
                "جمادى الثانية",
                "رجب",
                "شعبان",
                "رمضان",
                "شوال",
                "ذو القعدة",
                "ذو الحجة"
            ]
        } else {
            hijriMonths = [
                "Muharram",
                "Safar",
                "Rabi al-awwal",
                "Rabi al-Thani",
                "Jumada al-awwal",
                "Jumada al-Thani",
                "Rajab",
                "Sha`ban",
                "Ramadan",
                "Shawwal",
                "Dhul Qa'dah",
                "Dhul Hijjah"
            ]
        }
        return hijriMonths[month-1]
    }
    
    func getHijriDate(date: Date) -> String {
        let islamicCalendar = Calendar(identifier: .islamicUmmAlQura)
        let components = islamicCalendar.dateComponents([.year, .month, .day], from: date)
        let hijriYear = components.year!
        let hijriMonth = components.month!
        let hijriDay = components.day!
        let hijriMonths = [
            "محرم",
            "صفر",
            "ربيع الأول",
            "ربيع الثاني",
            "جمادى الأولى",
            "جمادى الثانية",
            "رجب",
            "شعبان",
            "رمضان",
            "شوال",
            "ذو القعدة",
            "ذو الحجة"
        ]
        let hijriDateString = "\(hijriMonths[hijriMonth - 1]) \(hijriDay), \(hijriYear)"
        return hijriDateString
    }
}

extension HijriCalendarContainerView: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    //    func maximumDate(for _: FSCalendar) -> Date {
    ////        var component = DateComponents()
    //        Date()
    ////        component.year = +2
    //
    ////        var calendar = Calendar(identifier: .islamic)
    ////        return calendar.date(byAdding: <#T##DateComponents#>, to: <#T##Date#>) ?? Date()
    ////        return calendar.date(from: component) ?? Date()
    //    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        let hijriDate = getHijriDate(date: date)
        return hijriDate
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let islamicCalendar = Calendar(identifier: .islamicUmmAlQura)
        let components = islamicCalendar.dateComponents([.weekday], from: date)
        let weekdayIndex = (components.weekday! + 5) % 7 // adjust for starting day of week
        let weekdays = ["Sa", "Su", "Mo", "Tu", "We", "Th", "Fr"]
        return weekdays[weekdayIndex]
    }
    
    //    func minimumDate(for _: FSCalendar) -> Date {
    //        var component = DateComponents()
    //        var calender = Calendar(identifier: .islamic)
    //        component.year = -2
    //        return calender.date(byAdding: component, to: Date()) ?? Date()
    //    }
    //
    //    func maximumDate(for calendar: FSCalendar) -> Date {
    //        Date()
    //    }
    
    //    func calendar(_ calendar: FSCalendar, appearance _: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
    //        let calendar = Calendar(identifier: .islamic)
    //        let components = calendar.dateComponents([.weekday], from: date)
    //        let day = components.weekday
    //        if day == 6 {
    //            return .purple
    //        } else {
    //            return nil
    //        }
    //    }
    //
    //    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at _: FSCalendarMonthPosition) -> Bool {
    //        let calendar = Calendar(identifier: .islamic)
    //        let components = calendar.dateComponents([.weekday], from: date)
    //        let day = components.weekday
    //        if day == 6 {
    //            return false
    //        } else {
    //            return true
    //        }
    //    }
    //
    //    func calendar(_: FSCalendar, didSelect date: Date, at _: FSCalendarMonthPosition) {
    //        let selectedDate = date
    //        var dateComponent = DateComponents()
    //        dateComponent.day = 1
    //        let desiredDate = Calendar.current.date(byAdding: dateComponent, to: selectedDate) ?? date
    ////        self.presenter.checkAttendanceWithDate(date: desiredDate)
    //    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        // return the number of events for this date
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // handle calendar selection
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        // return the minimum date that can be selected
        return Date()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        // return the maximum date that can be selected
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        // return whether the specified date should be selectable
        return true
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        // return the default event colors for the specified date
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        // return the event colors for the specified date when it is selected
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        // return the fill color for the specified date when it is selected
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        // return the border color for the specified date when it is selected
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        // return the border radius for the specified date
        return 0.0
    }
}

extension HijriCalendarContainerView: BSIslamicCalendarDelegate {
    func islamicCalendar(_ calendar: BSIslamicCalendar!, shouldSelect date: Date!) -> Bool {
        if calendar.compare(date, with: Date()) {
            return false
        } else {
            return true
        }
    }
    
    func islamicCalendar(_ calendar: BSIslamicCalendar!, dateSelected date: Date!, withSelectionArray selectionArry: [Any]!) {
        print(selectionArry)
    }
}

extension String {
    private static let formatter = NumberFormatter()
    
    func clippingCharacters(in characterSet: CharacterSet) -> String {
        components(separatedBy: characterSet).joined()
    }
    
    func convertedDigitsToLocale(_ locale: Locale = .current) -> String {
        let digits = Set(clippingCharacters(in: CharacterSet.decimalDigits.inverted))
        guard !digits.isEmpty else { return self }
        
        Self.formatter.locale = locale
        
        let maps: [(original: String, converted: String)] = digits.map {
            let original = String($0)
            let digit = Self.formatter.number(from: original)!
            let localized = Self.formatter.string(from: digit)!
            return (original, localized)
        }
        
        return maps.reduce(self) { converted, map in
            converted.replacingOccurrences(of: map.original, with: map.converted)
        }
    }
}
