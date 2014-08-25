//
//  CollectionViewBatchUpdatesQueue.swift
//  Spaces
//
//  Created by Alex McLeod on 11/07/2014.
//  Copyright (c) 2014 Alex McLeod. All rights reserved.
//

import Foundation

class FetchedResultsControllerUpdatesQueue {
    /* 
        Used to mediate between NSFetchedResultsController and UICollectionView. Changes in NSFetchResultsController must be queued
        and then applied to UICollectionView to prevent NSInternalConsistencyException. This class makes queuing of updates easy.
    */
    
    var _sectionChanges:Array<Dictionary<NSFetchedResultsChangeType, Int>> = []
    var _objectChanges:Array<Dictionary<NSFetchedResultsChangeType, Array<NSIndexPath>>> = []
    
    
    func batchUpdateCollectionView(collectionView: UICollectionView) {
        /*
           Perform batch updates to a given collection view once NSFetchedResultsController has finished doing it's work.
           This is to avoid NSInternalConsistencyException.
        */
        if (self._sectionChanges.count > 0) {
            collectionView.performBatchUpdates({
                for change in self._sectionChanges {
                    for (type, index) in change {
                        switch type {
                        case NSFetchedResultsChangeInsert:
                            collectionView.insertSections(NSIndexSet(index: index))
                            
                        case NSFetchedResultsChangeDelete:
                            collectionView.deleteSections(NSIndexSet(index: index))
                            
                        default:
                            return
                        }
                        
                    }
                }
                },
                completion: nil
            )
        }
        
        if (self._objectChanges.count > 0 && self._sectionChanges.count == 0) {
            
            if (self.shouldReloadCollectionViewToPreventKnownIssue(collectionView) || collectionView.window == nil) {
                // This is to prevent a bug in UICollectionView from occurring. 
                // See comment at top of shouldReloadCollectionViewToPreventKnownIssue.
                collectionView.reloadData()
            } else {
                collectionView.performBatchUpdates({
                    for change in self._objectChanges {
                        for (type, indexSet) in change {
                            switch type {
                            case NSFetchedResultsChangeInsert:
                                collectionView.insertItemsAtIndexPaths(indexSet)
                                
                            case NSFetchedResultsChangeDelete:
                                collectionView.deleteItemsAtIndexPaths(indexSet)
                                
                            case NSFetchedResultsChangeUpdate:
                                collectionView.reloadItemsAtIndexPaths(indexSet)
                                
                            case NSFetchedResultsChangeMove:
                                collectionView.moveItemAtIndexPath(indexSet[0], toIndexPath: indexSet[1])
                            default:
                                return
                            }
                            
                        }
                    }
                    },
                    completion: nil
                )
            }
        }
        self._sectionChanges.removeAll(keepCapacity: true)
        self._objectChanges.removeAll(keepCapacity: true)
    }
    
    func shouldReloadCollectionViewToPreventKnownIssue(collectionView:UICollectionView) -> Bool {
        /* 
            This is to prevent a bug in UICollectionView from occurring.
            The bug presents itself when inserting the first object or deleting the last object in a collection view.
            http://stackoverflow.com/questions/12611292/uicollectionview-assertion-failure
            This code should be removed once the bug has been fixed, it is tracked in OpenRadar
            http://openradar.appspot.com/12954582
        */
        var shouldReload = false
        for change in self._objectChanges {
            for (type, indexSet) in change {
                let indexPath = indexSet[0]
                switch(type) {
                case NSFetchedResultsChangeInsert:
                    if (collectionView.numberOfItemsInSection(indexPath.section) == 0) {
                        shouldReload = true
                    }
                case NSFetchedResultsChangeDelete:
                    if (collectionView.numberOfItemsInSection(indexPath.section) == 1) {
                        shouldReload = true
                    }
                default:
                    shouldReload = false
                }
            }
        }
        return shouldReload
    }
    
    func addSectionChangeOfType(type: NSFetchedResultsChangeType, atSectionIndex sectionIndex: Int) {
        
        if (type == nil || sectionIndex == nil) {return}

        var change:Dictionary<NSFetchedResultsChangeType, Int> = Dictionary(minimumCapacity: 1)
        
        change[type] = sectionIndex
        
        self._sectionChanges.append(change)
    }
    
    func addObjectChangeOfType(type: NSFetchedResultsChangeType, atIndexPath indexPath: NSIndexPath, newIndexPath: NSIndexPath) {
        
        if (type == nil || indexPath == nil) {return};
        
        // Need to have an array of index paths as value, just for the case where the type is NSFetchedResultsChangeMove.
        var change:Dictionary<NSFetchedResultsChangeType, Array<NSIndexPath>> = Dictionary(minimumCapacity: 1)
        
        if (newIndexPath != nil) {
            change[type] = [indexPath, newIndexPath]
        } else {
            change[type] = [indexPath]
        }
        
        self._objectChanges.append(change)
    }
}