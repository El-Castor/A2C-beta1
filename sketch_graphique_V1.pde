import controlP5.*;
import processing.serial.*;

ControlP5 cp5;

//initiatlisations des variables*******************************************************************
String myPort = "25"; //Serial monPort;  //Déclaration port série pour la lecture des données envoyées par l'Arduino
int mesure;      //Mesure lue sur le port 

int x = displayWidth/2;
int y = displayHeight/2;
int j,k;
int yOffset = displayHeight / 18;

float w = 30;
float h = 30;
boolean t=false;
boolean hy=false;
boolean e=false;
boolean p=false;
boolean s=false;

Toggle constantToogleHy;

//TODO rename one letter variable for Vivien pleasure ex: pH_checkbox
int temperature=25;      //Temperature mesurée par l'Arduino
int tempmini=34;         //Temperature mini mesurée par l'Arduino
int tempmax=12;          //Temperature maxi mesurée par l'Arduino
int tempCar=25;
int m;                   //Indice de travail
int kn;                   //Indice de travail
int xg=0;                 //Abcisse
int xg0=0;                //Abcisse précédente
int yg=0;                 //Ordonnée
int yg0;                  //Ordonnée précédente

int premier = 0;         // Bypass premiere valeur erronée

StringList togglesNamesList = new StringList("Temp", "Hygro","TempSol","pH","Ec");

void setup()
{

 size(displayWidth,displayHeight);
  
 
 cp5= new ControlP5(this);

 //TODO [Toggle] listToggles = array vide
 
 //listToggles[] = new Numberbox[5];

println(togglesNamesList);

cp5.addToggle("Temp").setValue(0).setPosition(800,550).setSize(50,25).setState(false); //each function return the toggle so at the end you add t
constantToogleHy = cp5.addToggle("Hygro").setValue(0).setPosition(800,650).setSize(50,25).setState(false);
cp5.addToggle("TempSol").setValue(0).setPosition(800,750).setSize(50,25).setState(false);
cp5.addToggle("pH").setValue(0).setPosition(800,850).setSize(50,25).setState(false);
cp5.addToggle("Ec").setValue(0).setPosition(800,950).setSize(50,25).setState(false);

 
}
//TODO Au moment ou il clique sur un bouton, itérer sur la listeToggles et tu les setValue(0) sauf si c'est celle qui vient d'être cliqué 


void draw()
{
  if(cp5.getController("Temp").getValue()==1){
    graphic("Température, °C", 5);
    newPointTemp("25");
  }
  if(cp5.getController("Hygro").getValue()==1){
    graphic("Hygrométrie, %", 10);
    newPointTemp("45");
  }
  if(cp5.getController("Ec").getValue()==1){
    graphic("Ec, µS", 1);
    newPointTemp("1");
  }
  if(cp5.getController("pH").getValue()==1){
    graphic("pH", 14);
    newPointTemp("7");
  }
  if(cp5.getController("TempSol").getValue()==1){
    graphic("Température solution, °C", 5);
    newPointTemp("5");
  }
}

void controlEvent(ControlEvent theEvent) {
 if(theEvent.isController()) {
   if(theEvent.getController().getValue()!=0){
     print("control event from : "+theEvent.getController().getName());
     println(", value : "+theEvent.getController().getValue());
     
     // clicking on toggle sets toggle value to 1 (true)
     String clickedToggleName=theEvent.getController().getName();
     println("clicked toggle name :  "+clickedToggleName);
     redraw();
     if (togglesNamesList.hasValue(clickedToggleName)){
       for(int i=0; i<togglesNamesList.size(); i++){
         if(togglesNamesList.get(i)!=clickedToggleName){
           cp5.getController(togglesNamesList.get(i)).setValue(0);
           println(togglesNamesList.get(i));
         }
       }
     }
   }
 }
}


public void Temp(){
  if(cp5.getController("Temp").getValue()==1){
    println("temperature selectionné");
  }
}

