//
//  UsersTableViewController.swift
//  Random Users
//
//  Created by Kerby Jean on 3/13/20.
//  Copyright © 2020 Erica Sadun. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    var user: User?
    
    var ApiService = API()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadData()
    }
    
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
        if segue.identifier == "UserDetails" {
            let destination = segue.destination as! UserDetailsViewController
            destination.user = sender as! User
        }
    }
}

extension UsersTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }        
        let user = result(for: indexPath)
        cell.nameLabel.text = user?.name.first
        loadImage(for: user!, for: cell, forItemAt: indexPath)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = result(for: indexPath)
        performSegue(withIdentifier: "UserDetails", sender: user)
    }
    
    // MARK: - Private
    
    private func loadImage(for result: Result, for cell: UserCell, forItemAt indexPath: IndexPath) {
        
        if let imageUrl = URL(string: result.picture.medium) {
            let request = URLRequest(url: imageUrl)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    NSLog("Error: \(error)")
                } else {
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        cell.userImageView.image = image
                    }
                }
            }.resume()
        }
        // TODO: Implement image loading here
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func result(for indexPath: IndexPath) -> Result? {
        return user?.results[indexPath.row]
    }
}
