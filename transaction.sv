import uvm_pkg::*;
class transaction extends uvm_sequence_item;
    `uvm_object_utils(transaction)
    
    rand logic [7:0] A, B;
    rand logic [3:0] cmd;
    rand logic mode;
    
    constraint cmd_val{
        if(mode==1)
            cmd inside{[0:6]);
        else 
            cmd inside{[0:8]};
    };
    
    logic [7:0] res , flag;
    
    static bit [7:0] trans_id; //transaction_id
    static bit isRandom;       //control bit
    
    function new(string name = "trans");
        super.new(name);
        init_val();
    endfunction 
    
    function void pre_randomize();
        trans_id++;
    endfunction
    
    function void init_val();
        A='z;
        B='z;
        cmd='z;
        mode='z;
        flag='0;
        res='z;
    endfunction
    
    function void do_print(uvm_printer printer);
        $display("Transaction ID: %0d", trans_ID);
        printer.print_field("A", A, 8, UVM_UNSIGNED);
        printer.print_field("B", B, 8, UVM_UNSIGNED);
        printer.print_field("Mode", mode, 1, UVM_BIN);
        printer.print_field("CMD", cmd, 4, UVM_BIN);
        printer.print_field("Result", res, 9, UVM_UNSIGNED);
        printer.print_field("flag", flag, 1, UVM_UNSIGNED);
    endfunction   
    
    function string convert2string();
        string s;
        s = $sformatf("Packet ID: %0d", trans_ID);
        s = $sformatf("%s\nInput: A = %b, B = %b, cmd = %b, mode = %b",
                s, A, B, cmd, mode);
        s = $sformatf("%s\nOuput: result = %b, flag = %b",
                s, res, flag);
        return s;
    endfunction
    
    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        transaction _rhs;
        bit cmp;
        if(!$cast(_rhs, rhs))
            `uvm_fatal(get_type_name(), "object passed is not compatible with Transaction");
        
        cmp = this.res===_rhs.res && this.flag===_rhs.flag;
        return cmp;
    endfunction
    
    function void do_copy(uvm_object rhs);
        transaction _rhs;
        if(!$cast(_rhs, rhs))
            `uvm_fatal(get_type_name(), "rhs is not compatible with this class");
        
        A = _rhs.A;
        B = _rhs.B;
        cmd = _rhs.cmd;
        mode = _rhs.mode;
        res = _rhs.res;
        flag = _rhs.flag;
    endfunction
    
endclass
