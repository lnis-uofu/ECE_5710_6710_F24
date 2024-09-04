


module soc_top (
    
	input clk,

	output ser_tx,
	input ser_rx,

	output led1,
	output led2,
	output led3,
	output led4,
	output led5,

	output ledr_n,
	output ledg_n,

	output flash_csb,
	output flash_clk,
	inout  flash_io0,
	inout  flash_io1,
	inout  flash_io2,
	inout  flash_io3
);


    pad_in clk_pad    (.pad(clk),    .DataIn(clk_PAD));

    pad_out ser_tx_pad (.pad(ser_tx), .DataOut(ser_tx_PAD));
    pad_in  ser_rx_pad (.pad(ser_rx), .DataIn(ser_rx_PAD));

    pad_out led1_pad  (.pad(led1),  .DataOut(led1_PAD));
    pad_out led2_pad  (.pad(led2),  .DataOut(led2_PAD));
    pad_out led3_pad  (.pad(led3),  .DataOut(led3_PAD));
    pad_out led4_pad  (.pad(led4),  .DataOut(led4_PAD));
    pad_out led5_pad  (.pad(led5),  .DataOut(led5_PAD));


    pad_out ledr_n_pad (.pad(ledr_n),  .DataOut(ledr_n_PAD));
    pad_out ledg_n_pad (.pad(ledg_n),  .DataOut(ledg_n_PAD));

    pad_out flash_csb_pad (.pad(flash_csb),  .DataOut(flash_csb_PAD));
    pad_out flash_clk_pad (.pad(flash_clk),  .DataOut(flash_clk_PAD));



    
    
   icebreaker soc (
   .clk(clk_PAD),
   .ser_tx(ser_tx_PAD),
   .ser_rx(ser_rx_PAD),
   .led1(led1_PAD),
   .led2(led2_PAD),
   .led3(led3_PAD),
   .led4(led4_PAD),
   .led5(led5_PAD),
   .ledr_n(ledr_n_PAD),
   .ledg_n(ledg_n_PAD),
   .flash_csb(flash_csb_PAD),
   .flash_clk(flash_clk_PAD),
   .flash_io0(flash_io0),
   .flash_io1(flash_io1),
   .flash_io2(flash_io2),
   .flash_io3(flash_io3)
   ); 


    
endmodule
