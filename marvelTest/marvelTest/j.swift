//
//  CharacterCell.swift
//  marvelTest
//
//  Created by Hümeyra Turan on 30.11.2023.
//

import Foundation

import UIKit

class CharacterCell: UITableViewCell {
    // Karakterin adını göstermek için bir label
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Diğer karakter özelliklerini burada ekleyebilirsiniz

    // Hücre oluşturucu (constructor) method
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Label'ı hücreye ekleme ve düzenleme işlemleri burada yapılabilir
        addSubview(nameLabel)

        // Label'ın konumlandırılması için constraint'ler ekleyebilirsiniz
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])

        // Diğer karakter özelliklerini de burada ekleyebilirsiniz
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
