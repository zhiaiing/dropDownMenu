//
//  WDDropDownMenu.swift
//  WhoDo-Swift
//
//  Created by mac on 2017/4/25.
//  Copyright © 2017年 lanxiao. All rights reserved.
//

import UIKit
import SnapKit



// cell被点击后的结果回调函数
public typealias CellClickedBlock = (_ row:NSInteger) -> Void

final class WDDropDownMenu: UIView {

    var tableview :UITableView!
    
    var view :UIView!
    
    var shapHeight : CGFloat = 10
    
    var rect1 :CGRect!
    
    var DataArray = [String]()

    let shapeLayer = CAShapeLayer()
    
    var cellClickedBlock: CellClickedBlock!
    
    
    static var single = WDDropDownMenu.init(frame: CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:UIScreen.main.bounds.size.height))
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        self.addView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addView(){
        
        view = UIView.init(frame: self.frame)
        view.backgroundColor = UIColor.clear
        self.addSubview(view)
        

        let singleRecognizer:UITapGestureRecognizer!
        
        singleRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(singleClick))
        
        singleRecognizer.numberOfTapsRequired = 1;
        //给self.view添加一个手势监测；
        view.addGestureRecognizer(singleRecognizer)
        
        tableview = UITableView.init()
        tableview.layer.masksToBounds   = true;
        tableview.separatorStyle        = .none;
        tableview.layer.cornerRadius    = 6.0;
        tableview.layer.borderWidth     = 1;
        tableview.layer.borderColor     = UIColor.orange.cgColor
        tableview.backgroundColor       = .white
        tableview.delegate              = self
        tableview.dataSource            = self
        self.addSubview(tableview)
    }
    
    func singleClick(){
        self.dismiss()
    }
}


extension WDDropDownMenu : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.DataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell:DropDownMenuTableViewCell = DropDownMenuTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"cell")
       
        cell.backgroundColor = .white
        
        cell.label?.text = self.DataArray[indexPath.row]
        
        if indexPath.row == (self.DataArray.count-1){
            cell.lineView.isHidden = true
        }else{
            cell.lineView.isHidden = false
        }
        
        return cell
    }
}

extension WDDropDownMenu : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 40;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){

        tableView.deselectRow(at: indexPath, animated: true)

        cellClickedBlock!(indexPath.row)
        
        self.dismiss()
    }
}


extension WDDropDownMenu{
    
