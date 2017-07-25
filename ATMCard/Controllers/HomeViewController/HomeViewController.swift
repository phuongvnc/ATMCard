//
//  HomeViewController.swift
//  ATMCard
//
//  Created by framgia on 5/4/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit
import RealmS
import RealmSwift

class HomeViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!


    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    let modelView = HomeModelView()

    override func viewDidLoad() {
        super.viewDidLoad()
        modelView.updateData { (notification, realmS) in
            self.collectionView.reloadData()
        }
    }

    override func setupData() {
        super.setupData()

    }

    override func setupUI() {

        title = "Home"

        isLeftBarButtonHidden = true

        addLeftBarButton(image: UIImage(named: "icon_setting")!,
                         action: #selector(didSelectSetting(sender:)))

        addRightBarButton(image: UIImage(named: "icon_addcard")!,
                          action: #selector(didSelectAddCard(sender:)))
        
        let layout = ATMCollectionViewLayout()
        layout.itemHeight = 80
        layout.delegate = self
        collectionView.collectionViewLayout = layout

        let cellNib = UINib(nibName: "CardCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "Cell")

        collectionView.contentInset = modelView.collectionViewContentInset
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    func handleSwipe(gesture: UITapGestureRecognizer) {
        guard let snapShowImageView = gesture.view, let indexPath = collectionView.indexPath(for: modelView.selectCell) else {
            return
        }

        guard !collectionView.cellForItem(at: IndexPath(row: indexPath.row + 1, section: indexPath.section)).isEmpty else {
            let imageFrameToCollection = self.view.convert(snapShowImageView.frame, to: self.collectionView)
            snapShowImageView.removeFromSuperview()
            snapShowImageView.frame = imageFrameToCollection
            collectionView.insertSubview( snapShowImageView, aboveSubview: modelView.selectCell)

            UIView.animate(withDuration:  0.5, animations: {
                snapShowImageView.frame = self.modelView.selectCell.frame
                }) { (completed) in
                self.completionAnimation()
                snapShowImageView.removeFromSuperview()
            }

            return
        }

        let cellFrameToView = collectionView.convert(modelView.selectCell.frame, to: view)
        let imageFrameToCollection = self.view.convert(snapShowImageView.frame, to: self.collectionView)
        var snapshotFrame = snapShowImageView.frame
        snapshotFrame.y =  (cellFrameToView.y - cellFrameToView.height)

        var isContinue = true
        var duration = 0.5


        if imageFrameToCollection.maxY <= modelView.selectCell.frame.minY {
            snapShowImageView.removeFromSuperview()
            snapShowImageView.frame = imageFrameToCollection
            collectionView.insertSubview( snapShowImageView, aboveSubview: modelView.selectCell)
            snapshotFrame = modelView.selectCell.frame
            isContinue = false
            duration = 0.7
        }

        UIView.animate(withDuration:  duration, animations: {
            snapShowImageView.frame = snapshotFrame
        }) { (completed) in
            if !isContinue {
                self.completionAnimation()
                snapShowImageView.removeFromSuperview()
            } else {
                let snapshotFrameToCollection = self.view.convert(snapShowImageView.frame, to: self.collectionView)
                snapShowImageView.removeFromSuperview()
                snapShowImageView.frame = snapshotFrameToCollection
                self.collectionView.insertSubview( snapShowImageView, aboveSubview: self.modelView.selectCell)
                UIView.animate(withDuration:  0.5, animations: {
                    snapShowImageView.frame = self.modelView.selectCell.frame
                }) { (completed) in
                    self.completionAnimation()
                    snapShowImageView.removeFromSuperview()
                }

            }
        }

    }

    func completionAnimation() {
        modelView.selectCell.isHidden = false
        collectionView.isUserInteractionEnabled = true
        modelView.selectCell = nil
    }

    func selectCell(indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }

        modelView.selectCell = cell
        modelView.selectCell.isHidden = true

        let snapshotImageView = UIImageView(image: cell.backgroundView!
            .snapshotImage)
        snapshotImageView.frame = cell.frame
        snapshotImageView.shadow()

        let topSwipeGesture = UITapGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)) )
        snapshotImageView.addGestureRecognizer(topSwipeGesture)
        snapshotImageView.isUserInteractionEnabled = true

        collectionView.insertSubview(snapshotImageView, aboveSubview: cell)
        collectionView.isUserInteractionEnabled = false

        guard !collectionView.cellForItem(at: IndexPath(row: indexPath.row + 1, section: indexPath.section)).isEmpty else {
            let frameInView = self.collectionView.convert(snapshotImageView.frame, to: self.view)
            snapshotImageView.removeFromSuperview()
            snapshotImageView.frame = frameInView
            self.view.insertSubview(snapshotImageView, aboveSubview: self.collectionView)

            UIView.animate(withDuration:  0.5, animations: {
                snapshotImageView.center = self.view.center
            })

            return
        }

        var moveToFrame  = snapshotImageView.frame
        moveToFrame.y = moveToFrame.y - moveToFrame.height

        let frameInView = collectionView.convert(moveToFrame, to: self.view)
        let pointViewCenter = view.center

        UIView.animate(withDuration:  0.5, animations: {
            if frameInView.midY >= pointViewCenter.y {
                let pointInCollection = self.view.convert( pointViewCenter, to: self.collectionView)
                snapshotImageView.center = pointInCollection
            } else {
                snapshotImageView.frame = moveToFrame
            }
        }) { (completed) in
            let frameInView = self.collectionView.convert(snapshotImageView.frame, to: self.view)
            snapshotImageView.removeFromSuperview()
            snapshotImageView.frame = frameInView
            self.view.insertSubview(snapshotImageView, aboveSubview: self.collectionView)

            UIView.animate(withDuration:  0.5, animations: {
                snapshotImageView.center = pointViewCenter
            })
        }
    }

    //MARK: - Actions
    func didSelectSetting(sender: UIBarButtonItem) {

    }

    func didSelectAddCard(sender: UIBarButtonItem) {
        present(BaseNavigationController(rootViewController: AddCardViewController()),
                animated: true,
                completion: nil)
    }

}

extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath ) as? CardCell else {
            return UICollectionViewCell()
        }
        cell.card = modelView.cards[indexPath.row]
        cell.backgroundColor = modelView.color[indexPath.row % 9]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelView.numberOfItem()
        
    }
}

extension HomeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCell(indexPath: indexPath)
    }
}


extension HomeViewController: ATMCollectionViewLayoutDelegate {
    func collectionViewLayout(collecitionViewLayout: ATMCollectionViewLayout, sizeForItem indexPath: IndexPath) -> CGSize {
        return modelView.sizeForItem(atIndexPath: indexPath)
    }

    func collectionViewLayout(colletionViewLayout: ATMCollectionViewLayout, insetForSection section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }

    func collectionViewLayout(collectionViewLayout: ATMCollectionViewLayout, sizeForHeaderSection section: Int) -> CGSize {
        return CGSize.zero
    }
}

