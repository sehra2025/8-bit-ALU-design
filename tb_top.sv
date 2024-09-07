`timescale 1ns / 1ps
module tb_top();

    logic clk;
    initial clk<=0;
    always #5 clk=~clk;
    
    int no_dir = 84;
    int no_rnd = 100;
    
    Interface intf(clk);
    
    AlU_rtl dut( .A(intf.A) , .B(intf.B) , .CLK(clk), .RST(intf.rst) , 
                 .CMD(intf.cmd) , .MODE(intf.mode) , .RES(intf.res) , 
                 .Flag(intf.flag)
                );
                
     initial begin       
        no_dir = 84;
        no_rnd = 100;
        
        uvm_config_db#(int)::set(null, "seq.*", "no_dir", no_dir);
        uvm_config_db#(int)::set(null, "seq.*", "no_rnd", no_rnd);
        uvm_config_db#(string)::set(null, "seq.*", "file_name", "new_stimulus.txt");
        uvm_config_db#(virtual alu_if)::set(null, "*", "vif", intf);

        run_test("base_test");
     end

endmodule
