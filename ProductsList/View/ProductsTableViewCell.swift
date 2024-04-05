//
//  ProductsTableViewCell.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//

import UIKit
import CoreData

class ProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var productImgView: UIImageView!

    func configureWith(_ product: Product) {
        title.text = product.title
        desc.text = product.description
        category.text = product.category
    }

    func configureWithDatabaseObject(_ product: NSManagedObject) {

        title.text = product.value(forKeyPath: "title") as? String
        desc.text = product.value(forKeyPath: "desc") as? String
        category.text = product.value(forKeyPath: "category") as? String
    }

    func setImage(_ img: UIImage?) {
        DispatchQueue.main.async {
            self.productImgView.image = img
            self.productImgView.reloadInputViews()
        }
    }

}
