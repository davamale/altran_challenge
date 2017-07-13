//
//  GnomeCell.swift
//  altran_challenge
//
//  Created by Dava on 7/11/17.
//
//

import UIKit
import STXImageCache

class GnomeCell: UITableViewCell {

    @IBOutlet weak var gnomeImageView: UIImageView!
    @IBOutlet weak var gnomeNameLabel: UILabel!
    @IBOutlet weak var gnomeFriendsImageView: UIImageView!
    @IBOutlet weak var gnomeProfessionLabel: UILabel!
    @IBOutlet weak var hasFriendsTextLabel: UILabel!
    @IBOutlet weak var professionsTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
}

extension GnomeCell: CellProtocol {
    func configure<Entity>(withEntity entity: Entity) -> Self {
        
        guard let gnome = entity as? Gnome else {
            return self
        }
        
        // name
        gnomeNameLabel.text = gnome.name
        
        // friends
        gnomeFriendsImageView.image = gnome.hasFriends ? UIImage.happyFace : UIImage.sadFace
        
        // image
        if let pictureUrl = gnome.pictureUrl {
            
            //FIXME: uncomment this line to use my implementation. It's buggy.
//            gnomeImageView.loadImage(from: pictureUrl)
            
            // library implementation
            gnomeImageView.stx.image(atURL: URL(string: pictureUrl)!)
        }
        
        // professions label
        gnomeProfessionLabel.textColor = gnome.hasProfessions ? .defaultBlue : .defaultRed
        gnomeProfessionLabel.text = "\(gnome.professionCount)"
        
        return self
    }
}

extension GnomeCell: Customizable {
    func prepareUI() {
        hasFriendsTextLabel.textColor = .defaultDarkGray
        professionsTextLabel.textColor = .defaultDarkGray
    }
}



