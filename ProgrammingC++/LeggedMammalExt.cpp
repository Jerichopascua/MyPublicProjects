#include <iostream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include <bits/stdc++.h> 

// 1.	Write a class that extends the LeggedMammal class from the previous laboratory exercise. 
// The class will represent a Dog. Consider the breed, size and is registered. 
// Initialize all properties of the parent class in the new constructor. This time, promote the use of accessors and mutators for the new properties. - Done
// Instantiate a Dog object in the main function and be able to set the values of the properties of the Dog object using the mutators.  
// Display all the properties of the Dog object using the accessors.
// My Reference : https://simplecplusplus.wordpress.com/tag/accessors-and-mutators/

using namespace std;

class LeggedMammal  {
  private:
    int _intNoofLegs;        
    string _strKindofFurs;
    bool _bpresentofTail;

  public:        
     //contructors
     LeggedMammal();
     LeggedMammal(int intNoofLegs,string strKindofFurs,bool bpresentofTail);

    // Mutators - Set
    void setNoofLegs(int intNoLegs);
    void setKindofFurs(string strKindofFurs);
    void setpresentofTail(bool bpresendofTail);
    //set all properties
    // void SetLeggedMammal(int intNoofLegs,string strKindofFurs,bool bpresentofTail);    

    // Acessor - Get All Properties
    int getNoofLegs() const;
    string getKindofFurs() const;
    bool getpresentofTail() const;
    // Display /get all 
    void GetLeggedMammal();
    
};
//Default contructor Parent
LeggedMammal::LeggedMammal()
{
    _intNoofLegs=0;        
    _strKindofFurs="Kind of Furs";
    _bpresentofTail=false;

}
//Initialize all Member variables to specific Values
LeggedMammal::LeggedMammal(int intNoofLegs,string strKindofFurs,bool bpresentofTail){
     _intNoofLegs=intNoofLegs;        
    _strKindofFurs=strKindofFurs;
    _bpresentofTail=bpresentofTail;
}
// Mutator / Set values
void LeggedMammal::setNoofLegs(int intNoofLegs){
    _intNoofLegs=intNoofLegs;
}
void LeggedMammal::setKindofFurs(string strKindofFurs){
    _strKindofFurs=strKindofFurs;
}
void LeggedMammal::setpresentofTail(bool bpresentofTail){
    _bpresentofTail=bpresentofTail;
}
// Accessor/ Get Values
int LeggedMammal::getNoofLegs() const{
    return _intNoofLegs;
}
string LeggedMammal::getKindofFurs() const{
    return _strKindofFurs;
}
bool LeggedMammal::getpresentofTail() const{
    return _bpresentofTail;
}
// Get All the data 
void LeggedMammal::GetLeggedMammal(){
    cout << _intNoofLegs << ": ";
    cout << _strKindofFurs << ": ";
    if (_bpresentofTail==1){
        cout << "True";
    }else{
        cout << "False";
    }
}

// New Class Dogs 
// class that extends the LeggedMammal class
class Dog : public LeggedMammal{ 
    // Dog. Consider the breed, size and is registered. 
    private:
        string _strBreed;        
        int _intSize;
        string _strRegistered;

    public:
     //contructors
     Dog();
     Dog(string strBreed,int intSize,string strRegistered);

     // Mutators - Set for Dog Class 
    void setBreed(string strBreed);
    void setSize(int intSize);
    void setRegistered(string strRegistred);

     // Acessor - Get All Properties of Dog Class Member variables
    string getBreed() const;
    int getSize() const;
    string getRegistered() const;

    // Display /get all  Dogs Properties
    void GetDogsDescription();

};

//Default contructor for Dogs
Dog::Dog(){
    _intSize=0;
    _strBreed="Breed";
    _strRegistered="Registered";
}
//Initialize all Member varables for Dogs     
Dog::Dog(string strBreed,int intSize,string strRegistered){
    _intSize=intSize;
    _strBreed=strBreed;
    _strRegistered=strRegistered;
}

// Mutator / Set values// Mutator / Set values
void Dog::setBreed(string strBreed){
    _strBreed=strBreed;
}
void Dog::setSize(int intSize){
    _intSize=intSize;
}
void Dog::setRegistered(string strRegistered){
    _strRegistered=strRegistered;
}
// LeggedMammal::LeggedMammal(int xintNoofLegs,string xstrKindofFurs,bool xbpresentofTail){
//     intNoofLegs=xintNoofLegs;
//     strKindofFurs=xstrKindofFurs;
//     bpresentofTail=xbpresentofTail;    
// }
// Get All the data 
void Dog::GetDogsDescription(){
    cout << _strBreed << ": ";
    cout << _intSize << ": ";
    cout << _strRegistered ;
}


int main () {

    // LeggedMammal LegMammal1(5,"Furs Type",true);
    // cout << " Legged Mammal Description : " << LegMammal1.DescLeggedMammal() << endl;
    // LeggedMammal SetLeggedMamal1(5,"Furs Type",true);
    // cout << " Legged Mammal Description : " << LeggedMammal1.GetLeggedMammal() << endl;
    

    //Legged Mammal Class
    LeggedMammal LeggedMammal1;
    LeggedMammal LeggedMammal2(5,"Furs Type",true);
    cout << "Legged Mamamal defauilt Initilazation";
    cout << endl;
    LeggedMammal2.GetLeggedMammal();
    cout << endl;

    LeggedMammal1.setNoofLegs(10);
    LeggedMammal1.setKindofFurs("Unique Furs");
    LeggedMammal1.setpresentofTail(false);
    cout << endl;
    LeggedMammal1.GetLeggedMammal();
    cout << endl;

    //Dog Class
    Dog Dog1;
    Dog Dog2("Breed",1,"Registered");
    cout << "Dog defauilt Initilazation";
    cout << endl;
    Dog2.GetDogsDescription();
    cout << endl;

    cout << "Dog Set Values";
    Dog1.setBreed("Breed 2");
    Dog1.setSize(2);
    Dog1.setRegistered("Not Registered");
    cout << endl;
    Dog1.GetDogsDescription();
    cout << endl;
    Dog2.GetDogsDescription();
    cout << endl;

    


    cout << endl;    
    return 0;

}