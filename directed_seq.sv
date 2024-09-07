import uvm_pkg::*;

class directed_seq extends uvm_sequence#(transaction);
    `uvm_object_utils(directed_seq)

    transaction trans;
    int no_dir_test_cases;
    string file_name;
    bit skip_dir_cases;
    logic [44:0] test_case_mem [];
    function new(string name = "dir_seq");
        super.new(name);
        trans = transaction::type_id::create("trans");
        if(!uvm_config_db#(int)::get(null, "seq.*", "no_dir", no_dir_test_cases)) begin
            `uvm_warning(get_type_name(), "No of Directed cases not found. SKIPPING DRECTED CASES")
            skip_dir_cases = 1;
        end
        if(!uvm_config_db#(string)::get(null, "seq.*", "file_name", file_name)) begin
            `uvm_warning(get_type_name(), "File name not found. SKIPPING DRECTED CASES")
            skip_dir_cases = 1;
        end
        test_case_mem = new[no_dir_test_cases];
    endfunction //new()
 
    task pre_body();
        if(skip_dir_cases)
            return;
        $readmemb(file_name, test_case_mem);
    endtask

    task body();
        if(skip_dir_cases)
            return;
        for (int i=0; i<no_dir_test_cases; i++) begin
            start_item(trans);
            trans.trans_ID      =test_case_mem[i][44:37];
            trans.A	    		=test_case_mem[i][36:29];
            trans.B 			=test_case_mem[i][28:21];
            trans.cmd	        =test_case_mem[i][20:17];
            trans.mode	        =test_case_mem[i][16];
            trans.res           =test_case_mem[i][15:8];
            trans.flag          =test_case_mem[i][7:0];
            trans.isRandom      =0;
            finish_item(trans);
            `uvm_info("DIR_SEQ", "Sent packet", UVM_HIGH)            
        end
    endtask
endclass
