quit -sim
.main clear

set PrefMain(saveLines) 100000000000

cd ../sim
cmd /c "if exist work rmdir /S /Q work"
vlib work
vmap work


vcom -2008 ../source/*.vhd
vcom -2008 ../test/Multiplier_tb.vhd

vsim -t 100ps -vopt Multiplier_tb -voptargs=+acc

config wave -signalnamewidth 1

add wave -format Logic -radix decimal sim:/Multiplier_tb/Multiplier_inst/*

run 10us

