//
//  Home.swift
//  TripWise
//
//  Created by Edoardo Pavan on 03/01/25.
//
import SwiftUI

struct HomeView: View {
    @Environment(NavigationRouter<HomeNavigationPages>.self) private var homeRouter
    @State private var viewModel = HomeViewModel()

    var body: some View {
        @Bindable var homeRouter = self.homeRouter
        @Bindable var viewModel = self.viewModel
        
        NavigationStack(path: $homeRouter.navigationPath) {
            ZStack(alignment: .top) {
                if viewModel.activeStep >= 1 {
                    ProgressBarView(activeStep: viewModel.activeStep, totalSteps: viewModel.totalSteps)
                }
                VStack(spacing: 35) {
                    switch viewModel.activeStep {
                    case 0:
                        cityStep.tag(0)
                    case 1:
                        daysStep.tag(1)
                    case 2:
                        peopleStep.tag(2)
                    default:
                        EmptyView()
                    }
                    nextButton
                }
                .padding(.horizontal, 20)
                .frame(maxHeight: .infinity)
            }
            .navigationDestination(for: HomeNavigationPages.self) { page in
                switch page {
                case .trip:
                    if let trip = viewModel.generatedTrip {
                        TripView(trip: trip)
//                        { activities in
//                            homeRouter.navigate(to: .map(activities))
//                        }
                    }
                case .map(let activities):
                    EmptyView()
//                    MapView(activities: activities)
                }
            }
        }
    }
    
    private var cityStep: some View {
        VStack(spacing: 35) {
            Text("Where do you want to go?")
                .font(.title2)
            HStack {
                Image(systemName: "magnifyingglass.circle.fill")
                    .resizable()
                    .foregroundStyle(.black)
                    .frame(width: 25, height: 25)
                    .padding([.top, .leading, .bottom])
                TextField("City", text: $viewModel.city, prompt: Text("Enter a city"))
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .background {
                Capsule()
                    .stroke(.gray, lineWidth: 1)
            }
        }
    }
    
    private var daysStep: some View {
        VStack(spacing: 35) {
            Text("When are you going?")
                .font(.title2)
                .bold()
            TagView(
                tags: [
                    TagViewItem(title: "January", isSelected: true),
                    TagViewItem(title: "February"),
                    TagViewItem(title: "March"),
                    TagViewItem(title: "April"),
                    TagViewItem(title: "May"),
                    TagViewItem(title: "June"),
                    TagViewItem(title: "July"),
                    TagViewItem(title: "August"),
                    TagViewItem(title: "September"),
                    TagViewItem(title: "October"),
                    TagViewItem(title: "November"),
                    TagViewItem(title: "December")
                ]
            )
            HStack {
                Text("Days?")
                    .font(.title3)
                Spacer()
                Picker("Days", selection: $viewModel.days) {
                    ForEach(1...15, id: \.self) { day in
                        Text("\(day)")
                    }
                }
                .pickerStyle(.menu)
            }
        }
    }
    
    private var peopleStep: some View {
        VStack(spacing: 35) {
            Text("How many people?")
                .font(.title2)
                .bold()
            HStack {
                Text("People?")
                    .font(.title3)
                Spacer()
                Picker("People", selection: $viewModel.people) {
                    ForEach(1...8, id: \.self) { count in
                        Text("\(count)")
                    }
                }
                .pickerStyle(.menu)
            }
            Toggle(isOn: $viewModel.withKids) {
                Text("Are you travelling with kids?")
                    .font(.title3)
            }
            .padding(.trailing, 5)
        }
    }
    
    private var nextButton: some View {
        Button {
            if viewModel.activeStep == viewModel.totalSteps {
                Task {
                    await viewModel.submit()
                }
            } else {
                withAnimation {
                    viewModel.activeStep += 1
                }
            }
        } label: {
            Text(viewModel.activeStep == viewModel.totalSteps ? "Submit" : "Next")
                .foregroundStyle(.white)
                .padding()
        }
        .disabled(viewModel.activeStep == 0 && viewModel.city.isEmpty)
        .background {
            Capsule()
                .fill(.black)
        }
        .disabled(viewModel.loading)
        .redactAndShimmer(active: viewModel.loading)
        .opacity(viewModel.activeStep == 0 && viewModel.city.isEmpty ? 0.7 : 1)
        .padding(.bottom, 50)
        .onChange(of: viewModel.showTrip) { _, newValue in
            if newValue {
                homeRouter.navigate(to: .trip)
                viewModel.activeStep = 0
            }
        }
    }
}

private struct ProgressBarView: View {
    let activeStep: Int
    let totalSteps: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0...totalSteps, id: \.self) { step in
                VStack(spacing: 4) {
                    Text("\(step + 1)")
                        .bold()
                    Circle()
                        .stroke(.black, lineWidth: 2)
                        .frame(width: 15, height: 15)
                        .overlay {
                            Circle()
                                .fill(step <= activeStep ? .black : .white)
                                .frame(width: 10, height: 10)
                        }
                }
                if step < totalSteps {
                    Rectangle()
                        .fill(.black)
                        .frame(height: 4)
                        .offset(y: 13)
                }
            }
        }
        .padding(25)
    }
}

private struct TagView: View {
    @State var tags: [TagViewItem]
    @State private var totalHeight = CGFloat.zero
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return ZStack(alignment: .topLeading) {
            ForEach(tags.indices) { index in
                Button {
                    if let oldIndex = tags.firstIndex(where: {$0.isSelected == true}) {
                        tags[oldIndex].isSelected = false
                    }
                    tags[index].isSelected.toggle()
                } label: {
                    Text(tags[index].title)
                        .foregroundColor(tags[index].isSelected ? .white : .black)
                        .padding()
                        .lineLimit(1)
                        .background(tags[index].isSelected ? .black : .white)
                        .frame(height: 36)
                        .cornerRadius(18)
                        .overlay(Capsule().stroke(.black, lineWidth: 1))
                }
                .padding([.horizontal, .vertical], 4)
                .alignmentGuide(.leading, computeValue: { d in
                    if (abs(width - d.width) > g.size.width) {
                        width = 0
                        height -= d.height
                    }
                    let result = width
                    if tags[index].title == self.tags.last!.title {
                        width = 0 //last item
                    } else {
                        width -= d.width
                    }
                    return result
                })
                .alignmentGuide(.top, computeValue: {d in
                    let result = height
                    if tags[index].title == self.tags.last!.title {
                        height = 0 // last item
                    }
                    return result
                })
            }
        }.background(viewHeightReader($totalHeight))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
