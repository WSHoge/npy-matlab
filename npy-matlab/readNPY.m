

function data = readNPY(filename)
% Function to read NPY files into matlab.
% *** Only reads a subset of all possible NPY files, specifically N-D arrays of certain data types.
% See https://github.com/kwikteam/npy-matlab/blob/master/tests/npy.ipynb for
% more.
%

hdr = readNPYheader(filename);

if hdr.littleEndian
    fid = fopen(filename, 'r', 'l');
else
    fid = fopen(filename, 'r', 'b');
end

try

    [~] = fread(fid, hdr.totalHeaderLength, 'uint8');

    % read the data
    data = fread(fid, prod(hdr.arrayShape)*(2^hdr.isComplex), [hdr.dataType '=>' hdr.dataType]);
    if (hdr.isComplex)
        data = data(1:2:end) + j*data(2:2:end);
    end
    
    if length(hdr.arrayShape)>1 && ~hdr.fortranOrder
        data = reshape(data, hdr.arrayShape(end:-1:1));
        data = permute(data, [length(hdr.arrayShape):-1:1]);
    elseif length(hdr.arrayShape)>1
        data = reshape(data, hdr.arrayShape);
    end

    fclose(fid);

catch me
    fclose(fid);
    rethrow(me);
end
