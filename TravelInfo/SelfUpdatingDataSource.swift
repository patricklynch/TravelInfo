//
//  SelfUpdatingDataSource.swift
//  CarBrowser
//
//  Created by Patrick Lynch on 1/31/17.
//  Copyright © 2017 lynchdev. All rights reserved.
//

import UIKit

protocol SelfUpdatingDataSource: class {
    var delegate: SelfUpdatingDataSourceDelegate? { get set }
    func decorate(cell: UIView, at indexPath: IndexPath)
    func redecorateVisibleCells(in collectionView: UICollectionView)
}

extension SelfUpdatingDataSource {
    func redecorateVisibleCells(in collectionView: UICollectionView) {
        for indexPath in collectionView.indexPathsForVisibleItems {
            if let cell = collectionView.cellForItem(at: indexPath) {
                decorate(cell: cell, at: indexPath)
            }
        }
    }
}

/// Defines an object that inserts, deleletes and reloads cells and sections in a collection view
/// See extension for `UICollectionView`
protocol SelfUpdatingDataSourceDelegate: class {
    func dataSource(_ dataSource: SelfUpdatingDataSource, didUpdateItemsFromOldValue oldValue: NSOrderedSet, toNewValue newValue: NSOrderedSet, section: Int)
    func dataSource(_ dataSource: SelfUpdatingDataSource, reloadSections sections: [Int])
    func dataSource(_ dataSource: SelfUpdatingDataSource, reloadSections sections: [Int], animated: Bool)
    func dataSource(_ dataSource: SelfUpdatingDataSource, redecorateItemsIn section: Int)
    func dataSourceReloadAll(_ dataSource: SelfUpdatingDataSource)
    func dataSourceReloadAll(_ dataSource: SelfUpdatingDataSource, animated: Bool)
}

extension SelfUpdatingDataSourceDelegate {
    func dataSource(_ dataSource: SelfUpdatingDataSource, reloadSections sections: [Int]) {
        self.dataSource(dataSource, reloadSections: sections, animated: true)
    }
    
    func dataSourceReloadAll(_ dataSource: SelfUpdatingDataSource) {
        self.dataSourceReloadAll(dataSource, animated: true)
    }
}

extension UICollectionView: SelfUpdatingDataSourceDelegate {
    
    func dataSource(_ dataSource: SelfUpdatingDataSource, redecorateItemsIn section: Int) {
        for indexPath in indexPathsForVisibleItems.filter({ $0.section == section }) {
            if let cell = cellForItem(at: indexPath) {
                dataSource.decorate(cell: cell, at: indexPath)
            }
        }
    }
    
    func dataSource(_ dataSource: SelfUpdatingDataSource, reloadSections sections: [Int], animated: Bool) {
        let updates = {
            self.reloadSections(IndexSet(sections))
        }
        if animated {
            performBatchUpdates(updates, completion: nil)
        } else {
            UIView.animate(withDuration: 0.0) {
                self.performBatchUpdates(updates, completion: nil)
            }
        }
    }
    
    func dataSource(_ dataSource: SelfUpdatingDataSource, didUpdateItemsFromOldValue oldValue: NSOrderedSet, toNewValue newValue: NSOrderedSet, section: Int) {
        
        let insertedIndexPaths = newValue.indexPathsForInsertedItems(from: oldValue, section: section)
        let deletedIndexPaths = newValue.indexPathsForDeletedItems(from: oldValue, section: section)
        guard !insertedIndexPaths.isEmpty || !deletedIndexPaths.isEmpty else {
            return
        }
        
        performBatchUpdates(
            {
                if !insertedIndexPaths.isEmpty {
                    self.insertItems(at: insertedIndexPaths)
                }
                if !deletedIndexPaths.isEmpty {
                    self.deleteItems(at: deletedIndexPaths)
                }
        },
            completion: nil
        )
    }
    
    func dataSourceReloadAll(_ dataSource: SelfUpdatingDataSource, animated: Bool) {
        if !animated {
            reloadData()
        } else {
            performBatchUpdates(
                {
                    self.reloadData()
            },
                completion: nil
            )
        }
    }
}

extension UITableView: SelfUpdatingDataSourceDelegate {
    
    func dataSource(_ dataSource: SelfUpdatingDataSource, redecorateItemsIn section: Int) {
        for cell in visibleCells {
            if let indexPath = indexPath(for: cell), indexPath.section == section {
                dataSource.decorate(cell: cell, at: indexPath)
            }
        }
    }
    
    func dataSource(_ dataSource: SelfUpdatingDataSource, reloadSections sections: [Int], animated: Bool) {
        if animated {
            beginUpdates()
        }
        reloadSections(IndexSet(sections), with: .automatic)
        if animated {
            endUpdates()
        }
    }
    
    func dataSource(_ dataSource: SelfUpdatingDataSource, didUpdateItemsFromOldValue oldValue: NSOrderedSet, toNewValue newValue: NSOrderedSet, section: Int) {
        
        if oldValue.count == 0 {
            reloadData()
            if newValue.count > 0 {
                alpha = 0.0
                UIView.animate(withDuration: 0.3) {
                    self.alpha = 1.0
                }
            }
            
        } else {
            let insertedIndexPaths = newValue.indexPathsForInsertedItems(from: oldValue, section: section)
            let deletedIndexPaths = newValue.indexPathsForDeletedItems(from: oldValue, section: section)
            guard !insertedIndexPaths.isEmpty || !deletedIndexPaths.isEmpty else {
                return
            }
            
            beginUpdates()
            if !insertedIndexPaths.isEmpty {
                insertRows(at: insertedIndexPaths, with: .fade)
            }
            if !deletedIndexPaths.isEmpty {
                deleteRows(at: deletedIndexPaths, with: .fade)
            }
            endUpdates()
        }
    }
    
    func dataSourceReloadAll(_ dataSource: SelfUpdatingDataSource, animated: Bool) {
        if !animated {
            reloadData()
        } else {
            beginUpdates()
            reloadData()
            endUpdates()
        }
    }
}

private extension NSOrderedSet {
    
    func indexPathsForDeletedItems(from orderedSet: NSOrderedSet, section: Int) -> [IndexPath] {
        let deletedItems = orderedSet.array.filter { !contains($0) }
        return deletedItems.map {
            let index = orderedSet.index(of: $0)
            return IndexPath(item: index, section: section)
        }
    }
    
    func indexPathsForInsertedItems(from orderedSet: NSOrderedSet, section: Int) -> [IndexPath] {
        let insertedItems = array.filter { !orderedSet.contains($0) }
        return insertedItems.map {
            let index = self.index(of: $0)
            return IndexPath(item: index, section: section)
        }
    }
}
