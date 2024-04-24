//
//  SleepTimeViewController.swift
//  MuslimFit
//
//  Created by Karim on 21/10/2023.
//

import UIKit

class SleepTimeViewController: UIViewController {

    lazy var containerView: SleepTimeContainerView = {
        let view = SleepTimeContainerView(view: self)
            return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        super.loadView()
        self.view = containerView
    }
}
