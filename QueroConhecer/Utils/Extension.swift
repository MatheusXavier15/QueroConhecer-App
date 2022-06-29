//
//  Extension.swift
//  QueroConhecer
//
//  Created by Matheus Xavier on 29/06/22.
//

import Foundation
import UIKit
extension UIView {
    /*
     @anchor, Método de alinhamento. Recebe parâmetros de alinhamento:
     top, left, bottom, right: (optional (igual a nil se não passado)) NSLayoutYAxisAnchor
     paddingTop, paddingLeft, paddingBottom, paddingRight: (optional (igual a zero se não passado)) CGFloat
     width, height: (optional (igual a nil se não passado)) CGFloat
     */
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    /*
     @setDimensions, Método de alinhamento. Recebe três parâmetros:
     view: CGFloat -> View ao qual será a referência do alinhamento
     constant: CGFloat -> Escala no vértice Y o conteúdo
     leftAnchor: CGFloat -> Determina o ponto de ancoragem da margin esquerda
     paddingLeft: CGFLoat -> Escala no vértice X o conteúdo em relação à esquerda
     */
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    /*
     @setDimensions, Método de dimensionamento. Recebe dois parâmetros:
     Height: CGFloat -> Escala o frame da view para preencher a constraint de altura equivalente ao valor passado
     Width: CGFloat -> Escala o frame da view para preencher a constraint de comprimento equivalente ao valor passado
     */
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func toggleLoading(){
        if let LoadingOverlay = self.subviews.first(where: { $0 is LoadingOverlay }) {
            LoadingOverlay.removeFromSuperview()
        } else {
            let loading = LoadingOverlay(frame: self.bounds)
            self.addSubview(loading)
            self.bringSubviewToFront(loading)
        }
    }
}