    public func SetDataArrayandPoint(array:[String],rect:CGRect){

        self.DataArray = array;
        
        let ScreenWidth         = UIScreen.main.bounds.size.width
        let ScreenHeight        = UIScreen.main.bounds.size.height
        
        let tableviewWidth      : CGFloat
        tableviewWidth          = 60
        
        var tableviewHeight     : CGFloat
        tableviewHeight         = CGFloat(array.count * 40)
        
        if tableviewHeight > 4 * 40{
            tableviewHeight = 160
        }
        
        let CenterPoint         = CGPoint(x:rect.origin.x + rect.size.width/2,y:rect.origin.y + rect.size.height/2)
        
        var direction : NSInteger
        
        // 0 底部 1左边 2上边 3右边
        direction = 0
        
        
        if ((rect.size.height + rect.origin.y + tableviewHeight) <= ScreenHeight && (ScreenWidth - CenterPoint.x > tableviewWidth/2 + shapHeight) && (CenterPoint.x > tableviewWidth/2 + shapHeight)){ //  下合适
            
            direction = 0
            print("下边")
            
        }else if(rect.origin.y) >= tableviewHeight && (ScreenWidth - CenterPoint.x > tableviewWidth/2 + shapHeight) && (CenterPoint.x > tableviewWidth/2 + shapHeight){//上合适
            
            direction = 2
            print("上边")
            
            
        }else if(CenterPoint.x >= tableviewWidth + shapHeight){//左合适
            direction = 1
            print("左边")
            
            
        }else{//右合适
            direction = 3
            print("右边")
        }
        
        self.jisuandian(rect: rect, direction: direction)

        self.tableview.contentSize = CGSize(width:60, height:array.count * 40)
        
        
    }
    
    
    func jisuandian(rect:CGRect, direction:NSInteger) {
        
        self.rect1 = rect
        
        let ScreenWidth         = UIScreen.main.bounds.size.width
        let ScreenHeight        = UIScreen.main.bounds.size.height
        
        let tableviewWidth      : CGFloat
        tableviewWidth          = 60
        
        var tableviewHeight     : CGFloat
        tableviewHeight         = CGFloat(self.DataArray.count * 40)
        
        if tableviewHeight > 4 * 40{
            tableviewHeight = 160
        }
        
        let CenterPoint         = CGPoint(x:rect.origin.x + rect.size.width/2,y:rect.origin.y + rect.size.height/2)
        
        switch direction {
        
        case 0://下

            if (ScreenWidth - CenterPoint.x > tableviewWidth/2 + shapHeight) && (CenterPoint.x > tableviewWidth/2 + shapHeight){

                self.tableview.snp.remakeConstraints { (make) in
                    make.top.equalTo(rect.origin.y + rect.size.height + shapHeight)
                    make.left.equalTo(CenterPoint.x - 30)
                    make.width.equalTo(60)
                    make.height.equalTo(tableviewHeight)
                }
                
            }else if((ScreenWidth - CenterPoint.x < tableviewWidth/2 + 3)){ //右边小于所需的距离
                
                self.tableview.snp.remakeConstraints { (make) in
                    make.top.equalTo(rect.origin.y + rect.size.height + shapHeight)
                    make.right.equalTo(3)
                    make.width.equalTo(60)
                    make.height.equalTo(tableviewHeight)
                }
                
            }else{ //左边小于所需的距离
                self.tableview.snp.remakeConstraints { (make) in
                    make.top.equalTo(rect.origin.y + rect.size.height + shapHeight)
                    make.left.equalTo(3)
                    make.width.equalTo(60)
                    make.height.equalTo(tableviewHeight)
                }
            }
            
        break
        
        case 1: //左
            
            if (ScreenHeight - CenterPoint.y > tableviewHeight/2 + shapHeight) && (CenterPoint.y > tableviewHeight/2 + shapHeight){//上下都合适
                
                self.tableview.snp.remakeConstraints { (make) in
                    make.right.equalTo( rect.origin.x - shapHeight )
                    make.top.equalTo(rect.origin.y -  tableviewHeight/2)
                    make.width.equalTo(60)
                    make.height.equalTo(tableviewHeight)
                }
                
            }else if (ScreenHeight - CenterPoint.y < tableviewHeight/2 + shapHeight){//下边小于所需距离
                self.tableview.snp.remakeConstraints { (make) in
                    make.right.equalTo( rect.origin.x - shapHeight)
                    make.bottom.equalTo(3)
                    make.width.equalTo(60)
                    make.height.equalTo(tableviewHeight)
                }
            }else{
                self.tableview.snp.remakeConstraints { (make) in
                    make.right.equalTo( rect.origin.x - shapHeight)
                    make.top.equalTo(3)
                    make.width.equalTo(60)
                    make.height.equalTo(tableviewHeight)
                }
            }
          
            break
            
        case 2: //上
            
            if (ScreenWidth - CenterPoint.x > tableviewWidth/2 + shapHeight) && (CenterPoint.x > tableviewWidth/2 + shapHeight){
                
                self.tableview.snp.remakeConstraints { (make) in
                    make.top.equalTo( rect.origin.y - shapHeight - tableviewHeight)
                    make.left.equalTo(CenterPoint.x - 30)
                    make.width.equalTo(60)
                    make.height.equalTo(tableviewHeight)
                }
                
            }else if((ScreenWidth - CenterPoint.x < tableviewWidth/2 + shapHeight)){ //右边小于所需的距离
                
                self.tableview.snp.remakeConstraints { (make) in
                    make.top.equalTo( rect.origin.y - shapHeight - tableviewHeight)
                    make.right.equalTo(3)
                    make.width.equalTo(60)
                    make.height.equalTo(tableviewHeight)
                }
                
            }else{ //左边小于所需的距离
                self.tableview.snp.remakeConstraints { (make) in
                    make.top.equalTo( rect.origin.y - shapHeight - tableviewHeight)
                    make.left.equalTo(3)
                    make.width.equalTo(60)
                    make.height.equalTo(tableviewHeight)
                }
            }
            
            break
            
        case 3: //右
            
            if (ScreenHeight - CenterPoint.y > tableviewHeight/2 + shapHeight) && (CenterPoint.y > tableviewHeight/2 + shapHeight){//上下都合适
                
                self.tableview.snp.remakeConstraints { (make) in
                    make.left.equalTo( rect.origin.x + rect.size.width + shapHeight)
                    make.top.equalTo(rect.origin.y +  rect.size.height/2  -  tableviewHeight/2)
                    make.width.equalTo(60)
                    make.height.equalTo(tableviewHeight)
                }
                
            }else if (ScreenHeight - CenterPoint.y < tableviewHeight/2 + shapHeight){//下边小于所需距离
                self.tableview.snp.remakeConstraints { (make) in
                    make.left.equalTo( rect.origin.x + rect.size.width + shapHeight)
                    make.bottom.equalTo(3)
                    make.width.equalTo(60)
                    make.height.equalTo(tableviewHeight)
                }
            }else{
                self.tableview.snp.remakeConstraints { (make) in
                    make.left.equalTo( rect.origin.x + rect.size.width + shapHeight)
                    make.top.equalTo(3)
                    make.width.equalTo(60)
                    make.height.equalTo(tableviewHeight)
                }
            }
            
            break
            
        default: break
        }

        self.addbezierPath(rect: rect, direction: direction, rect1: self.tableview.frame)
    }
    
