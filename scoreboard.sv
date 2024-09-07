class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    
    uvm_analysis_imp#(transaction, scoreboard) ap_export;
    reference_model rm;
    transaction act_trans, exp_trans;
    int passCnt, failCnt;

    function void check();
        if (act_trans.do_compare(exp_trans)) begin
            `uvm_info("SCB", $sformatf("%s\nStatus:: PASSED", act_trans.convert2string()), UVM_NONE)
            passCnt++;
        end
        else begin
            `uvm_error("SCB", $sformatf("Actual Packet::%s\nExpected Packet::%s\nStatus:: FAILED", 
                            act_trans.convert2string(), exp_trans.convert2string()))
            failCnt++;
        end
    endfunction

    function void print_report(int f_id);
        real totCnt;
        totCnt = passCnt + failCnt;
        $fdisplay(f_id, "**************************** Test Summary ***************************");
        $fdisplay(f_id, "No of Total Cases:  %0d", totCnt);
        $fdisplay(f_id, "No of Passed Cases: %0d", passCnt);
        $fdisplay(f_id, "No of Failed Cases: %0d", failCnt);
        $fdisplay(f_id, "Failure rate: %0.2f %%", (failCnt/totCnt) * 100.0);
        $fdisplay(f_id, "*********************************************************************");
    endfunction
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction 

    function void build_phase(uvm_phase phase);
        ap_export = new("ap_export", this);
        rm = reference_model::type_id::create("rm", this);
        act_trans = new("act_trans");
    endfunction

    function void write(transaction trans);
        act_trans.do_copy(trans);
        `uvm_info("scoreboard", $sformatf("Received Packet:: %s", act_trans.convert2string()), UVM_HIGH)
        exp_trans = rm.get_ref_val(trans);
        check();
    endfunction
    
    function void report_phase(uvm_phase phase);
        int f_id;
        super.report_phase(phase);
        f_id = this.get_report_file_handle(UVM_INFO | UVM_ERROR, "SCB");
        this.report_summarize(f_id);
        print_report(f_id);
    endfunction
    
endclass
