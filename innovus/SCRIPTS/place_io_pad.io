(globals
	version = 3
	io_order = default
)

(iopad

	(topleft
		(inst  name="corner0"	place_status=placed )	# Corner no: 1 (top left)
  	  )

	(topright
		(inst  name="corner1"	place_status=placed )	# Corner no: 2 (top right)
  	  )

	(bottomleft
		(inst  name="corner2"	place_status=placed )	# Corner no: 3 (bottom left)
  	  )

	(bottomright
		(inst  name="corner3"	place_status=placed )	# Corner no: 4 (bottom right)
  	  )

    (left
    (inst name="ser_tx_pad" place_status=fixed)
    (inst name="ser_rx_pad" place_status=fixed)
    (inst name="clk_pad"    place_status=fixed)
    (inst name="vss0"       place_status=fixed)    
    )

    (top
    (inst name="vdd0"       place_status=fixed)
    (inst name="ledr_n_pad" place_status=placed)
    (inst name="ledg_n_pad" place_status=placed)
    (inst name="flash_csb_pad" place_status=fixed)
    (inst name="flash_clk_pad" place_status=fixed)
    )

    (right

    (inst name="flash_io0_pad" place_status=placed)
    (inst name="flash_io1_pad" place_status=placed)
    (inst name="flash_io2_pad" place_status=placed)
    (inst name="flash_io3_pad" place_status=placed)
    )


    (bottom
    (inst name="led1_pad" place_status=fixed)
    (inst name="led2_pad" place_status=placed)
    (inst name="led3_pad" place_status=placed)
    (inst name="led4_pad" place_status=placed)
    (inst name="led5_pad" place_status=placed)
    )


)
