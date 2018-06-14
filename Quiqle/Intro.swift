//
//  ViewController.swift
//  Quiqle
//
//  Created by Sikander Zeb on 5/29/18.
//  Copyright © 2018 Sikander Zeb. All rights reserved.
//

import UIKit

class Intro: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    let imagesArray = [#imageLiteral(resourceName: "slide1"), #imageLiteral(resourceName: "slide2"), #imageLiteral(resourceName: "slide3")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: collection.frame.size.height) 
        collection.setCollectionViewLayout(layout, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Intro : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let image = cell.viewWithTag(1) as! UIImageView
        image.image = imagesArray[indexPath.row]
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //let currentIndex = (collection.contentOffset.x / collection.frame.size.width + 0.5) as! Int;
        pageControl.currentPage = collection.indexPathsForVisibleItems[0].row;
        if pageControl.currentPage == 0 {
            welcomeLabel.text = "Welcome"
        }
        else if pageControl.currentPage == 1 {
            welcomeLabel.text = "Connect"
        }
        else  {
            welcomeLabel.text = "Hang Out"
        }
    }
}



