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
    
    x = i * width / rows;
    y = j * height / cols;
  }
  
  Cell getNeighbor(){
    ArrayList<Cell> neighbor = new ArrayList<Cell>();
    
    if(i - 1 >= 0){
      if(!cells[i - 1][j].visited) neighbor.add(cells[i - 1][j]);
    }
    if(j - 1 >= 0){
      if(!cells[i][j - 1].visited) neighbor.add(cells[i][j - 1]);
    }
    if(i + 1 < rows){
      if(!cells[i + 1][j].visited) neighbor.add(cells[i + 1][j]);
    }
    if(j + 1 < cols){
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
      rect(x, y, width / rows, height / cols);
    }else if(visited){
      fill(40, 75, 99);
      noStroke();
      rect(x, y, width / rows, height / cols);
    }
    
    //DRAW WALLS
    strokeWeight(1);
    stroke(255);
    //up
    if(walls[0]){
      line(x, y, x + width / rows, y);
    }
    //right
    if(walls[1]){
      line(x + width / rows, y, x + width / rows, y + height / cols);
    }
    //down
    if(walls[2]){
      line(x, y + height / cols, x + width / rows, y + height / cols);
    }
    //left
    if(walls[3]){
      line(x, y, x, y + height / cols);
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
