

function writeNPY(var, filename)
% function writeNPY(var, filename)
%
% Only writes little endian, fortran (column-major) ordering; only writes
% with NPY version number 1.0.
%
% Always outputs a shape according to matlab's convention, e.g. (10, 1)
% rather than (10,).


shape = size(var);
dataType = class(var);
isComplex = ~isreal(var);

header = constructNPYheader(dataType, shape, isComplex);

fid = fopen(filename, 'w');
fwrite(fid, header, 'uint8');
if isComplex
    fwrite(fid,[ real(var(:))'; imag(var(:))' ], dataType );
else
    fwrite(fid, var, dataType);
end;
fclose(fid);


end

