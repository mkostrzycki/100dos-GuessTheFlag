//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by MaćKo on 26/03/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var userAnswer = 0

    @State private var userScore = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""

    private let maxRound = 8
    @State private var round = 1
    @State private var isGameOver = false

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                Spacer()

                VStack(spacing: 20) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.primary)
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .clipShape(.rect(cornerRadius: 20))
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 20))

                Spacer()

                Text("Score: \(userScore)")
                    .font(.title.bold())
                    .foregroundStyle(.white)
                Text("Round: \(round) of \(maxRound)")
                    .font(.title.bold())
                    .foregroundStyle(.white)

                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text((scoreTitle == "Correct") ? "That's correct answer!" : "Wrong! That's the flag of \(countries[userAnswer]).")
        }
        .alert("Game Over", isPresented: $isGameOver) {
            Button("New Game", action: resetGame)
        } message: {
            Text("You finished \(maxRound) rounds. Your final score is: \(userScore)")
        }
    }

    func flagTapped(_ number: Int) {
        userAnswer = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong"
            userScore -= 1
        }

        showingScore = true
    }

    func askQuestion() {
        if round == maxRound {
            isGameOver = true
        } else {
            round += 1
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

    func resetGame() {
        userScore = 0
        round = 1
    }
}

#Preview {
    ContentView()
}
