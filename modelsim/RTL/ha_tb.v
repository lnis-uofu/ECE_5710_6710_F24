`timescale 1ns/1ps
module ha_tb;
  reg a;
  reg b;
  
  wire sum;
  wire carry;
  
  ha dut (
    .a(a),
    .b(b),
    .sum(sum),
    .carry(carry)
  );
  
  initial begin
    a = 0; b = 0;
    // Add a delay before starting the simulation
    #20;
    b = 0; a = 1;
    #20;
    b = 1; a = 0;
    #20;
    b = 1; a = 1;
    #20;

    $stop;
  end
  
  
endmodule
