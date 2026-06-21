`timescale 1ns / 1ps

module data_memory(
    input clk,
    input r_en,
    input w_en,
    input [31:0] address,
    input [31:0] data_in,
    input [2:0] func3,
    output reg [31:0] data_out
    );

    reg [31:0] dmem[0:1023];
    // Write Logic
    always @(posedge clk) begin
        if(w_en) begin
            case(func3)
                3'b000 : // SB 
                    case(address[1:0])
                            2'b00 : dmem[address[31:2]][7:0] <= data_in[7:0];
                            2'b01 : dmem[address[31:2]][15:8] <= data_in[7:0];
                            2'b10 : dmem[address[31:2]][23:16] <= data_in[7:0];
                            2'b11 : dmem[address[31:2]][31:24] <= data_in[7:0];
                    endcase
                3'b001 : // SH
                         if(address[1] == 1'b0)
                            dmem[address[31:2]][15:0] <= data_in[15:0];
                         else 
                            dmem[address[31:2]][31:16] <= data_in[15:0];
                3'b010 : // SW 
                        dmem[address[31:2]] <= data_in;
                default : dmem[address[31:2]] <= data_in;
            endcase
        end
    end

    // Read Logic

    always @(*) begin
        if(r_en) begin
        case(func3)
            3'b000 : // LB
                case(address[1:0])
                        2'b00: data_out = {{24{dmem[address[31:2]][7]}},  dmem[address[31:2]][7:0]};
                        2'b01: data_out = {{24{dmem[address[31:2]][15]}}, dmem[address[31:2]][15:8]};
                        2'b10: data_out = {{24{dmem[address[31:2]][23]}}, dmem[address[31:2]][23:16]};
                        2'b11: data_out = {{24{dmem[address[31:2]][31]}}, dmem[address[31:2]][31:24]};
                endcase 
            3'b001 : // LH
                    if (address[1] == 1'b0)
                        data_out = {{16{dmem[address[31:2]][15]}}, dmem[address[31:2]][15:0]};
                    else
                        data_out = {{16{dmem[address[31:2]][31]}}, dmem[address[31:2]][31:16]};
            3'b010 : // LW
                    data_out = dmem[address[31:2]];
            3'b100 : // LBU
                    case (address[1:0])
                        2'b00: data_out = {24'b0, dmem[address[31:2]][7:0]};
                        2'b01: data_out = {24'b0, dmem[address[31:2]][15:8]};
                        2'b10: data_out = {24'b0, dmem[address[31:2]][23:16]};
                        2'b11: data_out = {24'b0, dmem[address[31:2]][31:24]};
                    endcase
            3'b101 : // LHU
                    if (address[1] == 1'b0)
                        data_out = {16'b0, dmem[address[31:2]][15:0]};
                    else
                        data_out = {16'b0, dmem[address[31:2]][31:16]};
                default: data_out = 32'b0;
        endcase
        end
        else begin
            data_out = 32'b0;
        end
    end
endmodule
