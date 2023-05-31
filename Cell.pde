public class Cell {
  private int numAdjacent;
  private boolean revealed;
  private boolean flagged;
  
  public Cell() {
    revealed = false;
    flagged = false;
    revealed = false;
  }
  
  public void setAdjacent(int adjacent) {
    numAdjacent = adjacent;
  }
  
  public int getAdjacent() {
    return numAdjacent;
  }
  
  public void reveal() {
    revealed = true;
}

  public void flag() {
    if (flagged)
      flagged = false;
    else
      flagged = true;
  }
  
  public boolean isMine() {
    return numAdjacent == -1;
  }
  
  public boolean isFlagged() {
    return flagged;
  }
  
  public boolean isRevealed() {
    return revealed;
  }
}
