#stops current running simulation
quit -sim

# Creates a project
rm -rf ./PROJECTS/xor2_rtl
mkdir ./PROJECTS/xor2_rtl
project new ./PROJECTS/xor2_rtl xor2_rtl


# adds all the Files to the Project
project addfile ../../RTL/xor2.v
project addfile ../../RTL/xor2_tb.v
project compileall
#Starts simulation

# Starts the simulation for the project
vsim -t ns work.xor2 work.xor2_tb -voptargs=+acc

# adds some pretty pretty lights
add wave -color yellow /xor2_tb/a /xor2_tb/b
add wave -color cyan /xor2_tb/out

# Spin time baby
run 100ns