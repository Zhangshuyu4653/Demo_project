`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/25/2019 03:18:31 PM
// Design Name: 
// Module Name: ram_count
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


module ram_count(clk, rst_n, add8, o_valid, kdone, ram_addra, ram_data, ld, aes_data);

    input clk, rst_n;
    input o_valid;//未使用
    input [7:0] add8;
    input kdone;///////////////////////////需要添加的使能端
    
    input [7:0] ram_data;
    output reg [7:0] ram_addra;
    
    output reg ld;
    output reg [127:0] aes_data;
    
    reg open1, open1_1;
    reg open2;
    reg flag1, flag2;
    reg [7:0] count;
    reg [4:0] count2;
    reg read_en;
    reg [4:0] state;
    
    reg read_en_1;
    
    
    always@(posedge clk or negedge rst_n)/*检测地址数据是否写到最后一位地址*/
    begin
        if(!rst_n)
            open1 <= 0;
        else
            begin
                if(add8 == 8'b0001_0001)
                    open1 <= 1;
                else
                    open1 <= 0;
            end
    end
    
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            begin
                open1_1 <= 0;
            end
        else
            begin
                open1_1 <= open1;
            end
    end
    
    always@(posedge clk or negedge rst_n)/*open2 == 1表示已经检测到写到最后一位地址*/
    begin
        if(!rst_n)
            begin
                open2 <= 0;
            end
        else if((!open1_1) && (open1))
            begin
                open2 <= 1;
            end
        else if(flag1)
            begin
                open2 <= 0;
            end
        else
            begin
                open2 <= open2;
            end
    end    
    
    always@(posedge clk or negedge rst_n)/**延迟16个时钟周期flag标志位置1，开始读取RAM中数据**/
    begin
        if(!rst_n)
            begin
                count <= 0;
                flag1 <= 0;
            end
        else if(open2)
            begin
                if(count == 8'b0001_0000)
                      begin
                          count <= 0;
                          flag1 <= 1;
                      end
                else
                      begin
                          count <= count + 1;
                          flag1 <= 0;            
                      end
            end
        else
            begin
                count <= 0;
                flag1 <= 0;   
            end
    end
    
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            begin
                flag2 <= 0;
            end
        else if(flag1)
            begin
                flag2 <= 1;
            end
        else if(count2 == 5'b0_1111)
            begin
                flag2 <= 0;
            end
        else
            begin
                flag2 <= flag2;
            end
    end
    
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            begin
                count2 <= 0;
            end
        else if(flag2)
            begin
                count2 <= count2 + 1;
            end
        else
            begin
                count2 <= 0;
            end
    end 
    
    
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            begin
                ram_addra <= 8'b0000_0010;
            end
        else if(flag2)
            begin
                ram_addra <= ram_addra + 1;
            end
        else
            begin
                ram_addra <= 8'b0000_0010;
            end
    end 

    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            begin
                read_en <= 0;
                read_en_1 <= 0;
            end
        else if(flag2)
            begin
                read_en <= 1;
                read_en_1 <= read_en;
            end
        else
            begin
                read_en <= 0;
                 read_en_1 <= read_en;
            end
    end
    
    
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            begin
                aes_data <= 0;
                state <= 0;
                ld <= 0;
            end
        else if(read_en_1)
            begin
                case(state)
                 5'b0_0000:    begin aes_data [7:0] <= ram_data;     ld <= 0;  state <=  5'b0_0001;  end
                 5'b0_0001:    begin aes_data [15:8] <= ram_data;    ld <= 0;  state <=  5'b0_0010;  end
                 5'b0_0010:    begin aes_data [23:16] <= ram_data;   ld <= 0;  state <=  5'b0_0011;  end
                 5'b0_0011:    begin aes_data [31:24] <= ram_data;   ld <= 0;  state <=  5'b0_0100;  end
                                                              
                 5'b0_0100:    begin aes_data [39:32] <= ram_data;   ld <= 0;  state <=  5'b0_0101;  end
                 5'b0_0101:    begin aes_data [47:40] <= ram_data;   ld <= 0;  state <=  5'b0_0110;  end
                 5'b0_0110:    begin aes_data [55:48] <= ram_data;   ld <= 0;  state <=  5'b0_0111;  end
                 5'b0_0111:    begin aes_data [63:56] <= ram_data;   ld <= 0;  state <=  5'b0_1000;  end
                                                                  
                 5'b0_1000:    begin aes_data [71:64] <= ram_data;   ld <= 0;  state <=  5'b0_1001;  end
                 5'b0_1001:    begin aes_data [79:72] <= ram_data;   ld <= 0;  state <=  5'b0_1010;  end
                 5'b0_1010:    begin aes_data [87:80] <= ram_data;   ld <= 0;  state <=  5'b0_1011;  end
                 5'b0_1011:    begin aes_data [95:88] <= ram_data;   ld <= 0;  state <=  5'b0_1100;  end
                                                                  
                 5'b0_1100:    begin aes_data [103:96] <= ram_data;  ld <= 0;  state <=  5'b0_1101;  end
                 5'b0_1101:    begin aes_data [111:104] <= ram_data; ld <= 0;  state <=  5'b0_1110;  end
                 5'b0_1110:    begin aes_data [119:112] <= ram_data; ld <= 0;  state <=  5'b0_1111;  end
                 5'b0_1111:    begin aes_data [127:120] <= ram_data; ld <= 1;  state <=  5'b0_0000;  end
        
                default: begin aes_data <= aes_data; ld <= 0; state <=  5'b0_0000; end
            endcase
            end
        else
            begin
                aes_data <= aes_data;
                ld <= 0;
                state <=  5'b0_0000;
            end
    end
    

endmodule
