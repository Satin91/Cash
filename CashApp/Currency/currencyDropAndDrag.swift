//
//  currencyDropAndDrag.swift
//  CashApp
//
//  Created by Артур on 9.08.21.
//  Copyright © 2021 Артур. All rights reserved.
//

import Foundation
import UIKit

private let autoScrollThreshold: CGFloat = 30
private let autoScrollMinVelocity: CGFloat = 60
private let autoScrollMaxVelocity: CGFloat = 280

private func mapValue(_ value: CGFloat, inRangeWithMin minA: CGFloat, max maxA: CGFloat, toRangeWithMin minB: CGFloat, max maxB: CGFloat) -> CGFloat {
    return (value - minA) * (maxB - minB) / (maxA - minA) + minB
}

extension CurrencyViewController {
    
    func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let cellSnapshot = UIImageView(image: image)
        return cellSnapshot
    }
    // MARK: cell reorder / long press
    @objc func onLongPressGesture(sender: UILongPressGestureRecognizer) {
        let locationInView = sender.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: locationInView)
        let duration: TimeInterval = 0.4
        let usingSpringWithDampingInterval: CGFloat = 0.6
        let initialSpringVelocityInterval: CGFloat = 0.1
        if sender.state == .began {
            if indexPath != nil {
                self.dragInitialIndexPath = indexPath
                let cell = tableView.cellForRow(at: indexPath!)
                self.dragCellSnapshot = snapshotOfCell(inputView: cell!)
                var center = cell?.center
                dragCellSnapshot?.center = center!
                dragCellSnapshot?.alpha = 1.0
                cell?.alpha = 0
                cell?.isHidden = true
                tableView.addSubview(dragCellSnapshot!)
                //Прикольная анимация, убрать если не подойдет по дизайну
                UIView.animate(withDuration: duration,delay: 0, usingSpringWithDamping: usingSpringWithDampingInterval, initialSpringVelocity: initialSpringVelocityInterval ,options: .curveLinear,  animations: { () -> Void in
                    center?.y = locationInView.y
                    self.dragCellSnapshot?.center = center!
                    self.dragCellSnapshot?.transform = (self.dragCellSnapshot?.transform.scaledBy(x: 1.05, y: 1.05))!
                    self.dragCellSnapshot?.alpha = 0.99
                }, completion: { (finished) -> Void in
                    if finished {
                        cell?.isHidden = true
                    }else{
                        UIView.animate(withDuration: duration, animations: { () -> Void in
                            self.dragCellSnapshot?.center = (cell?.center)!
                            self.dragCellSnapshot?.transform = CGAffineTransform.identity
                        }, completion: { (finishedForReserved) -> Void in
                            if finishedForReserved {
                                cell?.alpha = 1.0
                                cell?.isHidden = false
                                self.dragInitialIndexPath = nil
                                self.dragCellSnapshot?.removeFromSuperview()
                                self.dragCellSnapshot = nil
                            }
                        })
                    }
                })
            }
        } else if sender.state == .changed && dragInitialIndexPath != nil {
            var center = dragCellSnapshot?.center
            center?.y = locationInView.y
            dragCellSnapshot?.center = center!
            //tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
            
            // to lock dragging to same section add: "&& indexPath?.section == dragInitialIndexPath?.section" to the if below
            if indexPath != nil && indexPath != dragInitialIndexPath {
                // update your data model
                
                //  currencyPrioritiesObjects
                let dataToMove = userCurrencyObjects[dragInitialIndexPath!.row]
                //ресортировка массива помогает в дальнейшем определить приоритет после перемещения
                userCurrencyObjects.remove(at: dragInitialIndexPath!.row)
                userCurrencyObjects.insert(dataToMove, at: indexPath!.row)
                tableView.moveRow(at: dragInitialIndexPath!, to: indexPath!)
                
                dragInitialIndexPath = indexPath
            }
        } else if sender.state == .ended && dragInitialIndexPath != nil {
            
            let cell = tableView.cellForRow(at: dragInitialIndexPath!)
            cell?.isHidden = true
            //cell?.alpha = 1.0
            UIView.animate(withDuration: duration,delay: 0, usingSpringWithDamping: usingSpringWithDampingInterval , initialSpringVelocity: initialSpringVelocityInterval ,options: .curveEaseOut,  animations: { () -> Void in
                self.dragCellSnapshot?.center = (cell?.center)!
                self.dragCellSnapshot?.transform = CGAffineTransform.identity
                //self.dragCellSnapshot?.alpha = 0.0
                cell?.alpha = 1.0
            }, completion: { (finished) -> Void in
                if finished {
                    
                    
                    
                    self.changePriorityValue() //Функция для пересчета приоритета
                    cell?.alpha = 1.0
                    cell?.isHidden = false
                    self.dragInitialIndexPath = nil
                    self.dragCellSnapshot?.removeFromSuperview()
                    self.dragCellSnapshot = nil
                }else{
                    cell?.alpha = 1.0
                    cell?.isHidden = false
                }
            })
        }
    }
    
    
    
