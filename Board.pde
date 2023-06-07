public class Board {

  private int rows;
  private int columns;
  private Cell[][] cells;
  
  public Board (int r, int c) {
    rows = r;
    columns = c;
    cells = new Cell[r][c];
    
    for(int i = 0; i < r; i++) {
      for(int j = 0; j < c; j++) {
      cells[i][j] = new Cell();
      }
    }
  }
  
  public Cell getCell (int l, int w) {
    return cells[l][w];
  }
  
  public boolean gameWon() {
    boolean won = true;
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < columns; j++) {
        if(!cells[i][j].isMine()) {
          if(!cells[i][j].isRevealed())
          won = false;
        }
      }
    }
    return won;
  }
  
}
