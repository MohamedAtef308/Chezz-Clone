# Chezz-Clone
A clone of the popular **Chezz** game made with **8086 assembly language.**

## Game Logic
The game consists of two players competing with white and black chess pieces, each attempting to capture the other player's king to win. Unlike traditional chess, players do not take turns; instead, there is a three-second cooldown for each piece.

## Features
- Main menu for entering a username and sending game or chat invitations
- Main game mode
- Chat mode
- In-game chat
- Alert bar to notify when the king is in check
- Power-up that can reduce the cooldown to two seconds instead of three seconds (marked by a brown square)

---

## Phase 1
This version was the first building block, containing the core logic of the game. It was playable by two players, with player 1 using the arrow keys and enter to move pieces, and player 2 using WASD and space to move pieces. Players could press "c" to enter the in-game chat and "r" to send a message.

---

## Phase 2
This version represents a significant upgrade to the game, as it included real multiplayer functionality using the communication registers in the 8086 to send and receive moves from players during the game. A main menu was added, allowing users to enter their username and wait for another player to connect before choosing to play a Chezz match or chat with one another. Additionally, the in-game chat was made more realistic. An important feature added was the cooldown idinticator to show if the piece is in cool down or ready to be moved

---

## Run Instructions
1. Install DOSBox and MASM
2. masm Phase1.asm
3. link Phase1.obj
4. Phase1

Do the same for Phase 2 to run it