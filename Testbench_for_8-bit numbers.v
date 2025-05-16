//Testbench for 8-bit numbers
`timescale 1ns / 1ps
module testbench;

parameter period = 10;

reg clk;
reg rst;
reg start;
reg [7:0] a_i, b_i;
wire [15:0] result;
wire done;

radix4_8bit uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .a_i(a_i),
    .b_i(b_i),
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
             $time, a_i, b_i, result, result, done);

    // Reset and initial values
    rst = 1;
    start = 0;
    a_i = 0;
    b_i = 0;
    #(10 * period);

    rst = 0;
    #(period);

    // Apply inputs
    //a_i = 8'b00010110;
    a_i = 8'b11101010;
    b_i =8'b00000101;  
    start = 1;
    #(period);
    start = 0;

    // Wait a few cycles for FSM to finish
    #(5 * period);

    $display("Final Result (Binary): %b", result);
    $display("Final Result (Decimal): %0d", $signed(result));
    $finish;
end

endmodule
