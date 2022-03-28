//
//  ViewController.swift
//  CombineGround
//
//  Created by Cantay, Onur on 28/03/2022.
//

import UIKit
import RxSwift
import Combine


final class ViewController: UIViewController {
    private let viewModel: ViewModel = .init()
    private let disposeBag: DisposeBag = .init()
    private var cancellables: Set<AnyCancellable> = []
    @IBOutlet private weak var userNameLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // RxSwift
        viewModel
            .getUser()
            .map(\.name)
            .subscribe(userNameLabel.rx.text.asObserver())
            .disposed(by: disposeBag)

        // Combine
//        viewModel.getUserPublisher()
//            .map(\.name)
//            .replaceError(with: nil)
//            .assign(to: \.text, on: userNameLabel)
//            .store(in: &cancellables)
    }

}

