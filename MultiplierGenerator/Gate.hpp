#ifndef GATE_HPP_INCLUDED
#define GATE_HPP_INCLUDED

#include <string>
#include <iostream>
#include <atomic>
#include <vector>
#include <cmath>
#include <stdexcept>

using namespace std;

class Gate{
public:
    virtual void gen(std::ostream& out) = 0;
    virtual string name() = 0;

    virtual ~Gate() {};
};

class InputGate: public Gate{
    string vnm;
    unsigned int vref;
public:
    InputGate(): vnm(), vref(0) {};
    InputGate(std::string vname, unsigned int vnumber): vnm(vname), vref(vnumber) {};

    void gen(std::ostream& out) override{
        return;
    }

    string name() override{
        return (vnm + "[" + to_string(vref)+"]");
    }
};

class OutputGate: public Gate{
    string vnm;
    unsigned int vref;
    Gate* in;
public:
    OutputGate(): vnm(), vref(0), in(nullptr) {};
    OutputGate(std::string vname, unsigned int vnumber, Gate* in1): vnm(vname), vref(vnumber), in(in1) {};

    void gen(std::ostream& out) override{
        out << "\tassign " << vnm << "[" << vref << "]" << " = " << in->name() << ";\n";
    }

    string name() override{
        return (vnm + "[" + to_string(vref)+"]");
    }
};

class ANDGate: public Gate{
    unsigned int nref;
    Gate *in1, *in2;

    static atomic_uint cnt;
public:
    ANDGate(): nref(cnt++), in1(nullptr), in2(nullptr) {};
    ANDGate(Gate* in1, Gate* in2): nref(cnt++), in1(in1), in2(in2) {};

    void gen(std::ostream& out) override{
        out << "\twire wand_" << nref << ";\n";
        out << "\tand and_" << nref << "( wand_" << nref <<", " << in1->name() << ", " << in2->name() << ");\n";
    }

    string name() override{
        return ("wand_" + to_string(nref));
    }
};

class FAProvider: public Gate{
    unsigned int nref;
    Gate *in1, *in2, *in3;

    static atomic_uint cnt;
public:
    FAProvider(): nref(cnt++), in1(nullptr), in2(nullptr), in3(nullptr) {};
    FAProvider(Gate* a, Gate* b, Gate* _cin): nref(cnt++), in1(a), in2(b), in3(_cin) {};

    void gen(std::ostream& out) override{
        out << "\twire wfa_s_" << nref << ", wfa_cout_" << nref << ";\n";
        out << "\tfa fa_" << nref << "( " << in1->name() << ", " << in2->name() << ", " << in3->name() << ", wfa_s_" << nref << ", wfa_cout_" << nref << ");\n";
    }

    string name() override{
        ///It is only provider, not node
        return string();
    }

    unsigned int getRef(){ return nref; }
};

class FANode_S: public Gate{
    FAProvider* p;
public:
    FANode_S(): p(nullptr) {};
    FANode_S(FAProvider* prov): p(prov) {};

    void gen(std::ostream& out) override{
        ///It is only node, not provider
        return;
    }

    string name() override{
        return ("wfa_s_" + to_string(p->getRef()));
    }
};

class FANode_Cout: public Gate{
    FAProvider* p;
public:
    FANode_Cout(): p(nullptr) {};
    FANode_Cout(FAProvider* prov): p(prov) {};

    void gen(std::ostream& out) override{
        ///It is only node, not provider
        return;
    }

    string name() override{
        return ("wfa_cout_" + to_string(p->getRef()));
    }
};

class HAProvider: public Gate{
    unsigned int nref;
    Gate *in1, *in2;

    static atomic_uint cnt;
public:
    HAProvider(): nref(cnt++), in1(nullptr), in2(nullptr) {};
    HAProvider(Gate* a, Gate* b): nref(cnt++), in1(a), in2(b) {};

    void gen(std::ostream& out) override{
        out << "\twire wha_s_" << nref << ", wha_c_" << nref << ";\n";
        out << "\tha ha_" << nref << "( " << in1->name() << ", " << in2->name() << ", wha_s_" << nref << ", wha_c_" << nref << ");\n";
    }

