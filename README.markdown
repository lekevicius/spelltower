# SpellTower Solver

[SpellTower](http://spelltower.com/) is an iOS word search game by [Zach Gage](http://www.stfj.net/). This is a solver that tries to find the best words available, and help you get better scores.

Currently it works only in tower mode, and finds first word only. However, that was enough to bring me to Top 5% on Game Center :)

Usage:

* Take screenshot of your Tower Mode game with new board
* Put that screenshot into main directory of this project and name it `input.png`. The best way to transfer the screenshot is via PasteBot, because it doesn't convert screenshot to JPG and no quality is lost.
* Execute `ruby main.rb`
* You will get top 10 words, with ASCII graphics that help you find it on the board.
