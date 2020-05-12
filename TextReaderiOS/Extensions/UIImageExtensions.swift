//
//  UIImageExtensions.swift
//  TextReaderiOS
//
//  Created by Darién on 5/8/20.
//  Copyright © 2020 Darien. All rights reserved.
//

import UIKit

extension UIImage{
    func cropImage(to rect: CGRect, container:UIView) -> UIImage? {
        let scale = container.frame.width / self.size.width
        UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.size.width / scale, height: rect.size.height / scale), true, 0.0)
        self.draw(at: CGPoint(x: -rect.origin.x / scale, y: -rect.origin.y / scale))
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage
    }
}
