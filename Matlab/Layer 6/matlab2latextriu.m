% Function taking data from a MATLAB array and printing a LaTeX code
function matlab2latextriu(A, filename, check)
    fileID = fopen(filename, 'w');
    fprintf(fileID, '%15s\n', '\begin{bmatrix}');
    for i = 1 : size(A,1)
        nz = i - 1;
        if nz > 0
            for k = 1 : nz
                fprintf(fileID, ' & ');
            end
        end
        for j = nz+1 : size(A,2)-1
            val = A(i,j);
            if floor(val) - val == 0
                formatSpec = '%1d & ';
            else
                formatSpec = '%5.3f & ';
            end
            fprintf(fileID, formatSpec, val);
        end
        val = A(i,end);
        if floor(val) - val == 0
            formatSpec = '%1d \\\\';
        else
            formatSpec = '%5.3f \\\\';
        end
        fprintf(fileID, formatSpec, A(i,end));
        fprintf(fileID, '\n');
    end
    fprintf(fileID, '%13s\n', '\end{bmatrix}');
    if check
        type(filename)
    end
end