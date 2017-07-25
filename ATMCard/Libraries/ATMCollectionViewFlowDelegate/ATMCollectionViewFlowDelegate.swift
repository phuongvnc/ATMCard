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

    //Khai báo chiều cao của thẻ
    var itemHeight: CGFloat = 40

    //Xác định hướng scroll cho collection view
    var scrollDirection: UICollectionViewScrollDirection = .vertical


    var contentWidth: CGFloat = 0
    var contentHeight: CGFloat = 0

    // Định nghĩa 1 mảng itemAttributes dùng để lưu lại các item là cell
    private var itemAttributesCache: Array<UICollectionViewLayoutAttributes> = []
    // Định nghĩa 1 mảng headerAttributes dùng để lưu lại các item là header
    private var headerAttributesCache: Array<UICollectionViewLayoutAttributes> = []

    override func prepare() {
        super.prepare()

        // Kiểm tra đã khởi tạo layout chưa, nếu có rồi thì không tính toán lại layout
        guard itemAttributesCache.isEmpty, headerAttributesCache.isEmpty, let collectionView = collectionView else {
            return
        }

        // Tính toán phần dimension theo vertical hoặc horizontal
        let fixedDimension: CGFloat
        if scrollDirection == .vertical {
            fixedDimension = collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)
            contentWidth = fixedDimension
        } else {
            fixedDimension = collectionView.frame.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)
            contentHeight = fixedDimension
        }

        //Sử dụng để lưu lại khoảng cách của các item và header
        var additionalSectionSpacing: CGFloat = 0


        for section in 0..<collectionView.numberOfSections {

            //Lấy size của header view nếu có
            let sizeHeaderSection = (delegate ?? self).collectionViewLayout(collectionViewLayout: self, sizeForHeaderSection: section)

            //Số lượng item của section
            let itemCount = collectionView.numberOfItems(inSection: section)

            //Lấy content inset của section nếu có
            let sectionInset = (delegate ?? self).collectionViewLayout(colletionViewLayout: self, insetForSection: section)

            //Kiểm tra điều kiện để tính toán layout cho header section
            if sizeHeaderSection.width > 0 && sizeHeaderSection.height > 0 && itemCount > 0 {
                let frame: CGRect
                //Tính toán frame cho header section
                if scrollDirection == .vertical {
                    frame = CGRect(x: 0, y: additionalSectionSpacing, width: sizeHeaderSection.width, height: sizeHeaderSection.height)
                } else {
                    frame = CGRect(x: additionalSectionSpacing, y: 0, width: sizeHeaderSection.height, height: sizeHeaderSection.width)
                }
                //Khởi tạo layout attrubute của header và set frame
                let headerLayoutAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath(item: 0, section: section))
                headerLayoutAttribute.frame = frame
                headerLayoutAttribute.zIndex = section * 1000
                // Đưa header vào mảng để sử dụng cho việc cache dữ liệu
                headerAttributesCache.append(headerLayoutAttribute)

                // Tính lại khoảng cách với
                additionalSectionSpacing += frame.height
            }

            //Tính lại khoảng cách với content inset của section
            if sizeHeaderSection.width > 0 && sizeHeaderSection.height > 0 {
                additionalSectionSpacing += scrollDirection == .vertical ? sectionInset.top : sectionInset.left
            }

            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                //Lấy item size của collection
                let itemSize = (delegate ?? self).collectionViewLayout(collecitionViewLayout: self, sizeForItem: indexPath)

                let frame: CGRect
                //Tính toán frame của item
                if scrollDirection == .vertical {
                    let widthItem = itemSize.width - (sectionInset.left + sectionInset.top)
                    frame = CGRect(x: sectionInset.left, y: additionalSectionSpacing, width: widthItem, height: itemSize.height)
                } else {
                    let heightItem = itemSize.height - (sectionInset.top + sectionInset.bottom)
                    frame = CGRect(x: additionalSectionSpacing, y:sectionInset.top , width: itemSize.width, height: heightItem)
                }

                //Khởi tạo layout attrubute của cell và set frame cho nó
                let itemLayoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                itemLayoutAttribute.frame = frame
                //Set zIndex để xác định thứ tự layout
                itemLayoutAttribute.zIndex = section * 1000 + item

                //Add layout vào mảng item cho việc cache
                itemAttributesCache.append(itemLayoutAttribute)

                //Tính toán lại khoảng cách
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

    //Trả về các layout atrribute sẽ được hiện thị ở trong khung
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let headerInRect = headerAttributesCache.filter { (header) -> Bool in
            //Kiểm tra frame của header có giao với khung cần hiển thị
            header.frame.intersects(rect)
        }

        let itemInRect = itemAttributesCache.filter { (item) -> Bool in
            //Kiểm tra frame của item có giao với khung cần hiển thị
            return item.frame.intersects(rect)
        }
        
        return headerInRect + itemInRect
    }

    //Trả về item layout atrribute với vị trí là indexPath
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributesCache.first {
            return $0.indexPath == indexPath
        }
    }

    //Trả về header hoặc footer layout atrribute với vị trí là indexPath
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
        super.invalidateLayout()
        itemAttributesCache = []
        headerAttributesCache = []
        contentWidth = 0
        contentHeight = 0
    }

}
