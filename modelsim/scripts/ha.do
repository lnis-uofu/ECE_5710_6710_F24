#stops current running simulation
quit -sim
rm -rf ./PROJECTS/ha
mkdir ./PROJECTS/ha
project new ./PROJECTS/ha ha
project addfile ../../RTL/ha.v
project addfile ../../RTL/ha_tb.v
project compileall
#Starts simulation
vsim -t ns work.ha work.ha_tb -voptargs=+acc
add wave -color yellow /ha_tb/a /ha_tb/b
add wave -color cyan /ha_tb/sum /ha_tb/carry
run 100ns