class test extends uvm_test;
  
  `uvm_component_utils(test)

  environment env_o;
  virtual_sequence v_seq;

  function new(string name = "test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o   = environment::type_id::create("env_o", this);
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);   
    v_seq = virtual_sequence::type_id::create("v_seq");
    v_seq.start(env_o.v_seqr);
    phase.drop_objection(this);
  endtask

endclass

