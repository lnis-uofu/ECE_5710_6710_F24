// This will be a testbench for 2 input xor gate
`timescale 1ns/1ps
module xor2_tb;
  
  // Inputs
  reg a;
  reg b;
  
  // Output
  wire out;
  
  // Instantiate the XOR gate module
  xor2 dut (
    .a(a),
    .b(b),
    .out(out)
  );
  
  initial begin
    // Initialize inputs
    a = 0; b = 0;
    // Add a delay before starting the simulation
    #10;
    b = 0; a = 1;
    #10;
    b = 1; a = 0;
    #10;
    b = 1; a = 1;
    #10;

    
    // End the simulation
    $stop;
  end
  
  
endmodule
