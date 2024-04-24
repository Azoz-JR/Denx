//
//  HijriCalendarViewController.swift
//  MuslimFit
//
//  Created by Karim on 13/07/2023.
//

import UIKit

class HijriCalendarViewController: UIViewController {
    
    lazy var containerView: HijriCalendarContainerView = {
        let view = HijriCalendarContainerView(view: self)
        return view
    }()
    
//    var newCalendar = BSIslamicCalendar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hijri")
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
//        newCalendar?.frame(forAlignmentRect: CGRectMake(10, 50, 355, 355))
//        newCalendar?.delegate = self
//        self.view.addSubview(newCalendar)
//        newCalendar?.setIslamicDatesInArabicLocale(true)
//        newCalendar?.setShowIslamicMonth(true)
//        self.containerView.calenderView.restorationIdentifier = NSCalendar.Identifier.islamicUmmAlQura.rawValue
    }
    
    override func loadView() {
        super.loadView()
        self.view = containerView
    }
}
