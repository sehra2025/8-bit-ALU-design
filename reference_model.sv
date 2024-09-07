class reference_model extends uvm_component;
    `uvm_component_utils(reference_model)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function transaction get_ref_val(transaction rcvd_trans);
        if(rcvd_trans.mode) begin
            rcvd_trans.res = 'z; 
            rcvd_trans.flag = '0; 
            case(cmd)
                0: {rcvd_trans.flag[0],rcvd_trans.res} = rcvd_trans.A+rcvd_trans.B;
                1: {rcvd_trans.flag[0],rcvd_trans.res} = rcvd_trans.A-rcvd_trans.B;
                2: {rcvd_trans.flag[1],rcvd_trans.res} = rcvd_trans.A+1;
                3: {rcvd_trans.flag[1],rcvd_trans.res} = rcvd_trans.A-1;
                4: {rcvd_trans.flag[1],rcvd_trans.res} = rcvd_trans.B+1;
                5: {rcvd_trans.flag[1],rcvd_trans.res} = rcvd_trans.B-1;
                6: rcvd_trans.res = rcvd_trans.A-rcvd_trans.B;
                default:
                begin
                    rcvd_trans.res = 'z; 
                    rcvd_trans.flag = '0; 
                end
            endcase
        end
        else begin
            rcvd_trans.res = 'z; 
            rcvd_trans.flag = '0; 
            case(cmd)
                0: rcvd_trans.res = rcvd_trans.A&rcvd_trans.B;
                1: rcvd_trans.res = rcvd_trans.A|rcvd_trans.B;
                2: rcvd_trans.res = rcvd_trans.A^rcvd_trans.B;
                3: rcvd_trans.res = ~rcvd_trans.A;
                4: rcvd_trans.res = ~rcvd_trans.B;
                5: rcvd_trans.res = rcvd_trans.A<<1;
                6: rcvd_trans.res = rcvd_trans.A>>1;
                7: rcvd_trans.res = rcvd_trans.B<<1;
                8: rcvd_trans.res = rcvd_trans.B>>1;
                default:
                begin
                    rcvd_trans.res = 'z; 
                    rcvd_trans.flag = '0; 
                end
            endcase
        end
        
        `uvm_info("RM", $sformatf("Generated Expected Packet:: %s", rcvd_trans.convert2string()), UVM_HIGH)
        
        return rcvd_trans;
        
    endfunction
endclass
