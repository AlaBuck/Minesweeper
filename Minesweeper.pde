import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public int NUM_MINES = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
boolean isLost = false;
void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);
  Interactive.make(this);
  textSize(20);
  if(isLost){
    mousePressed();
  }
  mines = new ArrayList <MSButton>();
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r=0; r<NUM_ROWS; r++) {
    for (int c=0; c<NUM_COLS; c++) {
      buttons[r][c]= new MSButton(r, c);
    }
  }
  setMines();
}
public void setMines()
{
  while(mines.size()<NUM_MINES) {
  int r = (int)(Math.random()*(NUM_ROWS));
  int c = (int)(Math.random()*(NUM_COLS));
  if(!mines.contains(buttons[r][c])){
    mines.add(buttons[r][c]);
  }
}
}
public void displayWinningMessage()
{
    if(isWon()){
    isLost = true;
    fill(0,255,0);
    buttons[NUM_ROWS/2][(NUM_COLS/2)-4].setLabel("Y");
    buttons[NUM_ROWS/2][(NUM_COLS/2)-3].setLabel("O");
    buttons[NUM_ROWS/2][(NUM_COLS/2-2)].setLabel("U");
    buttons[NUM_ROWS/2][(NUM_COLS/2-1)].setLabel("");
    buttons[NUM_ROWS/2][(NUM_COLS/2)].setLabel("W");
    buttons[NUM_ROWS/2][(NUM_COLS/2+1)].setLabel("I");
    buttons[NUM_ROWS/2][(NUM_COLS/2+2)].setLabel("N");
    buttons[NUM_ROWS/2][(NUM_COLS/2+3)].setLabel("!");
    }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true) {
    displayWinningMessage();
  }
}
public boolean isWon() {
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int col = 0; col < NUM_COLS; col++) {
            MSButton button = buttons[row][col];
            if (!mines.contains(button) && !button.clicked) {
                return false;
            }
        }
    }
    return true;
}
public boolean isValid(int r, int c)
{
  return (r >= 0 && r < NUM_ROWS && c>=0 && c<NUM_COLS);
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for(int r=row-1; r<=row+1; r++){
   for(int c = col-1; c<=col+1; c++){
     if(isValid(r,c)&&mines.contains(buttons[r][c])){
             numMines++;
       }
     }
   }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    if(mouseButton == RIGHT) {
      if(flagged==true){
       flagged=false;
       clicked=false;
      }
      else if(flagged==false){
        flagged=true;
        clicked=false;
      }
  } else if(mines.contains(this)){
       displayLosingMessage();
  } else if(countMines(myRow,myCol)>0){
       setLabel(countMines(myRow,myCol));
  } else {
        if(isValid(myRow, myCol) && !mines.contains(buttons[myRow][myCol])){
          for(int r = myRow-1; r<=myRow+1; r++){
            for(int c= myCol-1; c<=myCol+1; c++){
              if(isValid(r,c) && buttons[r][c].clicked==false){
              buttons[r][c].mousePressed();
              }
            }
          }
        }
  }
}
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if( clicked && mines.contains(this) ) 
      fill(255,0,0);
    else if (clicked)
      fill( 200 );
    else{ 
      fill( 100 );
    }
    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public void displayLosingMessage()
{  
    
    for(int i=0;i<mines.size();i++)
        if(mines.get(i).clicked==false)
            mines.get(i).mousePressed();
    isLost = true;
    fill(255,0,0);
    buttons[NUM_COLS/2][(NUM_COLS/2)-4].setLabel("Y");
    buttons[NUM_COLS/2][(NUM_COLS/2)-3].setLabel("O");
    buttons[NUM_COLS/2][(NUM_COLS/2-2)].setLabel("U");
    buttons[NUM_COLS/2][(NUM_COLS/2-1)].setLabel("");
    buttons[NUM_COLS/2][(NUM_COLS/2)].setLabel("L");
    buttons[NUM_COLS/2][(NUM_COLS/2+1)].setLabel("O");
    buttons[NUM_COLS/2][(NUM_COLS/2+2)].setLabel("S");
    buttons[NUM_COLS/2][(NUM_COLS/2+3)].setLabel("E");
}
}
