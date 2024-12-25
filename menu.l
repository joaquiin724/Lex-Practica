/**
 * @file regex.l
 * @brief Menu que:
 * 
 * @note
 *      Compilación:
 *          1. flex++ -o regex.cpp regex.l
 *          2. g++ -Wall -o regex regex.cpp
 *      Ejecución:
 *          1. ./regex
 * 
 * @author Arturo Olivares Martos
 * @author Joaquín Avilés de la Fuente
 * @date 18 de diciembre de 2024
 */

    /*---------------DECLARACIONES---------------*/
%{
#include <iostream>
#include <sstream>
#include <string>
#include <fstream>


using namespace std;

int nl;

ofstream prueba;

%}

%option noyywrap

linea   \n

%%
    /*---------------REGLAS---------------*/
\n  { nl++;}

%%
    /*---------------PROCEDIMIENTOS---------------*/

void imprime_menu(){
    cout << "Menú:" << endl;
    cout << "\t1. Dado un teléfono, comprobar en qué países es válido." << endl;
    cout << "\t2. Dado un correo electrónico, comprobar si es válido." << endl;
    cout << "\t3. Dado un DNI, comprobar si es válido." << endl;
    cout << "\t4. Dado un número de tarjeta de crédito, indicar de qué entidad bancaria es." << endl;
    cout << "Introduce el número de la opción elegida:" << endl;
}


int main (int argc, char *argv[]){
    const string INICIAL="0";

    nl = 0;
    string input;
    string line;
    stringstream ss;

    string opcion_elegida=INICIAL;
    string comando, archivo;


    cout << "En el siguiente programa, encontrarás un menú que te permitirá trabajar con distintas expresiones regulares." << endl;
    imprime_menu();

    while(opcion_elegida == INICIAL){
        getline(cin, opcion_elegida);
        switch(stoi(opcion_elegida)){
            case 1:
                cout << "Has elegido la opción 1" << endl;
                comando="make telefonos-menu";
                archivo="Telefonos/telefonos-menu.txt";
                break;
            case 2:
                cout << "Has elegido la opción 2" << endl;
                break;
            case 3:
                cout << "Has elegido la opción 3" << endl;
                comando="make dni-nie-menu";
                archivo="DNI-NIE/dni-nie-menu.txt";
                break;
            case 4:
                cout << "Has elegido la opción 4" << endl;
                comando="make bancos-menu";
                archivo="Bancos/cuentas-menu.txt";
                break;
            default:
                cout << "Opción no válida" << endl;
                opcion_elegida=INICIAL;
                break;
        }
    }

    cout << "Introduce texto (termina con -1 en una línea nueva):" << endl;

    // Leer entrada hasta que se introduzca -1
    while (getline(cin, line)) {
        if (line == "-1") {
            break;
        }
        ss << line << '\n';
    }

    // Pasar el contenido del stringstream al analizador léxico
    string input_data = ss.str();
    istringstream input_stream(input_data);
    yyFlexLexer flujo(&input_stream, 0);
    flujo.yylex();
    cout << endl;

    // Se abre el archivo definido (se crea si no existe) y con la funcion
    // ios::trunc se se sobreescribe si ya existía
    prueba.open(archivo, ios::trunc);

    if (!prueba){
        cerr << "Error de escritura del archivo (" << archivo << ")." << endl;
        exit(1);
    }

    // Se escribe el contenido del stringstream en el archivo
    prueba << input_data << endl;

    // Se cierre el archivo
    prueba.close();

    // Se ejecuta el comando definido
    system(comando.c_str());

    cout << "Número de líneas: " << nl << endl;
    return 0;
}