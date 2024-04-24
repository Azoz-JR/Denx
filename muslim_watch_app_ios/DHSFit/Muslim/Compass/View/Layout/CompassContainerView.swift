//
//  CompassContainerView.swift
//  MuslimFit
//
//  Created by Karim on 13/07/2023.
//

import Foundation
import UIKit

class CompassContainerView: UIView {
    
    var view = UIViewController()
    
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
    
    lazy var compassBack: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "compassBack")
//        imageView.transform = CGAffineTransform(rotationAngle: 180 - 45)
        return imageView
    }()
    
    lazy var ivCompassBack: UIImageView = {
        let imageView = UIImageView()
//        let image = makeTransparent(image: UIImage(named: "greenQibla") ?? UIImage())
        imageView.image = UIImage(named: "greenQibla")
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.transform = CGAffineTransform(rotationAngle: 180 - 45)
//        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 150
//        imageView.backgroundColor = .yellow
        return imageView
    }()
    
//    lazy var ivCompassNeedle: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "needleneedle")
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
    
    lazy var kaabaStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 5
        return stack
    }()
    
    lazy var kaabaImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "kaaba")
        return image
    }()
    
    lazy var kaabaLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You Are Facing Qibla"
        return label
    }()
    
    lazy var angleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    lazy var areaLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    init(view: UIViewController) {
        self.view = view
        super.init(frame: .zero)
//        self.backgroundColor = .white
        self.layoutUserInterFace()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutUserInterFace() {
        self.addSubViews()
        setupBackground()
        setupBackBTN()
        setupCompassBack()
        self.setupIvCompassBack()
//        self.setupIvCompassNeedle()
        setupAngleLabel()
        setupKaabaStack()
        setupAreaLabel()
    }

    private func addSubViews() {
        addSubview(background)
        addSubview(backBTN)
        addSubview(compassBack)
        addSubview(ivCompassBack)
//        addSubview(ivCompassNeedle)
        addSubview(angleLabel)
        addSubview(kaabaStack)
        kaabaStack.addArrangedSubview(kaabaImage)
        kaabaStack.addArrangedSubview(kaabaLabel)
        addSubview(areaLabel)
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
    
    private func setupCompassBack() {
        NSLayoutConstraint.activate([
            compassBack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            compassBack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            ivCompassBack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            compassBack.widthAnchor.constraint(equalToConstant: 310),
//            ivCompassBack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
            compassBack.heightAnchor.constraint(equalToConstant: 310)
        ])
    }
    
    private func setupIvCompassBack() {
        NSLayoutConstraint.activate([
            ivCompassBack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            ivCompassBack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            ivCompassBack.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
            ivCompassBack.widthAnchor.constraint(equalToConstant: 300),
//            ivCompassBack.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
            ivCompassBack.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
//    private func setupIvCompassNeedle() {
//        NSLayoutConstraint.activate([
//            ivCompassNeedle.centerXAnchor.constraint(equalTo: ivCompassBack.centerXAnchor),
//            ivCompassNeedle.centerYAnchor.constraint(equalTo: ivCompassBack.centerYAnchor),
//            ivCompassNeedle.widthAnchor.constraint(equalTo: ivCompassBack.widthAnchor, multiplier: 0.6),
//            ivCompassNeedle.heightAnchor.constraint(equalTo: ivCompassBack.heightAnchor, multiplier: 0.65)
//        ])
//    }
    
    private func setupKaabaStack() {
        NSLayoutConstraint.activate([
            kaabaStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            kaabaStack.bottomAnchor.constraint(equalTo: ivCompassBack.topAnchor, constant: -100)
        ])
    }
    
    private func setupAngleLabel() {
        NSLayoutConstraint.activate([
            angleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            angleLabel.topAnchor.constraint(equalTo: ivCompassBack.bottomAnchor, constant: 20)
            angleLabel.bottomAnchor.constraint(equalTo: ivCompassBack.topAnchor, constant: -100)
//            angleLabel.centerYAnchor.constraint(equalTo: ivCompassBack.centerYAnchor),
//            angleLabel.widthAnchor.constraint(equalTo: ivCompassBack.widthAnchor, multiplier: 0.6),
//            angleLabel.heightAnchor.constraint(equalTo: ivCompassBack.heightAnchor, multiplier: 0.65)
        ])
    }
    
    private func setupAreaLabel() {
        NSLayoutConstraint.activate([
            areaLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            areaLabel.topAnchor.constraint(equalTo: angleLabel.bottomAnchor, constant: 10)
            areaLabel.topAnchor.constraint(equalTo: ivCompassBack.bottomAnchor, constant: 10)
        ])
    }
    
    @objc func didTappedBackBTN() {
        view.navigationController?.popViewController(animated: true)
    }
    
    func makeTransparent(image: UIImage) -> UIImage? {
        guard let rawImage = image.cgImage else { return nil}
        let colorMasking: [CGFloat] = [255, 255, 255, 255, 255, 255]
        UIGraphicsBeginImageContext(image.size)
        
        if let maskedImage = rawImage.copy(maskingColorComponents: colorMasking),
            let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: 0.0, y: image.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            context.draw(maskedImage, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return finalImage
        }
        
        return nil
    }
}