    func addbezierPath(rect:CGRect, direction:NSInteger ,rect1:CGRect){

        shapeLayer.removeAllAnimations()

        let aPath = UIBezierPath()
        aPath.lineWidth = 1.0 // 线条宽度
        aPath.lineCapStyle = CGLineCap.round // 线条拐角
        aPath.lineJoinStyle = CGLineJoin.round // 终点处理
        
        if direction == 0{//下
            // Set the starting point of the shape.
            aPath.move(to: CGPoint(x:rect.origin.x + rect.size.width/2,y:rect.origin.y + rect.size.height))
            // Draw the lines
            aPath.addLine(to: CGPoint(x:rect.origin.x + rect.size.width/2 - 10,y:rect.origin.y + rect.size.height + 10))
            aPath.addLine(to: CGPoint(x:rect.origin.x + rect.size.width/2 + 10,y:rect.origin.y + rect.size.height + 10))
        
            aPath.close() // 最后一条线通过调用closePath方法得到
        }
        
        if direction == 2{//上
            aPath.move(to: CGPoint(x:rect.origin.x + rect.size.width/2,         y:rect.origin.y))
            aPath.addLine(to: CGPoint(x:rect.origin.x + rect.size.width/2 - 10, y:rect.origin.y - 10))
            aPath.addLine(to: CGPoint(x:rect.origin.x + rect.size.width/2 + 10, y:rect.origin.y - 10))
            aPath.close()
        }
        
        if direction == 1{//左
            aPath.move(to: CGPoint(x:rect.origin.x ,y:rect.origin.y + rect.size.height/2))
            aPath.addLine(to: CGPoint(x:rect.origin.x  - 10,y:rect.origin.y + rect.size.height/2 - 10))
            aPath.addLine(to: CGPoint(x:rect.origin.x  - 10,y:rect.origin.y + rect.size.height/2 + 10))
            aPath.close()
        }
        
        if direction == 3{//右
            aPath.move(to: CGPoint(x:rect.origin.x + rect.size.width ,y:rect.origin.y + rect.size.height/2))
            aPath.addLine(to: CGPoint(x:rect.origin.x + rect.size.width + 10,y:rect.origin.y + rect.size.height/2 - 10))
            aPath.addLine(to: CGPoint(x:rect.origin.x + rect.size.width + 10,y:rect.origin.y + rect.size.height/2 + 10))
            aPath.close()
        }
        
        
        //创建一个Layer用于显示
        //let shapeLayer = CAShapeLayer()
        
        //设置区域
        shapeLayer.frame = self.bounds
        
        //边框颜色
        shapeLayer.strokeColor = UIColor.orange.cgColor
        
        shapeLayer.fillColor = nil
        
        //边框宽度
        shapeLayer.lineWidth = 1
        
        shapeLayer.path = aPath.cgPath
        
        self.layer.addSublayer(shapeLayer)
        
        //创建动画
        let drawLineAni = self.baseAnimationWithKeyPath("strokeEnd", fromValue: 0, toValue: 1, duration: 0.3, repeatCount: 0, timingFunction: nil)
        
        //翻转
        drawLineAni.autoreverses = false
        
        shapeLayer.add(drawLineAni, forKey: "drawLineAnimation")
 
        
        self.show()
    }
    
