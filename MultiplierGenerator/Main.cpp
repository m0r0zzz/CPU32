#include <iostream>
#include <fstream>
#include <string>

#include "Gate.hpp"

using namespace std;

int main(int argc, char** argv){
    if(argc != 3){
        cout << "Dadda Tree Multiplier Verilog representation generator.\n\tUsage:\n\t" << argv[0] << " <opsz> <outfile>" << endl;
        return 0;
    }

    ofstream out(argv[2]);
    if(!out.is_open()){
        cout << "Can't open outfile" << endl;
        return -1;
    }

    unsigned int opsz = atoi(argv[1]);

    gen_header(out, opsz);

    gen_incls(out);

    gen_module_decl(out, opsz);

    gen_mult(out, opsz);

    gen_module_end(out);

    out.close();

    return 0;
}