    string name() override{
        ///It is only provider, not node
        return string();
    }

    unsigned int getRef(){ return nref; }
};

class HANode_S: public Gate{
    HAProvider* p;
public:
    HANode_S(): p(nullptr) {};
    HANode_S(HAProvider* prov): p(prov) {};

    void gen(std::ostream& out) override{
        ///It is only node, not provider
        return;
    }

    string name() override{
        return ("wha_s_" + to_string(p->getRef()));
    }
};

class HANode_C: public Gate{
    HAProvider* p;
public:
    HANode_C(): p(nullptr) {};
    HANode_C(HAProvider* prov): p(prov) {};

    void gen(std::ostream& out) override{
        ///It is only node, not provider
        return;
    }

    string name() override{
        return ("wha_c_" + to_string(p->getRef()));
    }
};

atomic_uint ANDGate::cnt;
atomic_uint HAProvider::cnt;
atomic_uint FAProvider::cnt;

void gen_mult(std::ostream& out, unsigned int opsz){
    vector<unsigned int> gen_seq;
    gen_seq.push_back(2);
    while(gen_seq.back() < opsz){
        unsigned int cur_seq = gen_seq.back();
        gen_seq.push_back( (unsigned int)(floor(3.0*cur_seq/2.0)) );
    }
    gen_seq.pop_back();

    vector<Gate*>* wg = new vector<Gate*> [2*opsz];
    vector<Gate*> ins1;
    vector<Gate*> ins2;
    vector<Gate*> used;
    vector<Gate*> outs;

    for(unsigned int i = 0; i < opsz; i++){
        ins1.push_back(new InputGate("a", i));
        ins2.push_back(new InputGate("b", i));
    }

    cout << "Input generation" << endl;
    for(unsigned int i = 0; i < opsz; i++){
        for(unsigned int j = 0; j < opsz; j++){
            wg[i+j].push_back(new ANDGate(ins1[i], ins2[j]));
        }
    }
    for(unsigned int i = 0; i < 2*opsz - 1; i++) cout << " Weight " << i << ", length " << wg[i].size() << endl;

    unsigned int i = 1;
    while(gen_seq.size() > 0){ ///Reduce vectors towards ready-to-use entities (auto generate last adders layer)
        unsigned int cur = gen_seq.back();
        gen_seq.pop_back();
        cout << "Layer " << i << ", target " << cur << endl;
        i++;

        for(unsigned int w = 0; w < 2*opsz - 1; w++){
            cout << " Weight " << w << ", length " << wg[w].size() << endl;
            if(wg[w].size() > cur){
                vector<Gate*>& gs = wg[w];
                vector<Gate*>& ngs = wg[w+1];
                unsigned int s = gs.size();
                while(s > cur){
                    if((s - cur) >= 2){ ///Insert Full Adder
                        Gate* a = gs[0];
                        Gate* b = gs[1];
                        Gate* _cin = gs[2];
                        gs.erase(gs.begin(), gs.begin()+3);
                        FAProvider* fa = new FAProvider(a, b, _cin);
                        gs.push_back(new FANode_S(fa));
                        ngs.push_back(new FANode_Cout(fa));
                        used.push_back(a), used.push_back(b), used.push_back(_cin), used.push_back(fa);
                        s -= 2;
                        cout << "  Inserted Full Adder, now " << s << endl;
                    }
                    else if((s - cur) == 1){ ///Insert Half Adder
                        Gate* a = gs[0];
                        Gate* b = gs[1];
                        gs.erase(gs.begin(), gs.begin()+2);
                        HAProvider* ha = new HAProvider(a, b);
                        gs.push_back(new HANode_S(ha));
                        ngs.push_back(new HANode_C(ha));
                        used.push_back(a), used.push_back(b), used.push_back(ha);
                        s -= 1;
                        cout << "  Inserted Half Adder, now " << s << endl;
                    }
                    else if((s - cur) == 0){ ///Connect to next layer
                        s -= 0;
                        cout << "  Passed to next layer, now" << s << endl;
                    }
                    else throw runtime_error("Bad condition in place #1");
                }
            }
        }
    }
    ///Check if we're have good vectors
    if(wg[0].size() != 1) throw runtime_error("First vector have " + to_string(wg[0].size()) + " entities in it instead of 1");
    for(unsigned int i = 1; i < 2*opsz - 1; i++)
        if(wg[i].size() != 2) throw runtime_error("Vector " + to_string(i) + " have size " + to_string(wg[i].size()) + " instead of 2 after reduction");
    if(wg[2*opsz - 1].size() != 0) throw runtime_error("Last (fill) vector have " + to_string(wg[2*opsz].size()) + " entities in it instead of 0");

    ///Add last two layers
    cout << "Outputs layer, target 1" << endl;
    for(unsigned int w = 0; w < 2*opsz; w++){
        vector<Gate*>& gs = wg[w];
        vector<Gate*>& ngs = wg[w+1];
        unsigned int s = gs.size();
        cout << " Weight " << w << ", length " << s << endl;
        if(s == 2){
            Gate* a = gs[0];
            Gate* b = gs[1];
            gs.erase(gs.begin(), gs.begin()+2);
            HAProvider* ha = new HAProvider(a, b);
            gs.push_back(new HANode_S(ha));
            ngs.push_back(new HANode_C(ha));
            used.push_back(a), used.push_back(b), used.push_back(ha);
            s -= 1;
            cout << "  Inserted Half Adder, now " << s << endl;
        } else if( s == 3){
            Gate* a = gs[0];
            Gate* b = gs[1];
            Gate* _cin = gs[2];
            gs.erase(gs.begin(), gs.begin()+3);
            FAProvider* fa = new FAProvider(a, b, _cin);
            gs.push_back(new FANode_S(fa));
            ngs.push_back(new FANode_Cout(fa));
            used.push_back(a), used.push_back(b), used.push_back(_cin), used.push_back(fa);
            s -= 2;
            cout << "  Inserted Full Adder, now " << s << endl;
        } else if (s == 1){
            cout << "  Passed to the outputs layer" << endl;
        }
    }

    ///Generate outputs
    for(unsigned int i = 0; i < 2*opsz; i++){
        Gate* ow = wg[i][0];
        wg[i].clear();
        outs.push_back(new OutputGate("m", i, ow));
        used.push_back(ow);
    }

    ///Generate rtl representation
    for(Gate* i: used) i->gen(out);
    for(Gate* i: outs) i->gen(out);

    ///Cleanup
    delete [] wg;
    for(Gate* i: ins1) delete i;
    for(Gate* i: ins2) delete i;
    for(Gate* i: used) delete i;
    for(Gate* i: outs) delete i;
}

