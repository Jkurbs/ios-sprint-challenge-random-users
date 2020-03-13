//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Kerby Jean on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var user: User?
    var ApiService = API()
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    // MARK: - Functions
    
    func loadData() {
        ApiService.fetch() { (user, error) in
            if let error = error {
                NSLog("Error: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.user = user
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == .userDetails {
            let destination = segue.destination as! UserDetailsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let cell = tableView.cellForRow(at: indexPath) as! UserCell
                let user = result(for: indexPath)
                destination.user = user
                destination.image = cell.userImageView.image
            }
        }
    }
}


// MARK: - UITableViewDataSource

extension UsersTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.id, for: indexPath) as? UserCell else {
            return UITableViewCell()
        }        
        let user = result(for: indexPath)
        cell.nameLabel.text = user?.name.first
        loadImage(for: user!, for: cell, forItemAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let imageUrl = result(for: indexPath)?.picture.large {
            ImageDownloadManager.shared.downloadImage(imageUrl, indexPath: indexPath) { (image, url, indexPathh, error) in
                 DispatchQueue.main.async {
                    if let getCell = tableView.cellForRow(at: indexPath) {
                        (getCell as? UserCell)!.userImageView.image = image
                    }
                }
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = result(for: indexPath)
        performSegue(withIdentifier: .userDetails, sender: user)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        ImageDownloadManager.shared.cancelAll()
    }
    
    // MARK: - Private
    
    private func loadImage(for result: Result, for cell: UserCell, forItemAt indexPath: IndexPath) {
        ApiService.fetchImage( result.picture.large) { (data, error) in
            if let error = error {
                NSLog("Error: \(error)")
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                cell.userImageView.image = image
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func result(for indexPath: IndexPath) -> Result? {
        return user?.results[indexPath.row]
    }
}
