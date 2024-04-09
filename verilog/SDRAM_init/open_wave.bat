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
echo "生成filelist"
dir .\*.v /b /s >filelist.f
dir .\*.sv /b /s >>filelist.f
if exist "*.gtkw" (
echo "存在gtkw波形文件"
echo "打开gtkw波形文件"
gtkwave *.gtkw
) else (
	if exist "wave.lxt" (
		echo "存在lxt波形文件"
		echo "打开lxt波形文件"
		gtkwave wave.lxt
		) else ( 
			echo "无波形文件"
			echo "开始编译"
			iverilog -g2005-sv -o wave.vvp  -f filelist.f
			echo "编译完成"
			echo "生成lxt波形文件"
			vvp -n wave.vvp -lxt2
			copy wave.vcd wave.lxt
			echo "打开lxt波形件"
			gtkwave wave.lxt
			)
	)
pause
