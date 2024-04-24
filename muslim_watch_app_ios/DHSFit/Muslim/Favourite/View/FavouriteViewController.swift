//
//  FavouriteViewController.swift
//  MuslimFit
//
//  Created by Karim on 16/10/2023.
//

import UIKit

class FavouriteViewController: UIViewController {

    lazy var containerView: FavouriteContainerView = {
        let view = FavouriteContainerView(view: self)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
    }

    override func loadView() {
        super.loadView()
        self.view = containerView
    }
}
