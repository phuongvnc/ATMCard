//
//  UIImageExtension.swift
//  Blank Project
//
//  Created by framgia on 5/22/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

import CoreGraphics

extension UIImage {

    func getMainColor() -> UIColor {
        var maxRepeatedColor = UIColor.lightGray

        let image = self.resizeImage(CGSize(width: 2, height: 2))

        let cgImage = image.cgImage!
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let bitsPerComponent = 8

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let raw = malloc(bytesPerRow * height)

        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue

        if let ctx = CGContext.init(data: raw, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) {

            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))

            let data = ctx.data?.assumingMemoryBound(to: UInt8.self)

            let imageColors = NSCountedSet(capacity: width * height)

            for x in 0..<width {
                for y in 0..<height  {
                    let pixel = ((width * y) + x) * bytesPerPixel

                    let color = UIColor(red: CGFloat(data![pixel + 1])/255,
                                        green: CGFloat(data![pixel + 2])/255,
                                        blue: CGFloat(data![pixel + 3])/255,
                                        alpha: 1)

                    var isDistinct = false

                    for colr in imageColors {
                        if color.isDistinct(compare: (colr as! UIColor)) {
                            imageColors.add(colr)
                            isDistinct = true
                            break
                        }
                    }

                    if !isDistinct {
                        imageColors.add(color)
                    }
                }
            }

            var maxRepeated = 0

            for c in imageColors.allObjects {
                let repeatCount = imageColors.count(for: c)

                if repeatCount > maxRepeated {
                    maxRepeated = repeatCount
                    maxRepeatedColor = c as! UIColor
                }
            }

        }
        return maxRepeatedColor
    }

    func resizeImage(_ size: CGSize) -> UIImage {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizeImage!
    }
    

}

