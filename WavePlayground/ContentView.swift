//
//  ContentView.swift
//  WavePlayground
//
//  Created by Gavin Nelson on 1/19/24.
//

import SwiftUI
import Wave

struct ContentView: View {
	
	@State var expanded: Bool = false
	@State var position: CGPoint = .zero
	
	@State var touchStartPosition: CGPoint = .zero
	
	let positionAnimator = SpringAnimator<CGPoint>(spring: Spring(dampingRatio: 0.6, response: 0.7))
	
	var body: some View {
		GeometryReader { geometry in
			RoundedRectangle(cornerRadius: 10, style: .continuous)
				.fill(.blue)
				.frame(width: expanded ? 256 : 128, height: expanded ? 256 : 128)
				.position(position)
				.onAppear {
					position.x = geometry.size.width / 2
					position.y = geometry.size.height / 2
					
					touchStartPosition = position
					
					positionAnimator.value = .zero
					positionAnimator.valueChanged = { newValue in
						position = newValue
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
							positionAnimator.start()
							
							withAnimation {
								expanded.toggle()
							}
						})
				)
				.onTapGesture {
					withAnimation {
						expanded.toggle()
					}
				}
		}
		
	}
}

#Preview {
	ContentView()
}
