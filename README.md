# ASYNC_FIFO_UVM
# Asynchronous FIFO (Async FIFO) — UVM Verification

> Repository: https://github.com/vjarunaabirami/ASYNC_FIFO_UVM.git

## Project Overview

An Asynchronous FIFO (First-In, First-Out) is a specialized memory buffer designed to safely transfer data between two independent clock domains operating at different frequencies. Unlike synchronous FIFOs, where read and write share the same clock, asynchronous FIFOs handle clock domain crossing, ensuring that data written in one clock domain is correctly read in another without corruption or metastability issues.

This repository contains a UVM-based verification environment and testbench for an Async FIFO DUT (Design Under Test). The environment validates read/write behavior, data integrity, reset functionality, flag behavior (full/empty), and boundary conditions.

## Verification Objectives

* Verify correct read (`rinc`) and write (`winc`) operations.  
* Ensure data written (`wdata`) matches data read (`rdata`) in order (FIFO behavior).  
* Validate clock domain crossing between independent write and read clocks.  
* Check proper reset behavior for both write (`wrst_n`) and read (`rrst_n`) domains.  
* Verify flags: `wfull` and `rempty` accurately reflect FIFO status.  
* Test boundary conditions: writing to full FIFO, reading from empty FIFO, and simultaneous read/write at edges.  
* Ensure no unknown (X) or corrupted values appear in valid transactions.  
* Collect functional coverage and use assertions to monitor signal correctness and stability.

## DUT Interfaces (Signals)

| Signal       | Dir    | Width | Description |
| ------------ | :----: | ----: | ----------- |
| write_clk    | Input  | 1     | Controls write operations in the FIFO write domain. |
| write_rst    | Input  | 1     | Active-low reset for write domain pointers and logic. |
| write_en     | Input  | 1     | When high, writes `wdata` to FIFO (if not full). |
| write_data   | Input  | 8     | Data input bus for writing into FIFO. |
| write_full   | Output | 1     | High when FIFO is full; prevents further writes. |
| read_clk     | Input  | 1     | Controls read operations in FIFO read domain. |
| read_rst     | Input  | 1     | Active-low reset for read domain pointers and logic. |
| read_en      | Input  | 1     | When high, drives `rdata` from FIFO (if not empty). |
| read_data    | Output | 8     | Data output bus for reading from FIFO. |
| read_empty   | Output | 1     | High when FIFO is empty; prevents further reads. |

## Testbench Architecture

The verification environment follows a UVM architecture with separate read and write agents and a virtual sequencer for coordinated sequences:

* **async_fifo_write_sequence_item / async_fifo_read_sequence_item** — transaction abstraction for write/read operations.  
* **async_fifo_write_seq / async_fifo_read_seq** — sequences generating write/read transactions including normal, boundary, and randomized cases.  
* **write_sequencer / read_sequencer** — arbitrate and schedule transactions from sequences to drivers.  
* **virtual_sequencer** — coordinates read and write sequencers for simultaneous transactions.  
* **write_driver / read_driver** — convert transaction-level data to pin-level DUT signals.  
* **write_monitor / read_monitor** — sample DUT interface signals and generate transaction-level objects.  
* **write_agent / read_agent** — container for sequencer, driver, and monitor; active agents for write/read sides.  
* **subscriber** — collects functional coverage (input and output).  
* **scoreboard** — compares DUT outputs to reference model for data integrity and flag correctness.  
* **environment** — top-level container integrating agents, scoreboard, and subscriber.  
* **test** — top-level UVM test controlling sequences and environment configuration.  

## Verification Results

### Observed Design Flaws

* **Bug 1:** `write_full` flag not updating correctly due to pointer synchronization issue on `write_clk`.  
* **Bug 2:** `read_empty` flag not updating correctly due to pointer synchronization issue on `read_clk`.  

### Coverage Report

![WhatsApp Image 2025-10-07 at 22 20 38_1989b758](https://github.com/user-attachments/assets/a873cec6-40aa-4b0e-88d7-777d6bcf2600)
![WhatsApp Image 2025-10-07 at 22 22 03_7145efff](https://github.com/user-attachments/assets/1ef40982-5a0f-45b0-bcdf-5be0f3eab2ee)


## Resources
https://docs.google.com/document/d/1slvywV5etTWUGWTzVP5CzIpTR_g6Y1AI/edit
https://docs.google.com/spreadsheets/d/1BWjzOoWHHvvZZxTuIldyMqgvkjZpfAI8QzK7FbJmMm0/edit?gid=0#gid=0
