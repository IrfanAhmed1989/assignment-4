// CSC6033 - Week 4 - Project P#4
// DFA for the regex: (a(a|b)*) | (bb(a)*)
// Author: Irfan Ahmed (replace with your preferred name if needed)
// Build: g++ -std=c++17 -O2 -Wall -Wextra -pedantic -o p4_fsa p4_fsa.cpp
// Run:   ./p4_fsa <string>
//        or run without args and enter a string when prompted.

#include <bits/stdc++.h>
using namespace std;

class FSA {
public:
    enum class State { Start, A, B1, BB, Dead };

    FSA() { reset(); }

    void reset() { state = State::Start; }

    // Process one character from the alphabet { 'a', 'b' }.
    void process(char c) {
        switch (state) {
            case State::Start:
                if (c == 'a') state = State::A;          // branch 1: starts with 'a'
                else if (c == 'b') state = State::B1;    // saw first 'b'
                else state = State::Dead;                // out of alphabet
                break;

            case State::A:
                // Accepting sink for any continuation after leading 'a'
                if (c == 'a' || c == 'b') state = State::A;
                else state = State::Dead;
                break;

            case State::B1:
                if (c == 'b') state = State::BB;         // matched "bb"
                else if (c == 'a') state = State::Dead;  // "ba..." not allowed
                else state = State::Dead;
                break;

            case State::BB:
                if (c == 'a') state = State::BB;         // only more 'a' allowed
                else if (c == 'b') state = State::Dead;  // a 'b' after "bb" invalidates
                else state = State::Dead;
                break;

            case State::Dead:
                // Remain in Dead for any input
                state = State::Dead;
                break;
        }
    }

    // Decide acceptance for an entire word.
    bool accepts(const string& word) {
        reset();
        for (char c : word) process(c);
        return is_accepting();
    }

    // Helper to check if current state is accepting.
    bool is_accepting() const {
        return state == State::A || state == State::BB;
    }

    // Optional: expose current state name for debugging or teaching.
    static const char* state_name(State s) {
        switch (s) {
            case State::Start: return "Start";
            case State::A:     return "A";      // accepted (aΣ*)
            case State::B1:    return "B1";     // saw initial 'b'
            case State::BB:    return "BB";     // accepted (bb a*)
            case State::Dead:  return "Dead";
        }
        return "?";
    }

private:
    State state;
};

int main(int argc, char** argv) {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    string s;
    if (argc >= 2) {
        s = argv[1];
    } else {
        cout << "Enter a string over {a,b}: ";
        if (!getline(cin, s)) return 0;
    }

    FSA dfa;
    bool ok = dfa.accepts(s);

    cout << (ok ? "ACCEPT" : "REJECT") << "\n";

    // Uncomment to trace the run step-by-step:
    // dfa.reset();
    // cerr << "Start\n";
    // for (char c : s) {
    //     dfa.process(c);
    //     cerr << c << " -> " << FSA::state_name(*(FSA::State*)nullptr) << "\n"; // placeholder
    // }

    return 0;
}
