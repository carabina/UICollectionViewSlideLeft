//
//  ViewController.swift
//  UICollectionViewSlideLeft
//
//  Created by Antoine Bellanger on 10.01.17.
//  Copyright © 2017 antoinebellanger. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var planes:[String] = ["A320", "B717", "B737", "E190"]
    
    var activeCell: PlaneCollectionViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft : UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.userDidSwipeLeft(_:)))
        swipeLeft.direction = .left
        collectionView?.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.userDidSwipeRight))
        swipeRight.direction = .right
        collectionView?.addGestureRecognizer(swipeRight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UICollectionViewDataSource - UICollectionViewDelegate

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PlaneCollectionViewCell
        cell.planeImageView.image = UIImage(named: planes[indexPath.row])
        cell.planeLabel.text = planes[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // If clicked on another cell than the swiped cell
        let cell = collectionView.cellForItem(at: indexPath)
        if activeCell != nil && activeCell != cell {
            userDidSwipeRight()
        }
    }
    
    //MARK: Swipe to Delete
    
    func getCellAtPoint(_ point: CGPoint) -> PlaneCollectionViewCell? {
        // Function for getting item at point. Note optionals as it could be nil
        let indexPath = collectionView?.indexPathForItem(at: point)
        var cell : PlaneCollectionViewCell?
        
        if indexPath != nil {
            cell = collectionView?.cellForItem(at: indexPath!) as? PlaneCollectionViewCell
        } else {
            cell = nil
        }
        
        return cell
    }
    
    func userDidSwipeLeft(_ gesture : UISwipeGestureRecognizer){
        
        let point = gesture.location(in: collectionView)
        //let tapPoint = tap.location(in: collectionView)
        let duration = animationDuration()
        
        if(activeCell == nil){
            activeCell = getCellAtPoint(point)
            
            UIView.animate(withDuration: duration, animations: {
                self.activeCell.myCellView.transform = CGAffineTransform(translationX: -self.activeCell.frame.width, y: 0)
            });
        } else {
            // Getting the cell at the point
            let cell = getCellAtPoint(point)
            
            // If the cell is the previously swiped cell, or nothing assume its the previously one.
            if cell == nil || cell == activeCell {
                // To target the cell after that animation I test if the point of the swiping exists inside the now twice as tall cell frame
                let cellFrame = activeCell.frame
                let rect = CGRect(x: cellFrame.origin.x - cellFrame.width, y: cellFrame.origin.y, width: cellFrame.width*2, height: cellFrame.height)
                
                if rect.contains(point) {
                    print("Swiped inside cell")
                    // If swipe point is in the cell delete it
                    
                    let indexPath = collectionView?.indexPath(for: activeCell)
                    planes.remove(at: (indexPath?.row)!)
                    self.collectionView?.deleteItems(at: [indexPath!])
                    
                }
                
                // If another cell is swiped
            } else if activeCell != cell {
                // It's not the same cell that is swiped, so the previously selected cell will get unswiped and the new swiped.
                UIView.animate(withDuration: duration, animations: {
                    self.activeCell.myCellView.transform = CGAffineTransform.identity
                    cell!.myCellView.transform = CGAffineTransform(translationX: -cell!.frame.width, y: 0)
                }, completion: {
                    (Void) in
                    self.activeCell = cell
                })
                
            }
        }
    }
    
    func userDidSwipeRight(){
        // Revert back
        if(activeCell != nil){
            let duration = animationDuration()
            
            UIView.animate(withDuration: duration, animations: {
                self.activeCell.myCellView.transform = CGAffineTransform.identity
            }, completion: {
                (Void) in
                self.activeCell = nil
            })
        }
    }
    
    func animationDuration() -> Double {
        return 0.5
    }


}

