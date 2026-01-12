import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF0B6E99);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: seedColor.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
        ),
      ),
      home: const TicTacToePage(),
    );
  }
}

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  static const List<List<int>> _winningLines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  final List<String> _board = List.filled(9, '');
  bool _xTurn = true;
  bool _startingX = true;
  String? _winner;
  bool _isDraw = false;
  List<int>? _winningLine;
  int _xWins = 0;
  int _oWins = 0;
  int _draws = 0;

  void _handleTap(int index) {
    if (_board[index].isNotEmpty || _winner != null || _isDraw) {
      return;
    }

    setState(() {
      _board[index] = _xTurn ? 'X' : 'O';
      _winningLine = _findWinningLine();
      if (_winningLine != null) {
        _winner = _board[index];
        if (_winner == 'X') {
          _xWins++;
        } else {
          _oWins++;
        }
        return;
      }

      if (_board.every((cell) => cell.isNotEmpty)) {
        _isDraw = true;
        _draws++;
        return;
      }

      _xTurn = !_xTurn;
    });
  }

  List<int>? _findWinningLine() {
    for (final line in _winningLines) {
      final value = _board[line[0]];
      if (value.isNotEmpty &&
          value == _board[line[1]] &&
          value == _board[line[2]]) {
        return line;
      }
    }
    return null;
  }

  void _startNewRound() {
    setState(() {
      for (var i = 0; i < _board.length; i++) {
        _board[i] = '';
      }
      _winner = null;
      _isDraw = false;
      _winningLine = null;
      _startingX = !_startingX;
      _xTurn = _startingX;
    });
  }

  void _resetScores() {
    setState(() {
      _xWins = 0;
      _oWins = 0;
      _draws = 0;
      _startingX = true;
      _xTurn = _startingX;
      _winner = null;
      _isDraw = false;
      _winningLine = null;
      for (var i = 0; i < _board.length; i++) {
        _board[i] = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusText = _winner != null
        ? '${_winner!} wins'
        : _isDraw
            ? 'Draw game'
            : _xTurn
                ? "X's turn"
                : "O's turn";
    final statusColor = _winner != null
        ? colorScheme.primary
        : _isDraw
            ? colorScheme.tertiary
            : colorScheme.onSurface;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.surface,
              colorScheme.surfaceVariant.withOpacity(0.8),
              colorScheme.primary.withOpacity(0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final boardSize =
                  constraints.maxWidth < 520 ? constraints.maxWidth : 520.0;
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 28,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Tic Tac Toe',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Play quick rounds and keep the streak going.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 24),
                        _ScoreRow(
                          xWins: _xWins,
                          oWins: _oWins,
                          draws: _draws,
                        ),
                        const SizedBox(height: 28),
                        Center(
                          child: SizedBox(
                            width: boardSize,
                            height: boardSize,
                            child: _GameBoard(
                              board: _board,
                              winningLine: _winningLine,
                              onTap: _handleTap,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _winner != null
                                        ? Icons.emoji_events_outlined
                                        : _isDraw
                                            ? Icons.draw_outlined
                                            : Icons.sports_esports_outlined,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    statusText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: statusColor,
                                        ),
                                  ),
                                ),
                                if (_winner != null || _isDraw)
                                  FilledButton(
                                    onPressed: _startNewRound,
                                    child: const Text('Play again'),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            FilledButton.icon(
                              onPressed: _startNewRound,
                              icon: const Icon(Icons.refresh),
                              label: const Text('New round'),
                            ),
                            OutlinedButton.icon(
                              onPressed: _resetScores,
                              icon: const Icon(Icons.restart_alt),
                              label: const Text('Reset score'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({
    required this.xWins,
    required this.oWins,
    required this.draws,
  });

  final int xWins;
  final int oWins;
  final int draws;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ScoreCard(
            label: 'Player X',
            value: xWins,
            color: Theme.of(context).colorScheme.primary,
            icon: Icons.close,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ScoreCard(
            label: 'Draws',
            value: draws,
            color: Theme.of(context).colorScheme.tertiary,
            icon: Icons.balance,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ScoreCard(
            label: 'Player O',
            value: oWins,
            color: Theme.of(context).colorScheme.secondary,
            icon: Icons.circle_outlined,
          ),
        ),
      ],
    );
  }
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final int value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value.toString(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameBoard extends StatelessWidget {
  const _GameBoard({
    required this.board,
    required this.winningLine,
    required this.onTap,
  });

  final List<String> board;
  final List<int>? winningLine;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: colorScheme.outlineVariant,
          ),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: board.length,
          itemBuilder: (context, index) {
            final value = board[index];
            final isWinner =
                winningLine != null && winningLine!.contains(index);
            final accent = value == 'X'
                ? colorScheme.primary
                : value == 'O'
                    ? colorScheme.secondary
                    : colorScheme.outline;
            return _BoardTile(
              value: value,
              accent: accent,
              isWinner: isWinner,
              onTap: () => onTap(index),
            );
          },
        ),
      ),
    );
  }
}

class _BoardTile extends StatelessWidget {
  const _BoardTile({
    required this.value,
    required this.accent,
    required this.isWinner,
    required this.onTap,
  });

  final String value;
  final Color accent;
  final bool isWinner;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: isWinner
          ? accent.withOpacity(0.15)
          : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: value.isEmpty ? onTap : null,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeIn,
            child: Text(
              value,
              key: ValueKey(value),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
