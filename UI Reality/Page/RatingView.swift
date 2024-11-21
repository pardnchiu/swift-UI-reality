//
//  RatingView.swift
//  UI Reality
//
//  Created by Pardn on 2024/11/21.
//

import SwiftUI

struct FaceValue {
	var width: CGFloat;
	var height: CGFloat;
	var radius: CGFloat;
	var spacing: CGFloat;
	var mouthRotate: Double;
	var eyeRotate: Double;
	var text: String;
	var bgcolor: Color;
	var hintcolor: Color;
};

enum FaceState {
	case sad;
	case happy;
	case soso;

	var value: FaceValue {
		switch self {
			case .happy:
				return FaceValue(
					width: 128,
					height: 128,
					radius: 64,
					spacing: 16,
					mouthRotate: 180,
					eyeRotate: 0,
					text: "GOOD",
					bgcolor: Color(hex: "AABA60"),
					hintcolor: Color(hex: "9EA47E")
				);
			case .soso:
				return FaceValue(
					width: 128,
					height: 48,
					radius: 64,
					spacing: 24,
					mouthRotate: 0,
					eyeRotate: 0,
					text: "NOT BAD",
					bgcolor: Color(hex: "D2A44D"),
					hintcolor: Color(hex: "AC9A75")
				);
			case .sad:
				return FaceValue(
					width: 64,
					height: 64,
					radius: 64,
					spacing: 48,
					mouthRotate: 0,
					eyeRotate: 45,
					text: "BAD",
					bgcolor: Color(hex: "E68469"),
					hintcolor: Color(hex: "B38B80")
				);
		}
	}
};

struct MoodMouth: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path();

		let radius = min(rect.width / 4, rect.height);
		let center = CGPoint(x: rect.midX, y: rect.maxY);

		path.addArc(center: center, radius: radius, startAngle: Angle.degrees(210), endAngle: Angle.degrees(330), clockwise: false);

		return path;
	};
};

struct RatingView: View {
	@State private var faceTarget: FaceState = .happy;
	@State private var inputText: String = "";
	@State private var dragOffset: CGFloat = 150;

	@FocusState private var isTextFieldFocused: Bool;

	let sliderWidth: CGFloat = 300;
	let segmentCount: Int = 3;

