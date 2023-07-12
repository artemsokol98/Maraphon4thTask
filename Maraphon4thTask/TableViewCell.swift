//
//  TableViewCell.swift
//  Maraphon4thTask
//
//  Created by Артем Соколовский on 10.07.2023.
//

import UIKit

class TableViewCell: UITableViewCell {

	static let identifier = "tableViewCellIdentifier"
	
	override func prepareForReuse() {
		super.prepareForReuse()
		self.accessoryType = .none
	}
}
