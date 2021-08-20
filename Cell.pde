class Cell{
  private int x;
  private int y;
  private int i;
  private int j;
  public boolean[] walls = {true, true, true, true};
  private boolean visited = false;
  private boolean highlight = false;
  
  Cell(int i, int j){
    this.i = i;
    this.j = j;
    
    x = i * cellSize;
    y = j * cellSize;
  }
  
  Cell getNeighbor(){
    ArrayList<Cell> neighbor = new ArrayList<Cell>();
    
    if(i - 1 >= 0){
      if(!cells[i - 1][j].visited) neighbor.add(cells[i - 1][j]);
    }
    if(j - 1 >= 0){
      if(!cells[i][j - 1].visited) neighbor.add(cells[i][j - 1]);
    }
    if(i + 1 < width / cellSize){
      if(!cells[i + 1][j].visited) neighbor.add(cells[i + 1][j]);
    }
    if(j + 1 < height / cellSize){
      if(!cells[i][j + 1].visited) neighbor.add(cells[i][j + 1]);
    }
    
    return neighbor.size() > 0 ? neighbor.get(
    (int) random(neighbor.size())) : null;
  }
  
  void show(){
    //DRAW CELL
    if(highlight){
      fill(53, 122, 64);
      noStroke();
      rect(x, y, cellSize, cellSize);
    }else if(visited){
      fill(40, 75, 99);
      noStroke();
      rect(x, y, cellSize, cellSize);
    }
    
    //DRAW WALLS
    strokeWeight(1);
    stroke(255);
    //up
    if(walls[0]){
      line(x, y, x + cellSize, y);
    }
    //right
    if(walls[1]){
      line(x + cellSize, y, x + cellSize, y + cellSize);
    }
    //down
    if(walls[2]){
      line(x, y + cellSize, x + cellSize, y + cellSize);
    }
    //left
    if(walls[3]){
      line(x, y, x, y + cellSize);
    }
  }
  
  void setHighlight(boolean val){
    highlight = val;
  }
  
  int getI(){
    return i;
  }
  
  int getJ(){
    return j;
  }
}
