//
//  TableViewCell.swift
//  InspirationApp
//
//  Created by Илья Козлов on 10/2/20.
//  Copyright © 2020 Илья Козлов. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    public var saveBlock:  (() -> ())?
    //MARK: Properties
    private var heightConstraint: NSLayoutConstraint? {
        didSet {
            if let oldValue = oldValue {
                photoImageView.removeConstraint(oldValue)
            }
            if let aspectConstraint = heightConstraint {
                aspectConstraint.priority = .init(rawValue: 999)
                aspectConstraint.isActive = true
            }
        }
    }
    
    
    var post: AdvancedPhotoModel? {
        didSet {
            authorLabel.text = post?.user.name
            photoImageView.image = post?.image
            photoImageView.sizeToFit()
        }
    }
    
     let authorLabel: UILabel = {
        let lbl = UILabel()        
        return lbl
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(named: "favorites"), for: UIControl.State.normal)
        return button
    }()
    lazy var photoImageView: UIImageView =  {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = ContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill

        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return stackView
    }()
    //MARK: ConfigureCell
    func configureCell(model: AdvancedPhotoModel) -> (){
        post = model
        authorLabel.text = model.user.name
        photoImageView.image = (model.image != nil) ? model.image : UIImage(named: "placeholder")
     

        
        var ratio = 1.0
        if let image = model.image {
            ratio = Double(image.size.height/image.size.width)
        }

        heightConstraint = photoImageView.heightAnchor.constraint(equalTo: photoImageView.widthAnchor, multiplier: CGFloat(ratio))

    }
    
    @objc func configureSaveButton () -> () {
        favoriteButton.addTarget(self, action: #selector(saveToCoreData), for: UIControl.Event.touchUpInside)
    }
    
    @objc private func saveToCoreData () -> () {
        if (self.saveBlock != nil) {
            self.saveBlock!()
        }
    }
    
//MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(self.authorLabel)
        verticalStackView.addArrangedSubview(self.photoImageView)
        verticalStackView.addArrangedSubview(self.favoriteButton)

        
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])

        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        authorLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

        favoriteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
 

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
