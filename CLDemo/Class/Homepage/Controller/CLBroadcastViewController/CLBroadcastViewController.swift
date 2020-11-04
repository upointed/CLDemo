//
//  CLBroadcastViewController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/10/12.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit

class CLBroadcastViewController: CLBaseViewController {
    private lazy var arrayDS: [String] = {
        var array = [String]()
        array.append("我是第一个")
        array.append("我是第二个")
        array.append("我是第三个")
        array.append("我是第四个")
        array.append("我是第五个")
        array.append("我是第六个")
        array.append("我是第七个")
        return array
    }()
    private lazy var broadcastView: CLBroadcastView = {
        let view = CLBroadcastView()
        view.register(CLBroadcastMainCell.self, forCellReuseIdentifier: "CLBroadcastMainCell")
        view.delegate = self
        view.dataSource = self
        view.tag = 0
        return view
    }()
    private lazy var broadcastView1: CLBroadcastView = {
        let view = CLBroadcastView()
        view.register(CLBroadcastMainCell.self, forCellReuseIdentifier: "CLBroadcastMainCell")
        view.delegate = self
        view.dataSource = self
        view.tag = 1
        return view
    }()
    private lazy var broadcastView2: CLBroadcastView = {
        let view = CLBroadcastView()
        view.register(CLBroadcastMainCell.self, forCellReuseIdentifier: "CLBroadcastMainCell")
        view.delegate = self
        view.dataSource = self
        view.tag = 2
        return view
    }()
    private lazy var carouseView: CLCarouselView = {
        let view = CLCarouselView()
        view.backgroundColor = UIColor.orange.withAlphaComponent(0.25)
        view.dataSource = self
        view.delegate = self
        view.isAutoScroll = true
        view.autoScrollDeley = 1
        return view
    }()
    private lazy var horizontalInfiniteCollectionView: CLInfiniteCollectionView = {
        let layout = CLFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width / 3.0, height: 80)
        let view = CLInfiniteCollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(CLInfiniteCollectionViewCell.self, forCellWithReuseIdentifier: "CLInfiniteCollectionViewCell")
        view.infiniteDelegate = self
        view.infiniteDataSource = self
        return view
    }()
    private lazy var verticalInfiniteCollectionView: CLInfiniteCollectionView = {
        let layout = CLFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.bounds.width, height: 50)
        let view = CLInfiniteCollectionView(frame: .zero, collectionViewLayout: layout)
        view.isHorizontalScroll = false
        view.register(CLInfiniteCollectionViewCell.self, forCellWithReuseIdentifier: "CLInfiniteCollectionViewCell")
        view.infiniteDelegate = self
        view.infiniteDataSource = self
        return view
    }()

    private lazy var timer: CLGCDTimer = {
        let gcdTimer = CLGCDTimer(interval: 2, delaySecs: 2) {[weak self] (_) in
            self?.scrollToNext()
        }
        return gcdTimer
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        reloadData()
    }
}
extension CLBroadcastViewController {
    func initUI() {
        view.addSubview(broadcastView)
        view.addSubview(broadcastView1)
        view.addSubview(broadcastView2)
        view.addSubview(carouseView)
        view.addSubview(horizontalInfiniteCollectionView)
        view.addSubview(verticalInfiniteCollectionView)
    }
    func makeConstraints() {
        carouseView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(120)
            make.bottom.equalTo(broadcastView.snp.top).offset(-30)
        }
        broadcastView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        broadcastView1.snp.makeConstraints { (make) in
            make.top.equalTo(broadcastView.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        broadcastView2.snp.makeConstraints { (make) in
            make.top.equalTo(broadcastView1.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-100)
        }
        horizontalInfiniteCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
            make.bottom.equalTo(carouseView.snp.top).offset(-30)
        }
        verticalInfiniteCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(120)
            make.bottom.equalTo(horizontalInfiniteCollectionView.snp.top).offset(-30)
        }
    }
    func reloadData() {
        broadcastView.reloadData()
        broadcastView1.reloadData()
        broadcastView2.reloadData()
        
        carouseView.reloadData()
        horizontalInfiniteCollectionView.reloadData()
        verticalInfiniteCollectionView.reloadData()
        
        timer.start()
    }
    func scrollToNext() {
        broadcastView.scrollToNext()
        broadcastView1.scrollToNext()
        broadcastView2.scrollToNext()
        
        horizontalInfiniteCollectionView.scrollToRightItem()
    }
}
extension CLBroadcastViewController: CLCarouselViewDataSource {
    func carouselViewRows() -> Int {
        return arrayDS.count
    }
    func carouselViewDidChange(cell: CLCarouselCell, index: Int) {
        cell.label.text = arrayDS[index]
    }
}
extension CLBroadcastViewController: CLCarouselViewDelegate {
    func carouselViewDidSelect(cell: CLCarouselCell, index: Int) {
        print("点击\(index)")
    }
}
extension CLBroadcastViewController: CLBroadcastViewDelegate {
    func broadcastView(_ broadcast: CLBroadcastView, didSelect index: Int) {
        print("点击\(index)")
    }
}
extension CLBroadcastViewController: CLBroadcastViewDataSource {
    func broadcastViewRows(_ broadcast: CLBroadcastView) -> Int {
        return arrayDS.count
    }
    func broadcastView(_ broadcast: CLBroadcastView, cellForRowAt index: Int) -> CLBroadcastCell {
        let cell = broadcast.dequeueReusableCell(withIdentifier: "CLBroadcastMainCell")
        cell.backgroundColor = UIColor.red.withAlphaComponent(0.35)
        let currentIndex = (index + broadcast.tag) % self.arrayDS.count
        (cell as? CLBroadcastMainCell)?.adText = arrayDS[currentIndex]
        return cell
    }
}
extension CLBroadcastViewController: CLInfiniteCollectionViewDataSource {
    func numberOfItems(_ collectionView: UICollectionView) -> Int {
        return arrayDS.count
    }
    func cellForItemAtIndexPath(_ collectionView: UICollectionView, dequeueIndexPath: IndexPath, index: Int)  -> UICollectionViewCell {
        let cell = horizontalInfiniteCollectionView.dequeueReusableCell(withReuseIdentifier: "CLInfiniteCollectionViewCell", for: dequeueIndexPath) as! CLInfiniteCollectionViewCell
        cell.label.text = arrayDS[index]
        return cell
    }
}
extension CLBroadcastViewController: CLInfiniteCollectionViewDelegate {
    func didSelectCellAtIndexPath(_ collectionView: UICollectionView, index: Int) {
        print("selected \(index)")
    }
}
