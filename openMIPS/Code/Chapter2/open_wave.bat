@echo off
if exist filelist.f  (
	echo "exist filest.f"
) else (
	echo "����filelist"
	dir .\*.v /b /s >filelist.f
)
if exist "*.gtkw" (
	echo "����gtkw�����ļ�"
	echo "��gtkw�����ļ�"
	gtkwave *.gtkw
) else (
	if exist "wave.lxt" (
		echo "����lxt�����ļ�"
		echo "��lxt�����ļ�"
		gtkwave wave.lxt
		) else ( 
			echo "�޲����ļ�"
			echo "��ʼ���룬��ȴ�"
			iverilog -o wave.vvp  -f filelist.f
			echo "�������"
			echo "����lxt�����ļ�"
			vvp -n wave.vvp -lxt2
			copy wave.vcd wave.lxt
			echo "��lxt�����ļ�"
			gtkwave wave.lxt
			)
	)

pause