//    func autoScrollVelocity() -> CGFloat {
//        guard let tableView = tableView, let snapshotView = dragCellSnapshot else { return 0 }
//        
//        
//        let safeAreaFrame: CGRect
//        if #available(iOS 11, *) {
//            safeAreaFrame = tableView.frame.inset(by: tableView.adjustedContentInset)
//        } else {
//            safeAreaFrame = tableView.frame.inset(by: tableView.scrollIndicatorInsets)
//        }
//        
//        let distanceToTop = max(snapshotView.frame.minY - safeAreaFrame.minY, 0)
//        let distanceToBottom = max(safeAreaFrame.maxY - snapshotView.frame.maxY, 0)
//        
//        if distanceToTop < autoScrollThreshold {
//            return mapValue(distanceToTop, inRangeWithMin: autoScrollThreshold, max: 0, toRangeWithMin: -autoScrollMinVelocity, max: -autoScrollMaxVelocity)
//        }
//        if distanceToBottom < autoScrollThreshold {
//            return mapValue(distanceToBottom, inRangeWithMin: autoScrollThreshold, max: 0, toRangeWithMin: autoScrollMinVelocity, max: autoScrollMaxVelocity)
//        }
//        return 0
//    }
//
//    func activateAutoScrollDisplayLink() {
//        autoScrollDisplayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLinkUpdate))
//        autoScrollDisplayLink?.add(to: .main, forMode: .default)
//        lastAutoScrollTimeStamp = nil
//    }
//
//    func clearAutoScrollDisplayLink() {
//        autoScrollDisplayLink?.invalidate()
//        autoScrollDisplayLink = nil
//        lastAutoScrollTimeStamp = nil
//    }
//
//    @objc func handleDisplayLinkUpdate(_ displayLink: CADisplayLink) {
//        guard let tableView = tableView else { return }
//        
//        if let lastAutoScrollTimeStamp = lastAutoScrollTimeStamp {
//            let scrollVelocity = autoScrollVelocity()
//            
//            if scrollVelocity != 0 {
//                let elapsedTime = displayLink.timestamp - lastAutoScrollTimeStamp
//                let scrollDelta = CGFloat(elapsedTime) * scrollVelocity
//                
//                let contentOffset = tableView.contentOffset
//                tableView.contentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y + CGFloat(scrollDelta))
//                
//                let contentInset: UIEdgeInsets
//                if #available(iOS 11, *) {
//                    contentInset = tableView.adjustedContentInset
//                } else {
//                    contentInset = tableView.contentInset
//                }
//                
//                let minContentOffset = -contentInset.top
//                let maxContentOffset = tableView.contentSize.height - tableView.bounds.height + contentInset.bottom
//                
//                tableView.contentOffset.y = min(tableView.contentOffset.y, maxContentOffset)
//                tableView.contentOffset.y = max(tableView.contentOffset.y, minContentOffset)
//                
//                updateSnapshotViewPosition()
//                updateDestinationRow()
//            }
//        }
//        lastAutoScrollTimeStamp = displayLink.timestamp
//    }
//    
}
