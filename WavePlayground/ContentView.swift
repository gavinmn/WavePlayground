//
//  ContentView.swift
//  WavePlayground
//
//  Created by Gavin Nelson on 1/19/24.
//

import SwiftUI
import Wave

struct ContentView: View {
	
	@State var position: CGPoint = .zero
	@State var size: CGSize = CGSize(width: collapsedSize, height: collapsedSize)
	
	@State var touchStartPosition: CGPoint = .zero
	
	static let spring = Spring(dampingRatio: 0.6, response: 0.7)
	@State var sizeAnimator = SpringAnimator<CGSize>(spring: spring)
	@State var positionAnimator = SpringAnimator<CGPoint>(spring: spring)
	
	static let collapsedSize: CGFloat = 128
	static let expandedSize: CGFloat = collapsedSize * 2
	
	@State var expanded: Bool = false {
		didSet {
			let size = self.expanded ? Self.expandedSize : Self.collapsedSize
			sizeAnimator.target = CGSize(width: size, height: size)
			sizeAnimator.start()
		}
	}
	
	var body: some View {
		GeometryReader { geometry in
			RoundedRectangle(cornerRadius: 10, style: .continuous)
				.fill(.blue)
				.frame(width: size.width, height: size.height)
				.position(position)
			
				.onTapGesture {
					expanded.toggle()
				}
			
				.onAppear {
					position.x = geometry.size.width / 2
					position.y = geometry.size.height / 2
					
					touchStartPosition = position
					
					positionAnimator.value = .zero
					positionAnimator.valueChanged = { newValue in
						position = newValue
					}
					
					sizeAnimator.value = CGSize(width: Self.collapsedSize, height: Self.collapsedSize)
					sizeAnimator.valueChanged = { newValue in
						size = newValue
					}
				}
				.gesture(
					DragGesture()
						.onChanged({ gesture in
							positionAnimator.target = CGPoint(
								x: touchStartPosition.x + gesture.translation.width,
								y: touchStartPosition.y + gesture.translation.height
							)
							
							positionAnimator.mode = .nonAnimated
							positionAnimator.start()
						})
					
						.onEnded({ gesture in
							positionAnimator.target = touchStartPosition
							positionAnimator.mode = .animated
							positionAnimator.velocity = CGPoint(x: gesture.velocity.width, y: gesture.velocity.height)
							positionAnimator.start()
							
							expanded.toggle()
						})
				)
		}
	}
}

#Preview {
	ContentView()
}