	var body: some View {
		VStack {
			HStack {
				Button(action: {

				}) {
					ZStack {
						Circle()
							.foregroundColor(faceTarget.value.hintcolor)
							.animation(.easeInOut, value: isTextFieldFocused)

						Image(systemName: "xmark")
							.font(.system(size: 24))
							.foregroundColor(.black)
					}
				}
				.frame(width: 56)

				Spacer()

				Button(action: {

				}) {
					ZStack {
						Circle()
							.foregroundColor(faceTarget.value.hintcolor)
							.animation(.easeInOut, value: isTextFieldFocused)

						Image(systemName: "info.circle")
							.font(.system(size: 24))
							.foregroundColor(.black)
					}
				}
				.frame(width: 56)
			}
			.padding([.leading, .trailing], 32)

			Text("How was your shopping experience?")
				.padding([.top], isTextFieldFocused ? 0 : 32)
				.padding([.leading, .trailing], 32)
				.frame(maxHeight: isTextFieldFocused ? 0 : 96)
				.opacity(isTextFieldFocused ? 0 : 1)
				.animation(.easeInOut, value: isTextFieldFocused)
				.font(.title2)
				.multilineTextAlignment(.center)

			VStack {
				HStack(spacing: faceTarget.value.spacing) {
					ForEach(0..<2, id: \.self) { index in
						RoundedRectangle(cornerRadius: faceTarget.value.radius)
							.frame(width: faceTarget.value.width, height: faceTarget.value.height)
							.rotationEffect(Angle.degrees(index == 0 ? -1 : 1) * faceTarget.value.eyeRotate)
							.foregroundColor(.black.opacity(0.7))
					}
				}

				MoodMouth()
					.stroke(style: StrokeStyle(lineWidth: 16, lineCap: .round))
					.foregroundColor(.black.opacity(0.7))
					.frame(width: 100, height: 36)
					.rotationEffect(Angle.degrees(faceTarget.value.mouthRotate))
			}
			.padding([.top], 48)
			.frame(height: 200)

			Text(faceTarget.value.text)
				.foregroundColor(.black.opacity(0.7))
				.font(.system(size: 56))
				.fontWeight(.heavy)
				.kerning(-2)
				.opacity(isTextFieldFocused ? 0 : 1)
				.frame(maxHeight: isTextFieldFocused ? 0 : .infinity)
				.animation(.easeInOut, value: isTextFieldFocused)


			VStack(spacing: 12) {
				ZStack {
					RoundedRectangle(cornerRadius: 8)
						.fill(faceTarget.value.hintcolor)
						.frame(width: sliderWidth, height: 8)

					Circle()
						.fill(faceTarget.value.hintcolor)
						.offset(x: -150)
						.frame(width: 20, height: 20)
						.onTapGesture {
							withAnimation {
								faceTarget = .sad;
								dragOffset = -150;
							}
						}

					Circle()
						.fill(faceTarget.value.hintcolor)
						.frame(width: 20, height: 20)
						.onTapGesture {
							withAnimation {
								faceTarget = .soso;
								dragOffset = 0;
							}
						}

					Circle()
						.fill(faceTarget.value.hintcolor)
						.offset(x: 150)
						.frame(width: 20, height: 20)
						.onTapGesture {
							withAnimation {
								faceTarget = .happy;
								dragOffset = 150;
							}
						}

					ZStack {
						Circle()
							.fill(.black.opacity(0.7))
							.frame(width: 48, height: 48)

						MoodMouth()
							.stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
							.foregroundColor(.white)
							.frame(width: 48, height: 16)
							.rotationEffect(Angle.degrees(faceTarget == .happy ? 180 : 0))
					}
					.offset(x: dragOffset)
					.frame(width: 48, height: 48)
					.gesture(
						DragGesture()
							.onChanged { value in
								withAnimation {
									let value = dragOffset + (value.translation.width / 16);

									dragOffset = min(max(value, -sliderWidth / 2), sliderWidth / 2);
									faceTarget = round(dragOffset / 150) == 0 ? .soso : dragOffset > 0 ? .happy : .sad;
								};
							}
							.onEnded { _ in
								let width = sliderWidth / CGFloat(segmentCount - 1);

								withAnimation {
									dragOffset = round(dragOffset / width) * width;
								};
							}
					)
				}

				HStack {
					Text("Bad")
						.frame(width: 80)
						.font(.body)
						.fontWeight(.bold)

					Spacer()

					Text("Not bad")
						.frame(width: 80)
						.font(.body)
						.fontWeight(.bold)

					Spacer()

					Text("Good")
						.frame(width: 80)
						.font(.body)
						.fontWeight(.bold)
				}
				.frame(width: sliderWidth + 80)
			}
			.padding()
			.frame(maxHeight: isTextFieldFocused ? 0 : .infinity)
			.opacity(isTextFieldFocused ? 0 : 1)
			.animation(.easeInOut, value: isTextFieldFocused)

			ZStack(alignment: .topLeading) {
				if inputText.isEmpty {
					Text("Add note.")
						.foregroundColor(.black.opacity(0.5))
						.padding(.horizontal, 20)
						.frame(maxHeight: isTextFieldFocused ? 72 : 80, alignment: .leading)
						.allowsHitTesting(false)
				}

				TextEditor(text: $inputText)
					.padding()
					.focused($isTextFieldFocused)
					.scrollContentBackground(.hidden)
					.frame(maxHeight: isTextFieldFocused ? .infinity : 80)
					.onTapGesture {
						isTextFieldFocused = true;
					}

				VStack {
					Spacer()

					HStack {
						Spacer()
						Button(action: {
							withAnimation {
								isTextFieldFocused.toggle()
							}
						}) {
							HStack {
								Text("Submit")
									.foregroundColor(.white)

								Image(systemName: "arrow.right")
									.foregroundColor(.white)
							}
							.frame(height: 56)
							.padding([.leading, .trailing], 24)
							.background(.black.opacity(0.7))
							.cornerRadius(28)
						}
					}
					.padding(.trailing, isTextFieldFocused ? 8 : 0)
					.padding(.bottom, isTextFieldFocused ? 8 : 12)
				}
			}
			.frame(height: isTextFieldFocused ? .infinity : 56)
			.animation(.easeInOut, value: isTextFieldFocused)
			.background(faceTarget.value.hintcolor)
			.cornerRadius(28)
			.padding(32)

			Spacer()
		}
		.background(faceTarget.value.bgcolor)
	}
}

#Preview {
	RatingView()
		.modelContainer(for: Item.self, inMemory: true)
}

