//
//  CLDrawMarqueeController.swift
//  CLDemo
//
//  Created by Chen JmoVxia on 2020/11/9.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import UIKit
import SnapKit

//MARK: - JmoVxia---类-属性
class CLDrawMarqueeController: CLBaseViewController {
    let array = ["漫漫秋夜长，烈烈北风凉。",
                 "展转不能寐，披衣起彷徨。",
                 "彷徨忽已久，白露沾我裳。",
                 "俯视清水波，仰看明月光。",
                 "天汉回西流，三五正纵横。",
                 "草虫鸣何悲，孤雁独南翔。",
                 "郁郁多悲思，绵绵思故乡。",
                 "愿飞安得翼，欲济河无梁。",
                 "向风长叹息，断绝我中肠。",
                 "西北有浮云，亭亭如车盖。",
                 "惜哉时不遇，适与飘风会。",
                 "吹我东南行，行行至吴会。",
                 "吴会非吾乡，安能久留滞。",
                 "弃置勿复陈，客子常畏人。",]
    private lazy var marqueeView: CLDrawMarqueeView = {
        let view = CLDrawMarqueeView(direction: .right)
        view.delegate = self
        view.backgroundColor = UIColor.orange.withAlphaComponent(0.35)
        return view
    }()
    private lazy var horizontalMarqueeView: CLDrawMarqueeCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize.init(width: 80, height: 40)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        let view = CLDrawMarqueeCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.cyan.withAlphaComponent(0.35)
        view.infiniteDelegate = self
        view.infiniteDataSource = self
        view.register(CLDrawMarqueeHorizontalCell.self, forCellWithReuseIdentifier: "CLDrawMarqueeHorizontalCell")
        view.isScrollEnabled = false
        return view
    }()
    private lazy var verticalMarqueeView: CLDrawMarqueeCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize.init(width: 40, height: 80)
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        let view = CLDrawMarqueeCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.cyan.withAlphaComponent(0.35)
        view.infiniteDelegate = self
        view.infiniteDataSource = self
        view.register(CLDrawMarqueeVerticalCell.self, forCellWithReuseIdentifier: "CLDrawMarqueeVerticalCell")
        view.isScrollEnabled = false
        return view
    }()

    private lazy var timer: CLGCDTimer = {
        let gcdTimer = CLGCDTimer(interval: 0.01, delaySecs: 0.01) {[weak self] (_) in
            self?.scrollToLeft()
        }
        return gcdTimer
    }()
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        marqueeView.stopAnimation()
        CLLog("CLDrawMarqueeController deinit")
    }
}
//MARK: - JmoVxia---生命周期
extension CLDrawMarqueeController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        makeConstraints()
        initData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
//MARK: - JmoVxia---布局
private extension CLDrawMarqueeController {
    func initUI() {
        view.addSubview(marqueeView)
        view.addSubview(horizontalMarqueeView)
        view.addSubview(verticalMarqueeView)
    }
    func makeConstraints() {
        marqueeView.snp.makeConstraints { (make) in
            make.top.equalTo(120)
            make.height.equalTo(40)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
        horizontalMarqueeView.snp.makeConstraints { (make) in
            make.top.equalTo(marqueeView.snp.bottom).offset(30)
            make.height.equalTo(40)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
        }
        verticalMarqueeView.snp.makeConstraints { (make) in
            make.top.equalTo(horizontalMarqueeView.snp.bottom).offset(30)
            make.height.equalTo(200)
            make.width.equalTo(40)
            make.centerX.equalToSuperview()
        }
    }
}
//MARK: - JmoVxia---数据
private extension CLDrawMarqueeController {
    func initData() {
        marqueeView.setText(array.first!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.marqueeView.startAnimation()
            self.timer.start()
        }
    }
}
extension CLDrawMarqueeController {
    func scrollToLeft() {
        horizontalMarqueeView.horizontalScroll(1)
        verticalMarqueeView.verticalScroll(1)
    }
}
extension CLDrawMarqueeController: CLDrawMarqueeViewDelegate {
    func drawMarqueeView(view: CLDrawMarqueeView, index: Int, animationDidStopFinished finished: Bool) {
        if finished {
            view.setText(array[index % array.count])
        }
    }
}
extension CLDrawMarqueeController: CLDrawMarqueeCollectionViewDataSource {
    func cellForItemAtIndexPath(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == horizontalMarqueeView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLDrawMarqueeHorizontalCell", for: indexPath) as! CLDrawMarqueeHorizontalCell
            cell.label.text = array[indexPath.row]
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CLDrawMarqueeVerticalCell", for: indexPath) as! CLDrawMarqueeVerticalCell
            cell.label.text = array[indexPath.row]
            return cell
        }
    }
    
    func numberOfItems(_ collectionView: UICollectionView) -> Int {
        return array.count
    }
}
extension CLDrawMarqueeController: CLDrawMarqueeCollectionViewDelegate {
    func didSelectCellAtIndexPath(_ collectionView: UICollectionView, indexPath: IndexPath) {
        CLLog("didSelectCellAtIndexPath \(indexPath.row)")
    }
}