    func baseAnimationWithKeyPath(_ path : String , fromValue : Any? , toValue : Any?, duration : CFTimeInterval, repeatCount : Float? , timingFunction : String?) -> CABasicAnimation{
        
        let animate = CABasicAnimation(keyPath: path)
        //起始值
        animate.fromValue = fromValue;
        
        //变成什么，或者说到哪个值
        animate.toValue = toValue
        
        //所改变属性的起始改变量 比如旋转360°，如果该值设置成为0.5 那么动画就从180°开始
        //        animate.byValue =
        
        //动画结束是否停留在动画结束的位置
        //        animate.isRemovedOnCompletion = false
        
        //动画时长
        animate.duration = duration
        
        //重复次数 Float.infinity 一直重复 OC：HUGE_VALF
        animate.repeatCount = repeatCount ?? 0
        
        //设置动画在该时间内重复
        //        animate.repeatDuration = 5
        
        //延时动画开始时间，使用CACurrentMediaTime() + 秒(s)
        //        animate.beginTime = CACurrentMediaTime() + 2;
        
        //设置动画的速度变化
        /*
         kCAMediaTimingFunctionLinear: String        匀速
         kCAMediaTimingFunctionEaseIn: String        先慢后快
         kCAMediaTimingFunctionEaseOut: String       先快后慢
         kCAMediaTimingFunctionEaseInEaseOut: String 两头慢，中间快
         kCAMediaTimingFunctionDefault: String       默认效果和上面一个效果极为类似，不易区分
         */
        
        animate.timingFunction = CAMediaTimingFunction(name: timingFunction ?? kCAMediaTimingFunctionEaseInEaseOut)
        
        
        //动画在开始和结束的时候的动作
        /*
         kCAFillModeForwards    保持在最后一帧，如果想保持在最后一帧，那么isRemovedOnCompletion应该设置为false
         kCAFillModeBackwards   将会立即执行第一帧，无论是否设置了beginTime属性
         kCAFillModeBoth        该值是上面两者的组合状态
         kCAFillModeRemoved     默认状态，会恢复原状
         */
        animate.fillMode = kCAFillModeBoth
        
        //动画结束时，是否执行逆向动画
        //        animate.autoreverses = true
        
        return animate
    }

    public func show(){
        
        //let appDelegate = (UIApplication.shared.delegate) as! AppDelegate
        //appDelegate.rootViewController1.view.addSubview(WDDropDownMenu.single);
        
        self.getCurrentVC().view.addSubview(WDDropDownMenu.single)
    }
 
    
    public func dismiss(){
        WDDropDownMenu.single.removeFromSuperview()
    }
    
    //MARK: ---取得当前显示的视图控制器---
    func getCurrentVC() -> UIViewController {
        var result:UIViewController?
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindowLevelNormal{
            let windows = UIApplication.shared.windows
            for tmpWin in windows{
                if tmpWin.windowLevel == UIWindowLevelNormal{
                    window = tmpWin
                    break
                }
            }
        }
        
        let fromView = window?.subviews[0]
        if let nextRespnder = fromView?.next{
            if nextRespnder.isKind(of: UIViewController.self){
                result = nextRespnder as? UIViewController
            }else{
                result = window?.rootViewController
            }
        }
        return result!
    }
    
}









