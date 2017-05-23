//
//  ATMCollectionViewFlowDelegate.swift
//  ATMCard
//
//  Created by framgia on 5/10/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit

protocol  ATMCollectionViewLayoutDelegate: class {
    func collectionViewLayout(collecitionViewLayout: ATMCollectionViewLayout, sizeForItem indexPath: IndexPath) -> CGSize

    func collectionViewLayout(colletionViewLayout: ATMCollectionViewLayout, insetForSection section: Int) -> UIEdgeInsets

    func collectionViewLayout(collectionViewLayout: ATMCollectionViewLayout, sizeForHeaderSection section: Int) -> CGSize
}

extension ATMCollectionViewLayoutDelegate {
    func collectionViewLayout(collecitionViewLayout: ATMCollectionViewLayout, sizeForItem indexPath: IndexPath) -> CGSize {
        return CGSize.zero
    }

    func collectionViewLayout(colletionViewLayout: ATMCollectionViewLayout, insetForSection section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionViewLayout(collectionViewLayout: ATMCollectionViewLayout, sizeForHeaderSection section: Int) -> CGSize {
        return CGSize.zero
    }
}


class ATMCollectionViewLayout: UICollectionViewLayout, ATMCollectionViewLayoutDelegate {

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    weak var delegate: ATMCollectionViewLayoutDelegate?

    var itemHeight: CGFloat = 40

    var scrollDirection: UICollectionViewScrollDirection = .vertical

    var contentWidth: CGFloat = 0
    var contentHeight: CGFloat = 0

    private var itemAttributesCache: Array<UICollectionViewLayoutAttributes> = []
    private var headerAttributesCache: Array<UICollectionViewLayoutAttributes> = []

    override func prepare() {
        super.prepare()
        guard itemAttributesCache.isEmpty, headerAttributesCache.isEmpty, let collectionView = collectionView else {
            return
        }

        let fixedDimension: CGFloat
        if scrollDirection == .vertical {
            fixedDimension = collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)
            contentWidth = fixedDimension
        } else {
            fixedDimension = collectionView.frame.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)
            contentHeight = fixedDimension
        }

        var additionalSectionSpacing: CGFloat = 0

        for section in 0..<collectionView.numberOfSections {
            let sizeHeaderSection = (delegate ?? self).collectionViewLayout(collectionViewLayout: self, sizeForHeaderSection: section)

            let itemCount = collectionView.numberOfItems(inSection: section)

            let sectionInset = (delegate ?? self).collectionViewLayout(colletionViewLayout: self, insetForSection: section)

            if sizeHeaderSection.width > 0 && sizeHeaderSection.height > 0 && itemCount > 0 {
                let frame: CGRect

                if scrollDirection == .vertical {
                    frame = CGRect(x: 0, y: additionalSectionSpacing, width: sizeHeaderSection.width, height: sizeHeaderSection.height)
                } else {
                    frame = CGRect(x: additionalSectionSpacing, y: 0, width: sizeHeaderSection.height, height: sizeHeaderSection.width)
                }

                let headerLayoutAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath(item: 0, section: section))
                headerLayoutAttribute.frame = frame

                headerAttributesCache.append(headerLayoutAttribute)
                additionalSectionSpacing += frame.height
            }

            if sizeHeaderSection.width > 0 && sizeHeaderSection.height > 0 {
                additionalSectionSpacing += scrollDirection == .vertical ? sectionInset.top : sectionInset.left
            }

            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)

                let itemSize = (delegate ?? self).collectionViewLayout(collecitionViewLayout: self, sizeForItem: indexPath)

                let frame: CGRect

                if scrollDirection == .vertical {
                    let widthItem = itemSize.width - (sectionInset.left + sectionInset.top)
                    frame = CGRect(x: sectionInset.left, y: additionalSectionSpacing, width: widthItem, height: itemSize.height)
                } else {
                    let heightItem = itemSize.height - (sectionInset.top + sectionInset.bottom)
                    frame = CGRect(x: additionalSectionSpacing, y:sectionInset.top , width: itemSize.width, height: heightItem)
                }


                let itemLayoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                itemLayoutAttribute.zIndex = section * 1000 + item
                itemLayoutAttribute.frame = frame
                itemAttributesCache.append(itemLayoutAttribute)

                if item == itemCount - 1 {
                    additionalSectionSpacing +=  scrollDirection == .vertical ? frame.height + sectionInset.bottom : frame.width + sectionInset.right
                } else {
                    additionalSectionSpacing += itemHeight
                }

                if scrollDirection == .vertical {
                    contentHeight = additionalSectionSpacing
                } else {
                    contentWidth = additionalSectionSpacing
                }
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let headerInRect = headerAttributesCache.filter { (header) -> Bool in
            header.frame.intersects(rect)
        }

        let itemInRect = itemAttributesCache.filter { (item) -> Bool in
            return item.frame.intersects(rect)
        }
        
        return headerInRect + itemInRect
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributesCache.first {
            return $0.indexPath == indexPath
        }
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionElementKindSectionHeader {
            return headerAttributesCache.first{ $0.indexPath == indexPath }
        }
        return nil
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if scrollDirection == .vertical, let oldWidth = collectionView?.bounds.width {
            return oldWidth != newBounds.width
        }
        if scrollDirection == .horizontal, let oldHeight = collectionView?.bounds.height {
            return oldHeight != newBounds.height
        }
        return false
    }

    override func invalidateLayout() {
        itemAttributesCache = []
        headerAttributesCache = []
        contentWidth = 0
        contentHeight = 0
    }

}
