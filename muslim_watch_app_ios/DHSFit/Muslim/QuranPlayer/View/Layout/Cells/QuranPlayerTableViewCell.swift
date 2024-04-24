//
//  QuranPlayerTableViewCell.swift
//  MuslimFit
//
//  Created by Karim on 26/09/2023.
//

import UIKit

class QuranPlayerTableViewCell: UITableViewCell {

    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 1
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
//    lazy var playPauseImage: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "play")
//        return imageView
//    }()
    
    lazy var duaaLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var favouriteBTN: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setImage(UIImage(named: "unfavourited"), for: .normal)
//        btn.setImage(UIImage(named: "unfavourited"), for: .normal)
        btn.addTarget(self, action: #selector(favouriteAction), for: .touchUpInside)
//        btn.backgroundColor = .yellow
//        btn.tintColor = .black
        return btn
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
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

    private func layoutUserInterFace() {
        self.addSubViews()
        self.setupContainerViewConstraints()
        setupStack()
        setupFavouriteBTN()
//        setupPlayPauseImage()
//        self.setupDuaaLabel()
    }
    
    private func addSubViews() {
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(stack)
        self.containerView.addSubview(favouriteBTN)
//        stack.addArrangedSubview(playPauseImage)
        stack.addArrangedSubview(duaaLabel)
        
//        self.containerView.addSubview(playPauseImage)
//        self.containerView.addSubview(self.duaaLabel)
    }
    
    private func setupContainerViewConstraints() {
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    private func setupStack() {
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    private func setupFavouriteBTN() {
        NSLayoutConstraint.activate([
            favouriteBTN.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            favouriteBTN.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            favouriteBTN.heightAnchor.constraint(equalToConstant: 25),
            favouriteBTN.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
//    private func setupPlayPauseImage() {
//        NSLayoutConstraint.activate([
//            playPauseImage.heightAnchor.constraint(equalToConstant: 20),
//            playPauseImage.widthAnchor.constraint(equalToConstant: 20)
//        ])
//    }

    private func setupDuaaLabel() {
        NSLayoutConstraint.activate([
            duaaLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            duaaLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    var onTapFavouriteBTN: (() -> Void)?
    
    @objc func favouriteAction() {
        onTapFavouriteBTN?()
    }
}
