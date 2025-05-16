// Radix_4 multiplier for 2 4 bit number
`timescale 1ns / 1ps
module radix_4_using_controller(
    input clk,
    input rst,
    input start,
    input [3:0] a_in,
    input [3:0] b_in,
    output reg [7:0] result,
    output reg done
);
parameter s0  = 4'b0000, //idle
          s1  = 4'b0001, //load
          s2  = 4'b0010, //decode
          s3  = 4'b0011, //result
          s4  = 4'b0100; //done
          
reg [3:0] pr_state, nx_state;
reg [3:0] a;
reg [1:0] g0, g1;
reg [7:0] pp1, pp2;
// control signals
reg load, decode_en, load_result,done_i;  
 
always@(posedge clk)begin
    if(rst)begin
        a <= 4'b0;
        g0 <= 2'b0;
        g1 <= 2'b0;
        pp1 <= 8'b0;
        pp2 <= 8'b0;
        result <= 8'b0;
        done <= 1'b0;
    end
    if (load) begin
        a <= a_in;
        g0 <= b_in[1:0];
        g1 <= b_in[3:2];
    end
    if (decode_en) begin
        case (g0)
            2'b00: pp1 <= 8'b00000000;
            2'b01: pp1 <= {4'b0000, a};              
            2'b10: pp1 <= {3'b000, a, 1'b0};         
            2'b11: pp1 <= {3'b000, a, 1'b0} + {4'b0000, a}; 
            default: pp1 <= 8'b00000000;
        endcase

        case (g1)
            2'b00: pp2 <= 8'b00000000;
            2'b01: pp2 <= ({4'b0000, a} << 2);              
            2'b10: pp2 <= ({3'b000, a, 1'b0} << 2);         
            2'b11: pp2 <= (({3'b000, a, 1'b0} + {4'b0000, a}) << 2); 
            default: pp2 <= 8'b00000000;
        endcase
    end
    if(load_result) begin
        result <= pp1 + pp2;
        done <= done_i;
    end
    
end 
// FSM
always @(posedge clk ) begin
    if (rst)begin
     pr_state <= s0;
    end else begin
     pr_state <= nx_state;
    end 
end     

//controller FSM
always @(*)begin
    load = 0;
    decode_en = 0;
    load_result = 0;
    done_i = 0;
    
    case(pr_state)
        s0:begin
            if(start) begin
             nx_state = s1;
            end else begin
             nx_state = s0;
             end
        end
        
        s1:begin
            load = 1;
            nx_state = s2;
        end
           
        s2:begin
            decode_en = 1;
            nx_state = s3;
        end
           
        s3:begin
            load_result = 1;
            done_i = 1;
            nx_state = s0;
        end
        default: nx_state = s0;
    endcase
end
endmodule
