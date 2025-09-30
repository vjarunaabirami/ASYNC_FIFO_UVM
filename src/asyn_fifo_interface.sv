interface async_fifo_interface(input wclk, rclk);
  bit [7:0] wdata;
  bit [7:0] rdata;
  bit       winc;
  bit       rinc;
  bit       wrst_n;
  bit       rrst_n;
  bit       wfull;
  bit       rempty;

  clocking write_drv_cb @(posedge wclk);
    default input #0 output #0;
    input wfull;
    input rempty;
    output wrst_n;
    output winc;
    output wdata;
  endclocking

  clocking read_drv_cb @(posedge rclk);
    default input #0 output #0;
    input rempty;
    input wfull;
    output rrst_n;
    output rinc;
    output rdata; 
  endclocking

  clocking write_mon_cb @(posedge wclk);
    default input #0 output #0;
    input wfull;
    input rempty;
    input wrstn;
    input winc;
    input wdatal;
  endclocking

  clocking read_mon_cb @(posedge rclk);
    default input #0 output #0;
    input wfull;
    input rempty;
    input rrstn;
    input rinc;
    input rdata;
  endclocking

  modport WRITE_DRV_MP (clocking write_drv_cb);
  modport READ_DRV_MP (clocking read_drv_cb);
  modport WRITE_MON_MP (clocking write_mon_cb);
  modport READ_MON_MP (clocking read_mon_cb);

endinterface
