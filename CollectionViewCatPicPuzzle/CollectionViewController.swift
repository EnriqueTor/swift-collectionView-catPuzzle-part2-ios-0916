//
//  PuzzleCollectionViewController.swift
//  CollectionViewCatPicPuzzle
//
//  Created by Joel Bell on 10/5/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import GameplayKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var headerReusableView: HeaderReusableView!
    var footerReusableView: FooterReusableView!
    
    var sectionInsets: UIEdgeInsets!
    var spacing: CGFloat!
    var itemSize: CGSize!
    var referenceSize: CGSize!
    var numberOfRows: CGFloat!
    var numberOfColumns: CGFloat!
    
    var imageSlices = [UIImage]()
    var solvedGame = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        fillImageSlices()
        shuffle()
        
        self.collectionView?.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        self.collectionView?.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSlices.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "puzzleCell", for: indexPath) as! CollectionViewCell
        
        let index = indexPath.item
        cell.imageView.image = imageSlices[index]
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            
            headerReusableView = (self.collectionView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)) as! HeaderReusableView
            
            return headerReusableView
            
        } else {
            
            footerReusableView = (self.collectionView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)) as! FooterReusableView
            
            footerReusableView?.timerLabel.text = String(footerReusableView.timeCount)
            footerReusableView?.startTimer()
            
            return footerReusableView
        }
        
    }
    
    func configureLayout() {
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        numberOfRows = 4
        numberOfColumns = 3
        spacing = 2
        sectionInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        referenceSize = CGSize(width: 60, height: 60)
        
        let widthDeductionPerItem: CGFloat = (spacing + spacing + spacing + sectionInsets.left + sectionInsets.right)/numberOfColumns
        let heightDeductionPerItem: CGFloat = (spacing + spacing + spacing + spacing + sectionInsets.top + sectionInsets.bottom)/numberOfRows
        
        itemSize = CGSize(width: width/numberOfColumns - widthDeductionPerItem, height: height/numberOfRows - heightDeductionPerItem)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func  collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return referenceSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return referenceSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        self.collectionView?.performBatchUpdates({
        self.imageSlices.insert(self.imageSlices.remove(at: sourceIndexPath.item), at: destinationIndexPath.item)
            }, completion: { _ in
        
            // reorder the imageSlices array here
            if self.imageSlices == self.solvedGame {
                self.footerReusableView.timer.invalidate()
                self.performSegue(withIdentifier: "solvedSegue", sender: Any?.self)
            }
        })
        
    }
    
    
    
    // 1. Check for winning scenario
    // 2. Invalidate the timer
    // 3. Perform segue with identifier "solvedSegue"
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "solvedSegue" {
            let dest = segue.destination as! SolvedViewController
            dest.image = UIImage(named: "cats")
            dest.time = self.footerReusableView.timerLabel.text
        }
    }
    
    func fillImageSlices() {
        for i in 1...12 {
            if let image = UIImage(named: String(i)) {
                imageSlices.append(image)
                solvedGame.append(image)
            }
        }
    }
    
    func shuffle() {
        imageSlices = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: imageSlices) as! [UIImage]
    }
    
    
}



