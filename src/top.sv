 //import uvm_pkg::*;  
`include "uvm_pkg.sv"
`include "uvm_macros.svh"
`include "async_fifo_pkg.sv"
`include "asyn_fifo_interface.sv"
`include "FIFO.v"

module top;
  
  import uvm_pkg::*;  
  import async_fifo_pkg::*;
  
  bit wclk;
  bit rclk;
  bit rrst_n;
  bit wrst_n;
  
  always #5 wclk = ~wclk;
  always #10 rclk = ~rclk;
  
  initial begin 
    wclk = 0;
    rclk = 0;
    rrst_n = 0;
    wrst_n = 0;
    
  #20 rrst_n = 1;
  #20 wrst_n = 1;
  end
  
  
  async_fifo_interface intf(wclk,rclk,wrst_n,rrst_n);
  
  FIFO dut(.rdata(intf.rdata),
           .wfull(intf.wfull),
           .rempty(intf.rempty),
           .wdata(intf.wdata),
           .winc(intf.winc),
           .wclk(wclk),
           .wrst_n(wrst_n),
           .rinc(intf.rinc),
           .rclk(rclk),
           .rrst_n(rrst_n));
  
  initial begin 
    uvm_config_db #(virtual  async_fifo_interface)::set(null,"*","vif",intf);
    $dumpfile("wave.vcd");
    $dumpvars;
  end
  
  initial begin 
    run_test("test");
    #10000 $finish;
  end
endmodule
