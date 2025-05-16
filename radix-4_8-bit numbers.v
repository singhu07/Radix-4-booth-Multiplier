//This is the implementation of radix-4 multiplier for 8-bit numbers.
//This works for both positive and negative numbers.
`timescale 1ns / 1ps
module radix4_8bit(
    input clk,
    input rst,
    input start,
    input [7:0] a_i,
    input [7:0] b_i,
    output reg [15:0] result,
    output reg done
);
parameter s0  = 4'b0000, //idle
          s1  = 4'b0001, //load
          s2  = 4'b0010, //decode
          s3  = 4'b0011, //result
          s4  = 4'b0100; //done
          
reg [3:0] pr_state, nx_state;
reg [7:0] a;
reg [2:0] g0, g1, g2, g3;
reg [15:0] pp1, pp2, pp3, pp4;
// control signals
reg load, decode_en, load_result,done_i;  
 
always@(posedge clk)begin
    if(rst)begin
        a <= 8'b0;
        g0 <= 3'b0;
        g1 <= 3'b0;
        g2 <= 3'b0;
        g3 <= 3'b0;
        pp1 <= 16'b0;
        pp2 <= 16'b0;
        pp3 <= 16'b0;
        pp4 <= 16'b0;
        result <= 16'b0;
        done <= 1'b0;
    end else begin
    
    if (load) begin
        a <= a_i;
        g0 <= {b_i[1], b_i[0], 1'b0};
        g1 <= {b_i[3], b_i[2], b_i[1]};
        g2 <= {b_i[5], b_i[4], b_i[3]};
        g3 <= {b_i[7], b_i[6], b_i[5]};
    end
    if (decode_en) begin
        case (g0)
            3'b000, 3'b111: pp1 <= 16'b0;                             // 0
            3'b001, 3'b010: pp1 <= {{8{a[7]}}, a};                    // +A
            3'b011:         pp1 <= {{7{a[7]}}, a, 1'b0};              // +2A
            3'b100:         pp1 <= -{{7{a[7]}}, a, 1'b0};             // -2A
            3'b101, 3'b110: pp1 <= -{{8{a[7]}}, a};                   // -A
            default:        pp1 <= 16'b0;
        endcase
//{{8{a[7]}},a}
        case (g1)
            3'b000, 3'b111: pp2 <= 16'b0; //0
            3'b001, 3'b010: pp2 <= ({{8{a[7]}}, a} << 2);
            3'b011:         pp2 <= ({{7{a[7]}}, a, 1'b0} << 2);         // +2A
            3'b100:         pp2 <= ((-{{7{a[7]}}, a, 1'b0}) <<2);  // -2A
            3'b101, 3'b110: pp2 <= ((-{{8{a[7]}}, a}) << 2);        // -A
            default:        pp2 <= 16'b0;
        endcase
        
        case (g2)
            3'b000, 3'b111: pp3 <= 16'b0; //0
            3'b001, 3'b010: pp3 <= ({{8{a[7]}}, a} << 4);               // +A
            3'b011:         pp3 <= ({{7{a[7]}}, a, 1'b0} << 4);         // +2A
            3'b100:         pp3 <= ((-{{7{a[7]}}, a, 1'b0}) <<4);  // -2A
            3'b101, 3'b110: pp3 <= ((-{{8{a[7]}}, a}) << 4);        // -A
            default:        pp3 <= 16'b0;
        endcase
        
        case (g3)
            3'b000, 3'b111: pp4 <= 16'b0; //0
            3'b001, 3'b010: pp4 <= ({{8{a[7]}}, a} << 6 );               // +A
            3'b011:         pp4 <= ({{7{a[7]}}, a, 1'b0} << 6);         // +2A
            3'b100:         pp4 <= ((-{{7{a[7]}}, a, 1'b0}) << 6);  // -2A
            3'b101, 3'b110: pp4 <= ((-{{8{a[7]}}, a}) << 6);        // -A
            default:        pp4 <= 16'b0;
        endcase
        
    end
    if(load_result) begin
        result <= pp1 + pp2 + pp3 + pp4;
        done <= done_i;
    end
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
