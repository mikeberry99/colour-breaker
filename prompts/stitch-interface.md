Create a clean, modern digital interface for a 5-slot Mastermind board game. The design should be vertical, intuitive, and use a dark mode aesthetic with vibrant neon accents for the colors. 

Please include the following structural components from top to bottom:

1. HEADER & HIDDEN SOLUTION ROW:
- At the very top, a prominent title "MASTERMIND".
- Directly below, a "Hidden Solution" row containing 5 circular slots. By default, these slots are locked, showing a padlock icon. This row should have a visual state indicating it "unlocks" and reveals the 5 correct colored circles only when the player wins.

2. HISTORICAL GUESSES LOG (THE BOARD):
- A vertical stack of rows representing previous guesses, moving from the bottom up.
- Each row consists of two main parts:
  a) A group of 5 large, empty circular slots that will hold the player's color guesses.
  b) A feedback cluster to the right of the 5 slots. The feedback cluster should be a mini-grid or circle of 5 smaller indicator dots. Show an example row where some dots are filled: Green dots for "correct color & correct position", and Yellow dots for "correct color but wrong position". Unused feedback dots remain empty/gray.

3. ACTIVE GUESS INPUT & CONTROLS (AT THE BOTTOM):
- An "Active Guess" row with 5 empty slots where the current selection is staged.
- Below the active guess, a "Color Palette" containing 6 distinct, brightly colored circles (e.g., Red, Blue, Green, Yellow, Purple, Orange) that the player clicks to fill the active slots.
- A prominent, stylized "SUBMIT GUESS" action button next to or below the palette to lock in the current guess.

Ensure the UI feels like a polished puzzle game with clear spacing, distinct separation between the history log and the active controls, and responsive-looking buttons.