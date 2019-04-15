//
//  SpotPhotosCollectionViewCell.swift


import UIKit

class SpotPhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    var photo: Photo! {
        didSet{
            photoImageView.image = photo.image
        }
    }
}
