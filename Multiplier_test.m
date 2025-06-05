close all
clear
clc

%% Generics & Constants
A_Width = 27;
B_Width = 18;
C_Width = 48;

output_width = 48;
batchNum = 30;

%% Input Generation

A = randi([-2^(A_Width - 1), 2^(A_Width - 1) - 1], 1, batchNum, 1);
B = randi([-2^(B_Width - 1), 2^(B_Width - 1) - 1], 1, batchNum, 1);
C = randi([-2^(C_Width - 1), 2^(C_Width - 1) - 1], 1, batchNum, 1);
C_2comp = zeros(1,length(C));

for i=1:length(C)
    if C(i) < 0 
        C_2comp(i) = C(i) + 2 ^ 48;
    else
        C_2comp(i) = C(i);
    end
end

inputFile = fopen('input_data.txt', 'w');
for i=1:50
    fprintf(inputFile, '0\t0\t0\t%s\n', dec2bin(0, C_Width));
end

for i=1:batchNum
    for j=1:randi([5 10])
        fprintf(inputFile, '0\t0\t0\t%s\n', dec2bin(0, C_Width));
    end
    fprintf(inputFile, '1\t%d\t%d', [A(i), B(i)]);
    fprintf(inputFile, '\t%s\n', dec2bin(C_2comp(i),C_Width));
end

for i=1:50
    fprintf(inputFile, '0\t0\t0\t%s\n', dec2bin(0, C_Width));
end

fclose(inputFile);

%% Matlab Ouput

dataOutMatlab = A.*B + C;

%% Simulation

appendText = [' -GA_Width=' num2str(A_Width) ' -GB_Width=' num2str(B_Width) ' -GC_Width=' num2str(C_Width) ' -Goutput_width=' num2str(output_width) ];
fid = fopen('../tcl/Multiplier.tcl', 'r');

lines = {};
while ~feof(fid)
    line = fgetl(fid);
    if contains(line, 'vsim') 
        line = [line, appendText]; 
    end
    lines{end+1} = line; 
end
fclose(fid);

fid = fopen('run.tcl', 'w');
fprintf(fid, '%s\n', lines{:});
fclose(fid);

!start vsim -do run.tcl

pause(25);

%% Output Validation

outputFile = fopen('output_data.txt', 'r');
dataOutVhdl = [];

while ~feof(outputFile)
    binaryLine = fgetl(outputFile);
    data = bin2dec(binaryLine);
    if binaryLine(1) == '1'
        data = data - 2^48;
    end
    dataOutVhdl = [dataOutVhdl, data];
end

fclose(outputFile);

error = dataOutVhdl ~= dataOutMatlab();

plot(error)
title('Error')
grid on;

if sum(error) == 0
    disp("No Error Occurred")
else
    disp("Error Occurred")
end