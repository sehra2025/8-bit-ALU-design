import uvm_pkg::*;
class driver extends uvm_driver#(transaction);
    `uvm_component_utils(driver)
    
    transaction trans;
    virtual Interface.DRV drv_if;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction 

    function void build_phase(uvm_phase phase);
        trans = transaction::type_id::create("trans");
        if(!uvm_config_db#(virtual alu_if)::get(this, "*", "vif", drv_if))
            `uvm_fatal(get_type_name(), "Interface not found")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(trans);
            drive();
            `uvm_info(get_type_name(), $sformatf("DRIVED PACKET:: %s", trans.convert2string), UVM_MEDIUM);
            seq_item_port.item_done();
        end
    endtask

    task drive();
        @(drv_if.drv_cb) begin
            drv_if.drv_cb.A <= trans.A;
            drv_if.drv_cb.B <= trans.B;
            drv_if.drv_cb.mode <= trans.mode;
            drv_if.drv_cb.cmd <= trans.cmd;
            @(drv_if.drv_cb);
        end
    endtask

endclass
