import uvm_pkg::*;
class environment extends uvm_env;
    `uvm_component_utils(environment)
    
    agent agnt;
    scoreboard scb;
    fun_cov fc;
    
    function new(string name="environment", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        agnt = agent::type_id::create("agnt", this);
        scb = scoreboard::type_id::create("scb", this);
        fc = fun_cov::type_id::create("fc", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agnt.mon.ap.connect(scb.ap_export);
        agnt.mon.ap.connect(fc.analysis_export);
    endfunction
    
endclass
