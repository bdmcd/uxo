var Game = function(name, xPlayerName, oPlayerName, changed, gameOver, catsGame, saveGame) {
    Game.prototype.gameOver = function() {
        if (typeof gameOver == "function") { gameOver(); }
    }
    Game.prototype.catsGame = function() {
        if (typeof catsGame == "function") { catsGame(); }
    }
    Game.prototype.changed = function() {
        if (typeof changed == "function") { changed(); }
        if (saveGame || typeof saveGame == 'undefined') { this.save(); }
    }

    this.name = name;
    this.load(xPlayerName, oPlayerName);
}

Game.prototype = {
    fileName: function() {
        if (this.name.indexOf(':') === 0)
            return this.name;
        return "games/" + this.name + ".json"
    },
    winConditions: [7, 56, 448, 73, 146, 292, 273, 84],
    winCombos: { 7:[0,1,2], 56:[3,4,5], 448:[6,7,8], 73:[0,3,6], 146:[1,4,7], 292:[2,5,8], 273:[0,4,8], 84:[2,4,6] },
    load: function(xPlayerName, oPlayerName) {
        try {
            var data = JSON.parse(FileIO.read(this.fileName()))
            if (!this.correctFormat(data)) {
                throw "Incorrect Format";
            }
        } catch(e) { console.log(e); data = this.gameFormat(); }

        for (var key in data) {
            this[key] = data[key];
        }
        this.xPlayerName = xPlayerName || this.xPlayerName;
        this.oPlayerName = oPlayerName || this.oPlayerName;
        this.dateTime = new Date();
        this.changed();
    },
    save: function() {
        FileIO.write(this.fileName(), JSON.stringify(this));
    },
    squareSelected: function(boardIndex, squareIndex) {
        var current = this.board.boards[boardIndex];
        var next = this.board.boards[squareIndex];
        current.squares[squareIndex] = this.turn;

        this.updateFilled(current);
        this.updateEnabled(next);

        if (this.updateWinner(current, squareIndex)) {
            if ((this.winCombo = this.updateWinner(this.board, boardIndex))) {
                this.board.enabled = false;
                this.gameOver();
            }
        }

        if (this.isCatsGame()) {
            this.catsGame();
        }

        var dateTime = new Date();
        this[this.turn + "TotalTime"] += dateTime.getTime() - this.dateTime.getTime();

        this.dateTime = dateTime;
        this.turn = this.turn === "x" ? "o" : "x";
        this.changed();
    },
    updateFilled: function(current) {
        current.filled = true;
        for (var i = 0; i < current.squares.length; i++) {
            if (current.squares[i] !== 'x' && current.squares[i] !== 'o') {
                current.filled = false;
                break;
            }
        }
    },
    updateEnabled: function(next) {
        for (var i = 0; i < this.board.boards.length; i++) {
            this.board.boards[i].enabled = next.filled || next.winner !== '';
        }
        next.enabled = !next.filled;
    },
    updateWinner: function(board, index) {
        if (board.winner === "") {
            var scoreKey = this.turn + "Score"; //xScore, oScore
            board[scoreKey] += Math.pow(2, index);

            for (var i = 0; i < this.winConditions.length; i++) {
                var condition = this.winConditions[i];
                if ((condition & board[scoreKey]) === condition) {
                    board.winner = this.turn;
                    return this.winCombos[condition];
                }
            }
        }
    },
    isCatsGame: function() {
        var catsGame = true;
        var boards = this.board.boards;
        for (var i = 0; i < boards.length; i++) {
            catsGame = catsGame && (boards[i].filled || boards[i].winner !== "");
        }
        this.board.catsGame = catsGame;
        return catsGame;
    },
    gameFormat: function() {
       function inner() {
            var array = [];
            for (var i = 0; i < 9; i++) {
                array.push({ index: i, enabled: true, filled: false, catsGame: false, winner:"",
                               xScore:0, oScore:0, squares: ['','','','','','','','',''] })
            }
            return array;
        }

        return {
            turn: "x",
            xPlayerName: "X",
            oPlayerName: "O",
            xTotalTime: 0,
            oTotalTime: 0,
            board: {
                enabled: true,
                filled: false,
                winCombo: undefined,
                catsGame: false,
                winner: "",
                xScore: 0,
                oScore: 0,
                boards: inner()
            }
        }
    },
    correctFormat: function(data) {
        return data.hasOwnProperty("turn")
            && data.hasOwnProperty("xPlayerName")
            && data.hasOwnProperty("oPlayerName")
            && typeof data.board == "object"
            && data.board.hasOwnProperty("enabled")
            && data.board.hasOwnProperty("filled")
            && data.board.hasOwnProperty("winner")
            && data.board.hasOwnProperty("xScore")
            && data.board.hasOwnProperty("oScore")
            && data.board.hasOwnProperty("boards");
    },
    squaresPlayed: function(player) {
        var count = 0;
        var boards = this.board.boards;
        for (var i = 0; i < boards.length; i++) {
            var squares = boards[i].squares;
            for (var j = 0; j < squares.length; j++) {
                if (squares[j] === player) {
                    count++;
                }
            }
        }
        return count;
    },
    boardsWon: function(player) {
        var count = 0;
        var boards = this.board.boards;
        for (var i = 0; i < boards.length; i++) {
            if (boards[i].winner === player) {
                count++;
            }
        }
        return count;
    },
    shutouts: function(player) {
        var total = 0;
        var boards = this.board.boards;
        for (var i = 0; i < boards.length; i++) {
            var board = boards[i];
            if (board.winner === player) {
                var squares = board.squares;
                var shutout = true;
                for (var j = 0; j < squares.length; j++) {
                    if (squares[j] !== player && squares[j] !== '') {
                        shutout = false;
                        break;
                    }
                }
                total += shutout ? 1 : 0;
            }
        }
        return total;
    },
    averageTime: function(player) {
        var total = this[player + "TotalTime"];
        var count = this.squaresPlayed(player) || 1;
        return Math.floor(total/count);
    },

    stats: function(player) {
        var _this = this;
        var avg = _this.averageTime(player);

        return {
            squaresPlayed: {
                name: "Squares Won",
                value: _this.squaresPlayed(player)
            },
            boardsWon: {
                name: "Boards Won",
                value: _this.boardsWon(player),
            },
            shutouts: {
                name: "Shutouts",
                value: _this.shutouts(player)
            },
            averageTime: {
                name: "Average Time",
                value: avg
            }
        }
    }
}
