import uvm_pkg::*;
class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    
    environment env;
    directed_seq dir_seq;
    random_seq rnd_seq;
    
    function new(string name="base_test", uvm_component parent=null);
    begin
        super.new(name,parent);
    end
    
    function void build_phase(uvm_phase phase);
    begin
        env=environment::type_id::create("env",this);
        dir_seq = directed_seq::type_id::create("dir_seq");
        rnd_seq = random_seq::type_id::create("rnd_seq");
    end
    
    task void run_phase(uvm_phase phase);
    begin
        phase.raise_objection(this);
        dir_seq.start(env.agnt.seqr);
        rnd_seq.start(env.agnt.seqr);
        phase.drop_objection(this);
    end

endclass
