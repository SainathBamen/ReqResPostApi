//
//  ViewController.swift
//  ReqResPostApi
//
//  Created by Sainath Bamen on 25/09/23.
//



import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray: [Welcome] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        sendPostRequest()
    }

    func sendPostRequest() {
        guard let url = URL(string: "https://reqres.in/api/users") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "name": "Sainath",
            "job": " iOS Developer"
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print("Error serializing JSON: \(error.localizedDescription)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let response = try JSONDecoder().decode(Welcome.self, from: data)
                self.dataArray.append(response)

                // Reload table view on main thread.
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell

        let item = dataArray[indexPath.row]
        cell.firstLabel?.text = "Name: \(item.name), Job: \(item.job)"
        cell.secondLabel.text = "Id: \(item.createdAt)"

        return cell
    }
}
