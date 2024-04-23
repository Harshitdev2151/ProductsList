
//

import UIKit
import CoreData

class ProductCartCell: UITableViewCell {
    
    
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productCategoryLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var quantityLabe2: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWithDatabaseObject(_ product: NSManagedObject) {
        productTitleLabel.text = product.value(forKeyPath: Constants.titleString) as? String
        productCategoryLabel.text = product.value(forKeyPath: Constants.categoryString) as? String
        quantityLabe2.text = "Quantity - 1"
      //  priceLabel.text = "$\(product.value(forKeyPath: Constants.categoryString) as? String ?? 0)"

    }

    func setImage(_ img: UIImage?) {
        DispatchQueue.main.async {
            self.productImageView.image = img
        }
    }
}
