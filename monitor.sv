class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)
    
    virtual alu_if.MON intf;
    uvm_analysis_port#(transaction) ap;
    transaction trans;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction 

    function void build_phase(uvm_phase phase);
        ap = new("ap", this);
        if(!uvm_config_db#(virtual alu_if)::get(this, "*", "vif", intf))
            `uvm_fatal(get_name(), "Cant get virtual interface");
        trans = new("trans");
    endfunction
    
    task run_phase(uvm_phase phase);
    forever begin
        @(intf.mon_cb);
        @(intf.mon_cb);
        trans.A   = intf.mon_cb.A;
        trans.B   = intf.mon_cb.B;
        trans.mode  = intf.mon_cb.mode;
        trans.cmd   = intf.mon_cb.cmd;
        trans.res   = intf.mon_cb.res;
        trans.flag = intf.mon_cb.flag;
        `uvm_info("MON", $sformatf("Sampled Packet is %s", trans.convert2string), UVM_MEDIUM)
        ap.write(trans);
    end
endtask
    
endclass 
