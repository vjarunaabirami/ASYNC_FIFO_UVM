`uvm_analysis_imp_decl(_write_mon_sub)
`uvm_analysis_imp_decl(_read_mon_sub)

class subscriber extends uvm_component;
  `uvm_component_utils(subscriber)

  uvm_analysis_imp_write_mon_sub #(async_fifo_write_sequence_item, subscriber) write_mon_port;
  uvm_analysis_imp_read_mon_sub  #(async_fifo_read_sequence_item, subscriber)  read_mon_port;

  async_fifo_write_sequence_item write_trans;
  async_fifo_read_sequence_item  read_trans;

  covergroup write_cov;
    option.per_instance = 1;
    WDATA_CVG : coverpoint write_trans.wdata { bins wdata_bins[] = {[0:255]}; }
    WINC_CVG  : coverpoint write_trans.winc  { bins winc_bins[]  = {0,1}; }
  endgroup

  covergroup read_cov;
    option.per_instance = 1;
    RDATA_CVG : coverpoint read_trans.rdata { bins rdata_bins[] = {[0:255]}; }
    RINC_CVG  : coverpoint read_trans.rinc  { bins rinc_bins[]  = {0,1}; }
  endgroup

  function new(string name="subscriber", uvm_component parent=null);
    super.new(name, parent);
    write_mon_port = new("write_mon_port", this);
    read_mon_port  = new("read_mon_port", this);
    write_cov = new();
    read_cov  = new();
  endfunction

  function void write_write_mon_sub(async_fifo_write_sequence_item t);
    write_trans = t;
    write_cov.sample();
    `uvm_info(get_type_name(),
              $sformatf("Input Coverage: WDATA=0x%0h, WINC=%0b",
                        write_trans.wdata, write_trans.winc),
              UVM_LOW);
  endfunction

  function void write_read_mon_sub(async_fifo_read_sequence_item t);
    read_trans = t;
    read_cov.sample();
    `uvm_info(get_type_name(),
              $sformatf("Output Coverage: RDATA=0x%0h, RINC=%0b",
                        read_trans.rdata, read_trans.rinc),
              UVM_LOW);
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),
              $sformatf("Write Coverage = %0.2f%%", write_cov.get_coverage()),
              UVM_LOW);
    `uvm_info(get_type_name(),
              $sformatf("Read Coverage  = %0.2f%%", read_cov.get_coverage()),
              UVM_LOW);
  endfunction

endclass
