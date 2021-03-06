//****************************************************************************************************  
//*---------------Copyright (c) 2016 C-L-G.FPGA1988.lichangbeiju. All rights reserved-----------------
//
//                   --              It to be define                --
//                   --                    ...                      --
//                   --                    ...                      --
//                   --                    ...                      --
//**************************************************************************************************** 
//File Information
//**************************************************************************************************** 
//File Name      : spm.v 
//Project Name   : azpr_soc
//Description    : the digital top of the chip.
//Github Address : github.com/C-L-G/azpr_soc/trunk/ic/digital/rtl/cpu/spm.v
//License        : Apache-2.0
//**************************************************************************************************** 
//Version Information
//**************************************************************************************************** 
//Create Date    : 2016-11-22 17:00
//First Author   : lichangbeiju
//Last Modify    : 2016-12-08 14:20
//Last Author    : lichangbeiju
//Version Number : 12 commits 
//**************************************************************************************************** 
//Change History(latest change first)
//yyyy.mm.dd - Author - Your log of change
//**************************************************************************************************** 
//2016.12.08 - lichangbeiju - Change the include.
//2016.11.23 - lichangbeiju - Change the coding style.
//2016.11.22 - lichangbeiju - Add io port.
//**************************************************************************************************** 
//File Include : system header file
`include "../sys_include.h"

//File Include : module header file
`include "spm.h"

module spm (
    //1.clock and reset if
    input  wire                clk              ,//clock
    //2.port a if stage
    input  wire [`SpmAddrBus]  if_spm_addr      ,//address
    input  wire                if_spm_as_n      ,//address strobe
    input  wire                if_spm_rw        ,//read/write
    input  wire [`WordDataBus] if_spm_wr_data   ,//write in data
    output wire [`WordDataBus] if_spm_rd_data   ,//read out data
    //3.port b mem stage
    input  wire [`SpmAddrBus]  mem_spm_addr     ,//address
    input  wire                mem_spm_as_n     ,//address strobe
    input  wire                mem_spm_rw       ,//read/write    
    input  wire [`WordDataBus] mem_spm_wr_data  ,//write in data 
    output wire [`WordDataBus] mem_spm_rd_data  // read out data 
);

    //************************************************************************************************
    // 1.Parameter and constant define
    //************************************************************************************************
    
    
    //************************************************************************************************
    // 2.Register and wire declaration
    //************************************************************************************************
    //------------------------------------------------------------------------------------------------
    // 2.1 the output reg
    //------------------------------------------------------------------------------------------------   

    //------------------------------------------------------------------------------------------------
    // 2.x the test logic
    //------------------------------------------------------------------------------------------------
    reg                        wea  ;//write enable A
    reg                        web  ;//write enable B

    //************************************************************************************************
    // 3.Main code
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 3.1 the generate of write enable
    //------------------------------------------------------------------------------------------------
    always @(*) begin
        /* port A */
        if ((if_spm_as_n == `ENABLE_N) && (if_spm_rw == `WRITE))
            begin   
                wea = `MEM_ENABLE;  //write in valid
            end 
        else
            begin
                wea = `MEM_DISABLE; //write in disable
            end
        /* port B */
        if ((mem_spm_as_n == `ENABLE_N) && (mem_spm_rw == `WRITE))
            begin
                web = `MEM_ENABLE;  //write in valid
            end
        else
            begin
                web = `MEM_DISABLE; //write in disable
            end
    end

    //************************************************************************************************
    // 4.Sub module instantiation
    //************************************************************************************************

    //------------------------------------------------------------------------------------------------
    // 4.1 the clk generate module
    //------------------------------------------------------------------------------------------------    
    /********** Xilinx FPGA Block RAM : two ports RAM **********/
    symmetric_mem_core x_s3e_dpram (
        /********** port A : IF stage **********/
        .clockA         (clk),             //clock 
        .addressA       (if_spm_addr),     //address
        .input_dataA    (if_spm_wr_data),  //
        .write_enableA  (wea),             //
        .output_dataA   (if_spm_rd_data),  //
        /********** port B : MEM Stage **********/
        .clockB         (clk),             //
        .addressB       (mem_spm_addr),    //
        .input_dataB    (mem_spm_wr_data), //
        .write_enableB  (web),             //
        .output_dataB   (mem_spm_rd_data)  //read data
    );
  
endmodule
//****************************************************************************************************
//End of Module
//****************************************************************************************************
