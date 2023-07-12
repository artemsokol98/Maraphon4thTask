//
//  ViewController.swift
//  Maraphon4thTask
//
//  Created by Артем Соколовский on 10.07.2023.
//

import UIKit

typealias TableDataSource = UITableViewDiffableDataSource<Int, Number>

class ViewController: UIViewController {
	
	lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .insetGrouped)
		return tableView
	}()
	
	var arrayOfNumbers: [Number] = Number.data
	var selectedNumbers = Set<Number>()
	
	lazy var dataSource: TableDataSource = {
		let dataSource = TableDataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
			let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath)
			cell.textLabel?.text = itemIdentifier.number
			
			if self.selectedNumbers.contains(itemIdentifier) {
				cell.accessoryType = .checkmark
			}
			
			return cell
		}
		
		return dataSource
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
		
		var snapshot = dataSource.snapshot()
		snapshot.appendSections([0])
		snapshot.appendItems(arrayOfNumbers, toSection: 0)
		dataSource.apply(snapshot)
		
		title = "Task 4"
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffleTable))
		
		view.addSubview(tableView)
		tableView.frame = view.bounds
		tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.backgroundColor = .white
	}
	
	private func setupSnapshot(store: [Number]) {
		var snapshot = dataSource.snapshot()
		
		snapshot.reloadSections([0])
		snapshot.appendItems(store, toSection: 0)
		
		dataSource.apply(snapshot, animatingDifferences: true)
	}

	@objc func shuffleTable() {
		self.arrayOfNumbers = self.arrayOfNumbers.shuffled()
		setupSnapshot(store: arrayOfNumbers)
	}

}

extension ViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		guard let number = dataSource.itemIdentifier(for: indexPath) else {
			return
		}

		guard let zeroNumber = dataSource.itemIdentifier(for: IndexPath(row: 0, section: 0)) else {
			return
		}
		
		var snapshot = dataSource.snapshot()
		
		if selectedNumbers.contains(number) {
			selectedNumbers.remove(number)
			
		} else {
			selectedNumbers.insert(number)
			if number != zeroNumber {
				snapshot.moveItem(number, beforeItem: zeroNumber)
			}
		}
		
		snapshot.reloadItems([number])
		dataSource.apply(snapshot, animatingDifferences: true)
	}
}
