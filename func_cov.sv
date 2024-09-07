//import uvm_pkg::*;

class fun_cov extends uvm_subscriber#(transaction);
    `uvm_component_utils(fun_cov)

    transaction trans;

    covergroup alu_cov;
        option.per_instance = 1;
        A: coverpoint trans.A { bins a[16] = { [0:255] }; }
        B: coverpoint trans.B { bins b[16] = { [0:255] }; }
        MODE: coverpoint trans.mode { bins m[] = {0, 1}; }
        CMD: coverpoint trans.cmd { bins c[] = { [0:8] }; }

        MODExCMD: cross MODE, CMD;
    endgroup
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        alu_cov = new();
    endfunction 

    function void write(T t);
        trans = t;
        alu_cov.sample();
    endfunction
endclass
