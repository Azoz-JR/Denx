//
//  BodyTableViewCell.swift
//  MuslimFit
//
//  Created by Karim on 30/07/2023.
//

import UIKit

class BodyTableViewCell: UITableViewCell {

    lazy var containerView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
//        image.image = #imageLiteral(resourceName: "muslim_home_05_es")
        return image
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        self.containerView.addSubview(self.image)
//        self.containerView.addSubview(self.cellLabel)
    }

    private func layoutUserInterFace() {
        self.addSubViews()
        self.setupContainerViewConstraints()
        self.setupCellImageViewConstraints()
//        self.setupCellLabelConstraints()
    }
    
    private func setupContainerViewConstraints() {
        NSLayoutConstraint.activate([
            self.containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15)
        ])
    }

    private func setupCellImageViewConstraints() {
        
//        NSLayoutConstraint.activate([
//            self.image.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
//            self.image.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
//            self.image.topAnchor.constraint(equalTo: self.contentView.topAnchor),
//            self.image.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
//        ])
        
        NSLayoutConstraint.activate([
            self.image.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.image.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.image.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.image.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
        ])
    }

    
}
