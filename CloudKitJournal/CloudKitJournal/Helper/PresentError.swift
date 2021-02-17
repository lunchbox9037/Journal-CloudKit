//
//  PresentError.swift
//  CloudKitJournal
//
//  Created by stanley phillips on 2/2/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentErrorToUser() {
        let alertController = UIAlertController(title: "Whoops", message: "Please enter a Title!", preferredStyle: .actionSheet)
        let dismissAction = UIAlertAction(title: "Ok", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(dismissAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
