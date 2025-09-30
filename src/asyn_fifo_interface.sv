interface async_fifo_interface(input wclk, rclk);
  bit [7:0] wdata;
  bit [7:0] rdata;
  bit       wclk_en;
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
    

  endclocking