void gen_incls(std::ostream& out){
    ///generate full adder
    out << "module fa(a,b,cin, s, cout);\n";
    out << "\tinput a;\n";
    out << "\tinput b;\n";
    out << "\tinput cin;\n";
    out << "\n";
    out << "\toutput s;\n";
    out << "\toutput cout;\n";
    out << "\n";
    out << "\tassign s = a^b^cin;\n";
    out << "\tassign cout = (a & b) | (cin & (a ^ b));\n";
    out << "endmodule\n";
    out << "\n";

    ///generate half adder
    out << "module ha(a,b,s,c);\n";
    out << "\tinput a;\n";
    out << "\tinput b;\n";
    out << "\n";
    out << "\toutput s;\n";
    out << "\toutput c;\n";
    out << "\n";
    out << "\tassign s = a^b;\n";
    out << "\tassign c = a&b;\n";
    out << "endmodule\n";
    out << "\n";
}

void gen_module_decl(std::ostream& out, unsigned int opsz){
    out << "module mult_" << opsz << "(a, b, m);\n";
    out << "\tinput [" << (opsz-1) << ":0] a;\n";
    out << "\tinput [" << (opsz-1) << ":0] b;\n";
    out << "\n";
    out << "\toutput [" << (2*opsz-1) << ":0] m;\n";
    out << "\n\n";
}

void gen_module_end(std::ostream& out){
    out << "\n";
    out << "endmodule\n";
    out << "\n";
}

#endif // GATE_HPP_INCLUDED
