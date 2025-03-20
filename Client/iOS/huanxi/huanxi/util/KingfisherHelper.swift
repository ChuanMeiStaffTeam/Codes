//
//  KingfisherHelper.swift
//  huanxi
//
//  Created by rslz on 2025/3/19.
//

import Foundation
import UIKit
import Kingfisher

@objc class KingfisherHelper: NSObject {
    @objc static func setImage(for imageView: UIImageView, with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        imageView.kf.setImage(with: url)
    }
    
    @objc static func setImage(for imageView: UIImageView, with urlString: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: urlString) else { return }
        imageView.kf.setImage(with: url, placeholder: placeholder)
    }
}
