::echo "开始编译"
::cd .\Desktop\test
::iverilog -g2005-sv -o wave padup.v tb.sv
::echo "编译完成"
::echo "生成波形文件"
::vvp -n wave -lxt2
::echo "打开波形文件"
::gtkwave wave.vcd
::pause
@echo off
echo "gen filelist"
dir .\*.v /b /s >filelist.f
dir .\*.sv /b /s >>filelist.f
if exist "*.gtkw" (
echo "exit gtkw"
echo "open gtkw"
gtkwave *.gtkw
) else (
	if exist "wave.lxt" (
		echo "exit lxt"
		echo "open lxt"
		gtkwave wave.lxt
		) else ( 
			echo "no wavefile"
			echo "start compile"
			iverilog -g2005-sv -o wave.vvp  -f filelist.f
			echo "compile success"
			echo "gen lxt"
			vvp -n wave.vvp -lxt2
			copy wave.vcd wave.lxt
			echo "open lxt"
			gtkwave wave.lxt
			)
	)
pause
