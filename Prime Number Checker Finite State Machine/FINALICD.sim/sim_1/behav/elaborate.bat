@echo off
set xv_path=C:\\Xilinx\\Vivado\\2017.2\\bin
call %xv_path%/xelab  -wto 2f2ba17ca83246c9838fc0a70e07b15b -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot PNC_TB_behav xil_defaultlib.PNC_TB -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
