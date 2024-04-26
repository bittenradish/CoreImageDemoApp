//
//  FilterListViewControllerCollectionViewController.swift
//  CoreImageDemoApp
//
//  Created by Rashid on 19.11.23.
//

import UIKit

private let reuseIdentifier = "filterCell"

class FilterListViewController: UICollectionViewController {
    
    private let filterList = 
    [
        "Blur",
//        "Bad Blur",
        "Sepia",
        "Invert color",
        "Lumos",
        "Custom Filter",
        "Auto Enhancement"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setCollectionViewLayout(generateFilterLayour(), animated: false)
    }
    
    private func generateFilterLayour() -> UICollectionViewLayout {
        let cell = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        )
        cell.contentInsets = NSDirectionalEdgeInsets(top: 10.0, leading: 15.0, bottom: 10.0, trailing: 15.0)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100.0)),
            repeatingSubitem: cell,
            count: 1
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using [segue destinationViewController].
    //        // Pass the selected object to the new view controller.
    //
    //    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        guard let filterCell = cell as? FilterCell else{
            return cell
        }
        filterCell.filterNameText.text = filterList[indexPath.item]
        filterCell.commonInit()
        
        return filterCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the selected cell
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterCell {
            // Apply a tap animation to the cell
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { (_) in
                // Complete the animation by restoring the original size
                UIView.animate(withDuration: 0.1) {
                    cell.transform = .identity
                }
            }
        }
        
        let selectedFilter = filterList[indexPath.item].lowercased()
        if selectedFilter == "sepia"{
            performSegue(withIdentifier: "sepia", sender: nil)
        }
        if selectedFilter == "bad blur"{
            performSegue(withIdentifier: "error_blur", sender: nil)
        }
        
        if selectedFilter == "auto enhancement"{
            performSegue(withIdentifier: "auto_enh", sender: nil)
        }
        
        if selectedFilter == "blur" {
            performSegue(withIdentifier: "blur", sender: nil)
        }
        
        if selectedFilter == "invert color" {
            performSegue(withIdentifier: "invert", sender: nil)
        }
        
        if selectedFilter == "custom filter" {
            performSegue(withIdentifier: "custom_filter", sender: nil)
        }
        
        if selectedFilter == "lumos" {
            performSegue(withIdentifier: "lumos", sender: nil)
        }
        
    }
    
}
