`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2019 01:29:54 PM
// Design Name: 
// Module Name: data_compression
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module data_compression(clk, rst_n, done, test128_in, DONE1, en, raw_data);

    input clk, rst_n;
    input done;
    input [127:0] test128_in;
    output reg en;
    output reg DONE1;
    output reg [7:0] raw_data;
    
    reg done_1;

    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            begin
                raw_data <= 0;
            end
        else if(done)
            begin
                raw_data[7] <= test128_in[115];
                raw_data[6] <= test128_in[99];
                raw_data[5] <= test128_in[83];
                raw_data[4] <= test128_in[67];
                
                raw_data[3] <= test128_in[51];
                raw_data[2] <= test128_in[35];
                raw_data[1] <= test128_in[19];
                raw_data[0] <= test128_in[3];
            end
        else
            raw_data <= raw_data;
    end
    
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            begin
                done_1 <= 0;
            end
        else if(done)
            begin
                done_1 <= 1;
            end
        else 
            begin
                done_1 <= 0;
            end  
    end
    
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            begin
                en <= 0;
                DONE1 <= 0;
            end
        else if(done_1)
            begin
                en <= 1;
                DONE1 <= 1;
            end
        else 
            begin
                en <= 0;
                DONE1 <= 0;
            end  
    end


endmodule
