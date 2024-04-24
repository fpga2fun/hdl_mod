@echo off
echo "生成filelist"
dir .\*.v /b /s >filelist.f
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
			echo "开始编译，请等待"
			iverilog -o wave.vvp  -f filelist.f
			echo "编译完成"
			echo "生成lxt波形文件"
			vvp -n wave.vvp -lxt2
			copy wave.vcd wave.lxt
			echo "打开lxt波形文件"
			gtkwave wave.lxt
			)
	)
pause