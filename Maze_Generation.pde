// Maze Generation using Depth First Search
// by https://github.com/7ubi
// Sources:
// https://www.algosome.com/articles/maze-generation-depth-first.html
// https://en.wikipedia.org/wiki/Maze_generation_algorithm
import java.util.Stack;

final int rows = 25;
final int cols = 25;
final boolean animated = true;

Cell[][] cells;
Stack<Cell> path;
Cell current;

void setup(){
  size(600, 600);
  
  cells = new Cell[rows][cols];
  for(int x = 0; x < rows; x++){
    for(int y = 0; y < cols; y++){
      cells[x][y] = new Cell(x, y);
    }
  }
  
  path = new Stack<Cell>();
  current = cells[0][0];
  current.visited = true;
  path.add(current);
  
  if(!animated){
    while(true){
      if(generate())break; 
    }
  }
}

void draw(){
  background(53);
  
  if(animated){
    current.setHighlight(true);
    display();
    generate();
  }else{
    display();
  }
}

boolean generate(){
  //GET NEXT CELL
  Cell next = current.getNeighbor();
  current.setHighlight(false);
  
  if(next != null){
    removeWalls(current, next);
    current = next;
    current.visited = true;
    path.add(current);
  }else{
    if(!path.isEmpty()){
      current = path.pop();
    }else{
      //MAZE DONE
      return true;
    }
  }
  return false;
}

void display(){
  //DISPLAY ALL CELLS
  for(int x = 0; x < cells.length; x++){
    for(int y = 0; y < cells[x].length; y++){
      cells[x][y].show();
    }
  }
}

void removeWalls(Cell cur, Cell nex){
  if(cur.getI() - nex.getI() == 1){
    cur.walls[3] = false;
    nex.walls[1] = false;
  }else if(cur.getI() - nex.getI() == -1){
    cur.walls[1] = false;
    nex.walls[3] = false;
  }
  
  if(cur.getJ() - nex.getJ() == 1){
    cur.walls[0] = false;
    nex.walls[2] = false;
  }else if(cur.getJ() - nex.getJ() == -1){
    cur.walls[2] = false;
    nex.walls[0] = false;
  }
}

void keyPressed(){
  if(key == 'p' || key == 'P'){
    saveFrame("maze-####.png");
  }
}
