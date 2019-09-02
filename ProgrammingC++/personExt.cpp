#include <iostream>
#include <string>
#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include <bits/stdc++.h> 

using namespace std;

// 2.Write a class that extends the Person class from the previous laboratory exercise.  
// The class will represent a Student. Consider the academic program, year in college and enrolled university. 
// Initialize all the properties of the parent class in the new constructor. 
// This time, promote the use of accessors and mutators for the new properties.
//Instantiate a Student object in the main function and be able to set the values of the properties of the Student object using the mutators.  
//Display all the properties of the Student object using the accessors.


class person{
    private:
        string mname,madd,mocc,mgender;
        int mage;
    public:
        person();
        person(string name,string add,string occ,string gender, int age);
        string getperson(){
            ostringstream s ; 
            cout << "I'm " << mname << ". A " << mgender << " " << mage << " Years Old.\nI live In" << madd;
            cout << "I'm a " << mocc << ".";            
            return "test";
        }
        
};

person::person(){
    mname="";
    madd="";
    mocc="";
    mgender="";
    mage=0;
}
person::person(string name,string add,string occ,string gender, int age){
    mname=name;
    madd=add;
    mocc=occ;
    mgender=gender;
    mage=age;
}

//Class Student
class Student : public person{
    private:
        // The class will represent a Student. Consider the academic program, year in college and enrolled university. 
        string _strAcademicProgram;
        int _intYearInCollege;
        string _strUniversity;
    public:
        //contructor
        Student();
        Student(string strAcademicProgram,int intYearInCollege,string strUniversity);

        //Mutator / Set for Student member varibles
        void setAcademicProgram(string strAcademicProgram);
        void setYearInCollege(int intYearInCollege);
        void setUniversity(string strUniversity);
        //Accessor / Get Student Properties
        string getAcademicProgram() const;
        int getYearInCollege() const;
        string getUniversity() const;    
        //Display all Student Properties
        void GetStudentDescription();
};
//Default Contructor for Student
Student::Student(){
    _strAcademicProgram="";    
    _intYearInCollege=0;
    _strUniversity="";
}
//Initialize all Student Variables 
Student::Student(string strAcademicProgram,int intYearInCollege,string strUniversity){
    _strAcademicProgram=strAcademicProgram;    
    _intYearInCollege=intYearInCollege;
    _strUniversity=strUniversity;    
}

//Mutator Set each Variables in Student
void Student::setAcademicProgram(string strAcademicProgram){
    _strAcademicProgram=strAcademicProgram;
}
void Student::setYearInCollege(int intYearInCollege){
    _intYearInCollege=intYearInCollege;
}
void Student::setUniversity(string strUniversity){
    _strUniversity=strUniversity;
}
//get all Studne Variables and Display
void Student::GetStudentDescription(){
    cout << _strAcademicProgram << ": ";
    cout << _intYearInCollege << ": ";
    cout << _strUniversity ;
}

// Accessor/ Get Values
string Student::getAcademicProgram() const{
    return _strAcademicProgram;
}
int Student::getYearInCollege() const{
    return _intYearInCollege;
}
string Student::getUniversity() const{
    return _strUniversity;
}

int main(){
    
    person person1("Grace","Malaysia","programmer","Female",31);
    cout << "Person Class" << endl;
    cout << "" << person1.getperson();

    //Student Class     
    cout << "Student Class" << endl;    
    cout << "Student Initilization" << endl;
    Student Student1;    
    Student Student2("Computer Science",2,"University of the Philippines");    
    cout << "" << endl;
    cout << "Student Initilization value" << endl;
    Student1.GetStudentDescription();
    cout << "Student Initilization 2" << endl;
    Student2.GetStudentDescription();
    cout << "" << endl;
    cout << "Set Student Each Variables Value" << endl;
    Student1.setAcademicProgram("B.S. Information Technology");
    Student1.setYearInCollege(4);
    Student1.setUniversity("AMA Computer College");
    cout << "" << endl;
    cout << "Get Each Student Value" << endl;
    cout << Student1.getAcademicProgram();
    cout << "" << endl;
    cout << Student1.getYearInCollege();
    cout << "" << endl;
    cout << Student1.getUniversity();
    cout << "" << endl;

    cout << "Get ALL Student Value" << endl;
    Student1.GetStudentDescription();



}