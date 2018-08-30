//
//  JourneysViewController.swift
//  My Journey
//
//  Created by Robert Tanase on 28/08/2018.
//  Copyright © 2018 Robert-TCode. All rights reserved.
//

import Foundation
import UIKit

class JourneysViewController: UIViewController {
    
    @IBOutlet weak var journeysTableView: UITableView!

    var journeys = [Journey]()
    var provider = JourneyProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        journeys = provider.getJourneys()
        print(journeys)
        journeysTableView.reloadData()
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate
extension JourneysViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return journeys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = journeysTableView.dequeueReusableCell(withIdentifier: "JourneyTableViewCell") as? JourneyTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(withJourney: journeys[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // go to JourneyViewController
    }
}
