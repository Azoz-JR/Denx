//
//  MuslimTableViewCell.swift
//  MuslimFit
//
//  Created by Karim on 12/07/2023.
//

import UIKit

class MuslimTableViewCell: UITableViewCell {

    lazy var containerView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var cellImageView: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .clear
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
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
        self.containerView.addSubview(self.cellImageView)
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
            self.containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 27),
            self.containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -27),
            self.containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15)
        ])
    }

    private func setupCellImageViewConstraints() {
        NSLayoutConstraint.activate([
            self.cellImageView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.cellImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.cellImageView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.cellImageView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
//            self.cellImageView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
//            self.cellImageView.heightAnchor.constraint(equalToConstant: 20),
//            self.cellImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
//        self.cellImageView.layer.cornerRadius = 10
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
