import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Sudoku'),
        ),
        body: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                for (int row = 0; row < 9; row++)
                  Container(
                    margin: EdgeInsets.only(top: row % 3 == 0 ? 8 : 2),
                    child: Row(
                      children: <Widget>[
                        for (int column = 0; column < 9; column++)
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: column % 3 == 0 ? 8 : 2),
                              width: MediaQuery.of(context).size.width / 10,
                              height: MediaQuery.of(context).size.width / 10,
                              decoration: BoxDecoration(
                                color: selectedRow == row &&
                                        selectedColumn == column
                                    ? Colors.green
                                    : Colors.purple[800],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '${grid[row][column] == 0 ? '' : grid[row][column]}',
                                  style: TextStyle(
                                    color:
                                        isValid(grid[row][column], row, column)
                                            ? Colors.white
                                            : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              selectedRow = row;
                              selectedColumn = column;

                              setState(() {});
                            },
                          )
                      ],
                    ),
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 150,
                width: 150,
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children: List<Widget>.generate(
                    9,
                    (int index) => RaisedButton(
                      color: Colors.amber,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        if (selectedRow != -1 && selectedColumn != -1) {
                          grid[selectedRow][selectedColumn] = index + 1;
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  List<List<int>> grid = <List<int>>[
    <int>[5, 3, 0, 0, 7, 0, 0, 0, 0],
    <int>[6, 0, 0, 1, 9, 5, 0, 0, 0],
    <int>[0, 9, 8, 0, 0, 0, 0, 6, 0],
    <int>[8, 0, 0, 0, 6, 0, 0, 0, 3],
    <int>[4, 0, 0, 8, 0, 3, 0, 0, 1],
    <int>[7, 0, 0, 0, 2, 0, 0, 0, 6],
    <int>[0, 6, 0, 0, 0, 0, 2, 8, 0],
    <int>[0, 0, 0, 4, 1, 9, 0, 0, 5],
    <int>[0, 0, 0, 0, 8, 0, 0, 7, 9],
  ];

  int selectedRow = -1;
  int selectedColumn = -1;

  bool validate(int value, List<int> numbers) {
    int count = 0;

    for (final int number in numbers) {
      if (value == number) {
        count++;
      }
    }

    return count < 2;
  }

  bool isRowValid(int value, int rowNumber) => validate(value, grid[rowNumber]);

  bool isColumnValid(int value, int columnNumber) {
    final List<int> values = <int>[];

    for (int i = 0; i < grid.length; i++) {
      values.add(grid[i][columnNumber]);
    }

    return validate(value, values);
  }

  bool isBoxValid(int value, int rowNumber, int columnNumber) {
    final int baseRow = (rowNumber ~/ 3) * 3;
    final int baseColumn = (columnNumber ~/ 3) * 3;

    int count = 0;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (grid[baseRow + i][baseColumn + j] == value) {
          count++;
        }
      }
    }

    return count < 2;
  }

  bool hasEmpty() {
    for (int i = 0; i < grid.length; i++) {
      for (int j = 0; j < grid[i].length; j++) {
        if (grid[i][j] == 0) {
          return true;
        }
      }
    }

    return false;
  }

  bool isValid(int value, int row, int column) =>
      isRowValid(value, row) &&
      isColumnValid(value, column) &&
      isBoxValid(value, row, column);

  void solve() {
    if (!hasEmpty()) {
      return;
    }

    printGrid();

    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (grid[i][j] == 0) {
          for (int k = 1; k < 10; k++) {
            if (isRowValid(k, i) &&
                isColumnValid(k, j) &&
                isBoxValid(k, i, j)) {
              grid[i][j] = k;

              if (hasEmpty()) {
                solve();
              }

              grid[i][j] = 0;
            }
          }
        }
      }
    }
  }

  void printGrid() {
    for (int i = 0; i < grid.length; i++) {
      print(grid[i]);
    }

    print('\n\n\n');
  }
}
