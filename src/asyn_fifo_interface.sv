interface async_fifo_interface(input wclk, rclk,wrst_n,rrst_n);
  bit [7:0] wdata;
  bit [7:0] rdata;
  bit       winc;
  bit       rinc;
  //bit       wrst_n;
 // bit       rrst_n;
  bit       wfull;
  bit       rempty;

  clocking write_drv_cb @(posedge wclk);
    default input #0 output #0;
    input wfull;
    output winc;
    output wdata;
  endclocking

  clocking read_drv_cb @(posedge rclk);
    default input #0 output #0;
    input rempty;
    input rdata;
    output rinc;
  endclocking

  clocking write_mon_cb @(posedge wclk);
    default input #0 output #0;
    input wfull;
    input winc;
    input wdata;
  endclocking

  clocking read_mon_cb @(posedge rclk);
    default input #0 output #0;
    input rempty;
    input rinc;
    input rdata;
  endclocking

  modport WRITE_DRV_MP (clocking write_drv_cb);
  modport READ_DRV_MP (clocking read_drv_cb);
  modport WRITE_MON_MP (clocking write_mon_cb);
  modport READ_MON_MP (clocking read_mon_cb);

endinterface

/*
// =====================================================
// ASSERTION-1 : FULL and EMPTY should never be high together
// =====================================================
property p1;
  @(posedge rclk) disable iff (!rrst_n)
    !(rempty && wfull);
endproperty

full_empty_check:
  assert property (p1)
    $info("ASSERTION-1 PASSED: FULL & EMPTY CHECK");
  else
    $error("ASSERTION-1 FAILED: FULL & EMPTY CHECK");


// =====================================================
// ASSERTION-2 : Write data should never be unknown when winc is high
// =====================================================
property p2;
  @(posedge wclk) disable iff (!wrst_n)
    winc |-> !($isunknown(wdata));
endproperty

wdata_check:
  assert property (p2)
    $info("ASSERTION-2 PASSED: WDATA CHECK");
  else
    $error("ASSERTION-2 FAILED: WDATA CHECK");


// =====================================================
// ASSERTION-3 : When FIFO is full and write is attempted, wdata must stay stable
// =====================================================
property p3;
  @(posedge wclk) disable iff (!wrst_n)
    (winc && wfull) |-> $stable(wdata);
endproperty

wdata_stability_check:
  assert property (p3)
    $info("ASSERTION-3 PASSED: WDATA STABILITY CHECK");
  else
    $error("ASSERTION-3 FAILED: WDATA STABILITY CHECK");


// =====================================================
// ASSERTION-4 : Read data should never be unknown when valid read occurs
// =====================================================
property p4;
  @(posedge rclk) disable iff (!rrst_n)
    (rinc && !rempty) |-> !($isunknown(rdata));
endproperty

rdata_check:
  assert property (p4)
    $info("ASSERTION-4 PASSED: RDATA CHECK");
  else
    $error("ASSERTION-4 FAILED: RDATA CHECK");
*/
