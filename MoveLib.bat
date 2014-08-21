;*.dcu nach Lib\
for %%i in (*.dcu) do (move %%i Lib)
for %%i in (DbTreeView\*.dcu) do (move %%i Lib)
for %%i in (ean45full\Source\*.dcu) do (move %%i Lib)
for %%i in (C3DCNVS\*.dcu) do (move %%i Lib)
pause
