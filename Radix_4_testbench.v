// Testbench to test radix_4 multiplication of 2 4-bit numbers
`timescale 1ns / 1ps
module tb_radix_4_using_controller;

parameter period = 10;

reg clk;
reg rst;
reg start;
reg [3:0] a_in, b_in;
wire [7:0] result;
wire done;

radix_4_using_controller uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .a_in(a_in),
    .b_in(b_in),
    .result(result),
    .done(done)
);

// Clock generation
initial begin
    clk = 0;
    forever #(period/2) clk = ~clk;
end

initial begin
    $monitor("Time=%0t | A=%b B=%b | Result=%b (%0d) | Done=%b",
             $time, a_in, b_in, result, result, done);

    // Reset and initial values
    rst = 1;
    start = 0;
    a_in = 0;
    b_in = 0;
    #(100 * period);

    rst = 0;
    #(period);

    // Apply inputs
    a_in = 4'b1101;  // A = 13
    b_in = 4'b1011;  // B = 11
    start = 1;
    #(period);
    start = 0;

    // Wait a few cycles for FSM to finish
    #(5 * period);

    $display("Final Result (Binary): %b", result);
    $display("Final Result (Decimal): %0d", result);
    $finish;
end

endmodule