public void Hygro(){
  if(cp5.getController("Hygro").getValue()==1){
    println("Hygrométrie selectionné");
  }
}

public void Ec(){
  if(cp5.getController("Ec").getValue()==1){
    println("Ec selectionné");
  }
}

public void pH(){
  if(cp5.getController("pH").getValue()==1){
    println("pH selectionné");
  }
}

public void TempSol(){
  if(cp5.getController("TempSol").getValue()==1){
    println("TempSol selectionné");
  }
}

/*String constSelectPrint 
public void pH(String constSelectPrint,boolean constSelect){
  println(constSelectPrint);
  if(!constSelect){
    constSelect=true;
  }else{
    constSelect=false;
  }
}*/
 //TODO * each x and y by xCal=displayWidth/idealWidth and yCal=displayHeight/idealHeight

void graphic(String constChoice, int yValue)
{
  int x = displayWidth/2;
  int y = displayHeight/2;
  int j,k;
  int yOffset = displayHeight / 18;
  int idealWidth = width;
  int idealHeight = height;
  int xCal = displayWidth / idealWidth;
  int yCal = displayHeight / idealHeight;
  
  //Affichage case pour les grahiques
  fill(255, 255, 255);
  rect((displayWidth/2)-20,displayHeight/2,((displayWidth/2) - yOffset)+20,((displayHeight/2-yOffset) - yOffset)+20);
  
  
  //affichages axes
  fill(0,0,255);
  stroke(#0650E4);
  strokeWeight(2);
  
  //horizontal
  line ((displayWidth/2)+10*xCal,(displayHeight/2)+6*yCal,(displayWidth/2)+10*xCal,(displayWidth/2)-10*yCal);
  triangle(((displayWidth/2)+5*xCal), (displayHeight/2)+10*yCal, (displayWidth/2)+10*xCal, (displayHeight/2)+2*yCal, (displayWidth/2)+15*xCal,(displayHeight/2)+10*yCal);
  text(constChoice, (displayWidth/2)+15*xCal,(displayHeight/2)+12*yCal);
 
  //vertical
  line ((displayWidth/2)+10*xCal,(displayWidth/2)-10*yCal,(displayWidth-yOffset)-10*xCal,(displayWidth/2)-10*yCal);
  triangle(((displayWidth/2)+(displayWidth/2-yOffset))-15*xCal,(displayWidth/2)-15*yCal, ((displayWidth/2)+(displayWidth/2-yOffset))-15*xCal,(displayWidth/2)-6*yCal, (displayWidth-yOffset)-5*xCal, (displayWidth/2)-10*yCal);
  text("Temps", ((displayWidth/2)+(displayWidth/2-yOffset))-40*xCal,(displayWidth/2)-20*yCal);
 
  //Gradations et textes tous les 5 degrés
  fill(0,0,255);
  strokeWeight(2);
  stroke(#0650E4);
  for (int i = 0; i < 11; i++) {
      j=i*40;
      k=i*yValue;
      line(((displayWidth/2)+10)-5*xCal, (displayWidth/2)-10-j*yCal, (displayWidth/2)+10*xCal,(displayWidth/2)-10-j*yCal);
      text(k, ((displayWidth/2)+10)-23*xCal, (displayWidth/2)-8-j*yCal);
  }
 
//Gradations fines des degrés
  strokeWeight(1);
  stroke(#0650E4);
  for (int i = 0; i < 50; i++) {
          j=i*8;
          line(((displayWidth/2)+10)-5*xCal, (displayWidth/2)-10-j*yCal, (displayWidth/2)+10*xCal,(displayWidth/2)-10-j*yCal);
}
 
//Gradations des minutes
 strokeWeight(2);
 for (int i = 0; i < 15; i++) {
          j=i*60;
          line(((displayWidth/2)+10)+j*xCal, (displayWidth/2)-3*yCal, ((displayWidth/2)+10)+j*xCal,((displayWidth/2)-8*yCal));
          text(i, ((displayWidth/2)+7)+j*xCal, ((displayWidth/2)+10*yCal));
 }
}

//function to mime the serialEvent
 void newPointTemp(String myPort) {
   
 //Récupération sur le port série de la temperature sous forme de chaine de caractères
 int idealWidth = width;
 int idealHeight = height;
 int xCal = displayWidth / idealWidth;
 int yCal = displayHeight / idealHeight;
 String tempcar = myPort;
 if (tempcar != null && premier == 1) {
      tempcar = trim(tempcar); // Suppression des blancs
      int tempInt = int(tempcar);
      float temperature = float (tempcar);
  //    float temperature = tempInt;
      //println ("La temperature est de : " + temperature + " : " + tempInt);
      
 //Dessin graphe avec temperature actuelle -----------------------
      strokeWeight(1);
  
      //dessin du nouveau point sur la courbe
      xg0=x; // Mémorisation abscisse point précédent
      xg=xg+5; // L'Arduino envoie une nouvelle mesure de température toutes les 5 secondes
      if (xg >600) {xg=5;}
    
      yg0=yg; // Mémorisation ordonnée point précédent
      yg = tempInt*8; // Un degré correpond à 8 points sur les ordonnées
    
      if (yg > tempmax*8)  {tempmax = yg/8;} //Mise à jour temp max
      if (yg < tempmini*8) {tempmini = yg/8;} //Mise à jour temp min
    
      if (xg == 5) {   //Si on rédémarre une nouvelle courbe
        noStroke();
        fill(230);
        point((xg+999)*xCal,(950-yg)*yCal);
      }
      else {
        fill(230);
        line((xg0+1000)*xCal,(950-yg0)*yCal,(xg+999)*xCal,(950-yg)*yCal);
      }
      
 
 }
//Recuperation des données envoyé par le arduino/******************************************************************************

//Traitements à réception d'une fin de ligne
 /*void serialEvent (String myPort) {
   
 //Récupération sur le port série de la temperature sous forme de chaine de caractères
 String tempcar = myPort;
 if (tempcar != null && premier == 1) {
      tempcar = trim(tempcar); // Suppression des blancs
      int tempInt = int(tempcar);
      float temperature = float (tempcar);
  //    float temperature = tempInt;
      println ("La temperature est de : " + temperature + " : " + tempInt);
      
 //Dessin graphe avec temperature actuelle -----------------------
      stroke (0,255,0);
      strokeWeight(1);
  
      //dessin du nouveau point sur la courbe
      xg0=x; // Mémorisation abscisse point précédent
      xg=xg+5; // L'Arduino envoie une nouvelle mesure de température toutes les 5 secondes
      if (xg >600) {xg=5;}
    
      yg0=yg; // Mémorisation ordonnée point précédent
      yg = tempInt*8; // Un degré correpond à 8 points sur les ordonnées
    
      if (yg > tempmax*8)  {tempmax = yg/8;} //Mise à jour temp max
      if (yg < tempmini*8) {tempmini = yg/8;} //Mise à jour temp min
    
      if (xg == 5) {   //Si on rédémarre une nouvelle courbe
        noStroke();
        fill(230);//fill(255, 255, 255);
        rect((displayWidth/2)-20,displayHeight/2,((displayWidth/2) - yOffset)+20,((displayHeight/2-yOffset) - yOffset)+20); //Effacement courbe précédente
        point(xg+(((displayWidth/2)+10)-5)+2,((displayWidth/2)-10)-yg);
      }
      else {
        line((xg0)+(((displayWidth/2)+10)-5)+2,((displayWidth/2)-10)-yg0,x+(((displayWidth/2)+10)-5)+1,((displayWidth/2)-10)-yg);
      }
 
 }*/
premier = 1;
}
