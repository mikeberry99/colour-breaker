# Colour Breaker

A cyberpunk-themed code-breaking puzzle game built entirely in Flutter, targeting the web as a client-side application. 

## Project Goals

This project was built as an experimental sandbox with two primary objectives:

1. **Agentic Coding Practice:** To practice using Google Antigravity (AGY) as an AI pair-programming assistant to build and structure a complete client-side application from scratch.
2. **Iterative Refinement:** Once the base game was functional, the secondary goal was to explore the friction (or lack thereof) when continuously refining the UI, implementing new features, and polishing a web application exclusively through AI collaboration.

## About the Game

**Colour Breaker** is inspired by classic mastermind mechanics but wrapped in a sleek, hacker-themed aesthetic. 

* **Objective:** Crack the system's hidden color code before you run out of attempts.
* **Mechanics:** Place color pegs into empty slots, submit your sequence, and analyze the feedback (correct colors in correct positions vs. correct colors in wrong positions) to deduce the final code.
* **Features:**
  * Multiple security levels (difficulties).
  * Session seeds for replaying or sharing specific puzzles.
  * Responsive web design optimized for various screen sizes.
  * Neon-lit, dark-mode aesthetic with custom animations and effects.

## Getting Started

To run the project locally, ensure you have Flutter installed.

```bash
# Get dependencies
flutter pub get

# Run on the web
flutter run -d chrome
```
