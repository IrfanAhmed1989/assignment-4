// CSC6033 - Week 4 - Project P#4
// Student: Irfan Ahmed
// Title: DFA implementation for the regular expression: (a(a|b)*) | (bb(a)*)
// Course: Languages, Automata, and Decidability (CSC6033)
//
// Description
//   This program implements a deterministic finite automaton (DFA) equivalent to
//   the regex (a(a|b)*) | (bb(a)*), over the alphabet Σ = { a, b }.
//   Accepted language L = aΣ*  ∪  bba*.
//
// DFA States
//   Start : initial
//   A     : accepting (strings that started with 'a')
//   B1    : saw one leading 'b'
//   BB    : accepting (saw leading "bb"; only 'a' allowed afterwards)
//   Dead  : rejecting sink for any invalid path/character
//
// Transitions
//   State  |  'a'   |  'b'   | Accepting?
//   --------------------------------------
//   Start  |   A    |  B1    |   no
//   A      |   A    |   A    |   yes
//   B1     |  Dead  |  BB    |   no
//   BB     |   BB   |  Dead  |   yes
//   Dead   |  Dead  |  Dead  |   no
//
// Build:
//   g++ -std=c++17 -O2 -Wall -Wextra -pedantic -o p4_fsa main.cpp
// Run:
//   ./p4_fsa <string>
//   # or run without arguments and enter a string when prompted

#include <iostream>
#include <string>

class FSA {
public:
    enum class State { Start, A, B1, BB, Dead };

    void reset() { state_ = State::Start; }

    // Process a single character from Σ = { 'a', 'b' }.
    void process(char c) {
        switch (state_) {
            case State::Start:
                if (c == 'a')      state_ = State::A;   // branch: aΣ*
                else if (c == 'b') state_ = State::B1;  // first 'b' seen
                else               state_ = State::Dead;
                break;

            case State::A:
                // Once we've seen a leading 'a', any 'a' or 'b' keeps us in A.
                if (c == 'a' || c == 'b') state_ = State::A;
                else                      state_ = State::Dead;
                break;

            case State::B1:
                // We must see a second 'b' to match the prefix "bb".
                if (c == 'b')      state_ = State::BB;
                else if (c == 'a') state_ = State::Dead;
                else               state_ = State::Dead;
                break;

            case State::BB:
                // After "bb", only 'a' is allowed (for bba*).
                if (c == 'a')      state_ = State::BB;
                else if (c == 'b') state_ = State::Dead;
                else               state_ = State::Dead;
                break;

            case State::Dead:
                // Remain in the sink on any further input.
                state_ = State::Dead;
                break;
        }
    }

    // Decide acceptance for an entire word.
    bool accepts(const std::string& word) {
        reset();
        for (char c : word) process(c);
        return is_accepting();
    }

    bool is_accepting() const {
        return state_ == State::A || state_ == State::BB;
    }

private:
    State state_ { State::Start };
};

int main(int argc, char** argv) {
    std::ios::sync_with_stdio(false);
    std::cin.tie(nullptr);

    std::string s;
    if (argc >= 2) {
        s = argv[1];
    } else {
        std::cout << "Enter a string over {a,b}: ";
        if (!std::getline(std::cin, s)) return 0;
    }

    FSA dfa;
    const bool ok = dfa.accepts(s);
    std::cout << (ok ? "ACCEPT" : "REJECT") << "\n";
    return 0;
}
