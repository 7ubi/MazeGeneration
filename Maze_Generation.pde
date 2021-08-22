// Maze Generation using Depth First Search
// by https://github.com/7ubi
// Sources:
// https://www.algosome.com/articles/maze-generation-depth-first.html
// https://en.wikipedia.org/wiki/Maze_generation_algorithm
// https://en.wikipedia.org/wiki/A*_search_algorithm
import java.util.Stack;

final int rows = 12;
final int cols = 12;
int cellWidth;
int cellHeight;
final boolean animated = false;

boolean generated = false;

Cell[][] cells;
Stack<Cell> path;
Cell current;

// Path finding
boolean pathCalculated = false;
Cell start = null;
Cell end = null;
ArrayList<Cell> openList;
ArrayList<Cell> closedList;
ArrayList<Cell> pathList;

void setup(){
  size(600, 600);
  
  cellWidth = width / rows;
  cellHeight = height / cols;
  
  pathList = new ArrayList<Cell>();
  openList = new ArrayList<Cell>();
  closedList = new ArrayList<Cell>();
  
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
  
  if(generated){
    display();
    hoverCell();
    
    //draw path if a path was calculated
    if(pathCalculated){
      for(Cell cell: pathList){
        noStroke();
        fill(168, 111, 30);
        rect(cell.x, cell.y, cellWidth, cellHeight);
      }
    }
    
    //draw start
    if(start != null){
      noStroke();
      fill(50, 168, 82);
      rect(start.x, start.y, cellWidth, cellHeight);
    }
    //draw end
    if(end != null){
      noStroke();
      fill(156, 48, 52);
      rect(end.x, end.y, cellWidth, cellHeight);
    }
    
    
    displayWalls();
  }else if(animated){
    if(!generate())current.setHighlight(true);
    display();
    displayWalls();
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
      generated = true;
      return true;
    }
  }
  return false;
}

void hoverCell(){
  int x = mouseX - mouseX % cellWidth;
  int y = mouseY - mouseY % cellHeight;
  
  noStroke();
  fill(255, 255, 255, 50);
  rect(x, y, cellWidth, cellHeight);
}

void calculatePath(){
  while(openList.size() > 0){
      //get Cell with lowest F
      Cell current = openList.get(0);
      
      for(Cell cell : openList){
        if(cell.f < current.f){
          current = cell;
        }
      }
      
      if(current == end){
        createPath(current);
        pathCalculated = true;
        return;
      }
      
      openList.remove(current);
      closedList.add(current);
      
      //add neighbors 
      for(Cell cell: current.getPathNeighbor()){
        if(closedList.contains(cell)) continue;
        float g = current.g + 
        dist(current.x, current.y, cell.x, cell.y);   
        
        boolean newPath = false;
        if(openList.contains(cell)){
          if(g < cell.g){
            cell.g = g;
            newPath = true;
          }
        }else{
          cell.g = g;
          openList.add(cell);
          newPath = true;
        }
        
        if(newPath){
          cell.calculateCost(current);
        }
      }
    }
}

void createPath(Cell current){
  pathList.clear();
  while(current.parent != null){
    pathList.add(current.parent);
    current = current.parent;
  }
}

void keyPressed(){
  //SAVE IMAGE OF MAZE
  if(generated){
    if(key == 'p' || key == 'P'){
      saveFrame("maze-####.png");
    }
  }
  
  if(key == ' ' && start != null && end != null){
    calculatePath();
  }
}

void mousePressed(){
  int x = mouseX - mouseX % (width/rows);
  int y = mouseY - mouseY % (height/cols);
  int i = x / (width/rows);
  int j = y / (height/cols);
  
  if(mouseButton == LEFT){
    //set start
    start = cells[i][j];
    resetAstar();
    
    if(pathCalculated){
      calculatePath();
    }
  }
  
  if(mouseButton == RIGHT){
    //set end
    end = cells[i][j];
    if(pathCalculated){
      resetAstar();
      calculatePath();
    }
  }
}

void resetAstar(){
  openList.clear();
  openList.add(start);
  closedList.clear();
  for(int x = 0; x < cells.length; x++){
    for(int y = 0; y < cells[x].length; y++){
      cells[x][y].resetAstar();
    }
  }
}
