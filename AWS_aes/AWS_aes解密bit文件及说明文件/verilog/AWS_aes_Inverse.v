`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/24/2019 09:08:07 AM
// Design Name: 
// Module Name: AWS_aes_Inverse
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


module AWS_aes_Inverse(  sclk, rst_n, key_bus,
                         qspi_d0, qspi_d1, qspi_d2, qspi_d3, I_qspi_cs, I_qspi_clk,
                         raw_data, DONE1,  led_en
                         );
                        
            input   sclk;
            input   rst_n;    
            input [3:0] key_bus;
            output [7:0] raw_data;
            output DONE1;
            output led_en; 
            
            input   I_qspi_cs;
            input   I_qspi_clk;       
            inout   qspi_d0;
            inout   qspi_d1;
            inout   qspi_d2;
            inout   qspi_d3; 
                        
            wire clk_out50M, clk_out25M;
            wire locked;  
            
            wire web;
            wire [7:0] addrb, dinb, doutb;
            
            wire [127:0] key_data;
            wire kld;
            
            wire [7:0] ram_addra;
            wire [7:0] ram_data;
            
            wire ld;  
            wire [127:0] aes_data; 
            
            wire done_out;
            wire [127:0] text_out; 
            
            wire leden1;  
        
        clk_wiz_0 clk_wiz_0_inst(
                                   // Clock out ports
                                   .clk_out1(clk_out50M),     // output clk_out1
                                   .clk_out2(clk_out25M),     // output clk_out2
                                   // Status and control signals
                                   .reset(!rst_n), // input reset
                                   .locked(locked),       // output locked
                                  // Clock in ports
                                   .clk_in1(sclk) // input clk_in1        
                                    );                  
          
        key_128test key_128test_inst(
                                      .sclk(clk_out50M),
                                      .rst_n(locked),
                                      .key_bus(key_bus),
                                      .key_data(key_data),
                                      .en(kld)
                                       );
                                       
        aes_inv_cipher_top aes_inv_cipher_top_inst(
                                                    .clk(clk_out50M), 
                                                    .rst(locked), 
                                                    .kld(kld), 
                                                    .ld(ld), 
                                                    .done(done_out),
                                                    .key(key_data), 
                                                    .text_in(aes_data), 
                                                    .text_out(text_out) 
                                                     ); 
                 
        ram_count ram_count_inst(
                                 .clk(clk_out50M), 
                                 .rst_n(locked), 
                                 .add8(addrb), //地址判断端口
                                 .o_valid(web), //未使用
                                 .kdone(kld), //未使用
                                 .ram_addra(ram_addra), 
                                 .ram_data(ram_data), 
                                 .ld(ld), 
                                 .aes_data(aes_data)
                                  );         
                        
        blk_mem_gen_0 blk_mem_gen_0_inst(
                                         .clka(clk_out50M),    // input wire clka
                                         .wea(),      // input wire [0 : 0] wea/*******未使用端口********/
                                         .addra(ram_addra),  // input wire [7 : 0] addra
                                         .dina(),    // input wire [7 : 0] dina/*******未使用端口********/
                                         .douta(ram_data),  // output wire [7 : 0] douta
                                         
                                         .clkb(I_qspi_clk),    // input wire clkb//
                                         .web(web),      // input wire [0 : 0] web
                                         .addrb(addrb),  // input wire [7 : 0] addrb
                                         .dinb(dinb),    // input wire [7 : 0] dinb
                                         .doutb(doutb)  // output wire [7 : 0] doutb/*******未使用端口********/
                                          );
                                    
        QSPI_slave QSPI_slave_inst(
                                   //QSPI
                                   .I_qspi_clk      (I_qspi_clk)    , 
                                   .I_qspi_cs       (I_qspi_cs)    ,
                                   .IO_qspi_io0     (qspi_d0)    , 
                                   .IO_qspi_io1     (qspi_d1)    , 
                                   .IO_qspi_io2     (qspi_d2)    , 
                                   .IO_qspi_io3     (qspi_d3)    , 
                                   //other
                                   .o_addr          (addrb)    ,
                                   .o_data          (dinb)    ,
                                   .i_data          (doutb)    ,/*******未使用端口********/
                                   .o_valid         (web)    ,
                                   .i_valid         ()/*******未使用端口********/
                                   );
                                   
        data_compression data_compression_inst(
                                               .clk(clk_out50M), 
                                               .rst_n(locked), 
                                               .done(done_out), 
                                               .test128_in(text_out), 
                                               .DONE1(DONE1), 
                                               .en(leden1), 
                                               .raw_data(raw_data)
                                               );
                        
        LED_control LED_control_inst(
                                      .clk(clk_out50M), 
                                      .rst_n(locked), 
                                      .en(leden1), 
                                      .raw_data(raw_data), 
                                      .led_en(led_en)
                                       );
         
endmodule
