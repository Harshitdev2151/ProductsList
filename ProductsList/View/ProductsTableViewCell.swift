//
//  ProductsTableViewCell.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//

import UIKit
import CoreData


/// Cell in Tableview to display the required data to customer
class ProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var productImgView: UIImageView!

    func configureWith(_ product: Product) {
        title.text = product.title
        desc.text = product.description
        category.text = product.category
        self.productImgView.image = UIImage(named: Constants.defaultLoaderImage)
    }

    func configureWithDatabaseObject(_ product: NSManagedObject) {

        title.text = product.value(forKeyPath: Constants.titleString) as? String
        desc.text = product.value(forKeyPath: Constants.descString) as? String
        category.text = product.value(forKeyPath: Constants.categoryString) as? String
    }

    func setImage(_ img: UIImage?) {
        DispatchQueue.main.async {
            self.productImgView.image = img
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.productImgView.image = nil
    }

}
