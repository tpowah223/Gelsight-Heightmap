function [shortA] = shortArray(array,degree)
%SURF2STL   Write STL file from surface data.
%   SURF2STL('filename',X,Y,Z) writes a stereolithography (STL) file
%   for a surface with geometry defined by three matrix arguments, X, Y
%   and Z.  X, Y and Z must be two-dimensional arrays with the same size.
%


array1 = size(array,1);
array2 = size(array,2);

shortA = zeros( int16(array1/degree), int16(array2/degree));
ii =1;
jj =1;

for i=1:degree:(array1-degree)
    for j=1:degree:(array2-degree)
        
        B = array(i:i+degree-1, j:j+degree-1);
        if ( mean(B, "all") > 0)
            shortA(ii,jj) = mean(B, "all")/degree*10;
        else
               shortA(ii,jj) = 0;
        end

        jj=jj+1;
        
    end
    ii=ii+1;
    jj=1;
end
