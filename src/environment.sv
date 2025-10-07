class environment extends uvm_env;

  `uvm_component_utils(environment)

  read_agent  rd_agt;
  write_agent wrt_agt;
  subscriber  sub;
  scoreboard  scb;
  virtual_sequencer v_seqr; 

  function new(string name = "environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    rd_agt  = read_agent::type_id::create("rd_agt",this);
    wrt_agt = write_agent::type_id::create("wrt_agt",this);
    sub     = subscriber::type_id::create("sub",this);
    scb     = scoreboard::type_id::create("scb",this);
    v_seqr = virtual_sequencer::type_id::create("v_seqr",this);

  endfunction

 function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  // Connect monitors to subscriber
  wrt_agt.mon.write_port.connect(sub.write_mon_port);  
  rd_agt.mon.read_port.connect(sub.read_mon_port);    

  rd_agt.mon.read_port.connect(scb.read_fifo.analysis_export);
  wrt_agt.mon.write_port.connect(scb.write_fifo.analysis_export);

  // Connect virtual sequencer to agents
  v_seqr.wr_seqr = wrt_agt.seqr;
  v_seqr.rd_seqr = rd_agt.seqr;
endfunction




endclass


