import uvm_pkg::*;
class random_seq extends uvm_sequence#(transaction);
    `uvm_object_utils(random_seq)

    transaction trans;
    int no_rnd_test_cases;
   
    function new(string name = "rnd_seq");
        super.new(name);
        trans = transaction::type_id::create("trans");
        if(!uvm_config_db#(int)::get(null, "seq.*", "no_rnd", no_rnd_test_cases)) begin
            `uvm_warning(get_type_name(), "Config for no. of random cases not found. Running default 200 no. of random cases")
            no_rnd_test_cases = 200;
        end
    endfunction

    task body();
        for (int i=0; i < no_rnd_test_cases; i++) begin
            start_item(trans);
            if(!trans.randomize())
                `uvm_fatal(get_type_name(), "Randomization failed")
            
            trans.isRandom  = 1;
            finish_item(trans);
            `uvm_info("RND_SEQ", "Sent packet", UVM_HIGH)
        end
    endtask
endclass
