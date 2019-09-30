`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2019 02:23:00 PM
// Design Name: 
// Module Name: LED_control
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


module LED_control(clk, rst_n, en, raw_data, led_en);

    input clk, rst_n;
    input en;
    input [7:0] raw_data;
    output reg led_en;

    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            begin
                led_en <= 0;
            end
        else if((en) && (raw_data > 8'b0001_1111))
            begin
                led_en <= 1;
            end
        else if((en) && (raw_data <= 8'b0001_1111))
            begin
                led_en <= 0;
            end
        else
            begin
                led_en <= led_en;
            end
    end
    
endmodule
