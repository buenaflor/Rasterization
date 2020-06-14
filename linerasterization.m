%
% Copyright 2017 Vienna University of Technology.
% Institute of Computer Graphics and Algorithms.
%

function linerasterization(mesh, framebuffer)
%LINERASTERIZATION iterates over all faces of mesh and draws lines between
%                  their vertices.
%     mesh                  ... mesh object to rasterize
%     framebuffer           ... framebuffer

for i = 1:numel(mesh.faces)
    for j = 1:mesh.faces(i)
        v1 = mesh.getFace(i).getVertex(j);
        v2 = mesh.getFace(i).getVertex(mod(j, mesh.faces(i))+1);
        drawLine(framebuffer, v1, v2);
    end
end
end

function drawLine(framebuffer, v1, v2)
%DRAWLINE draws a line between v1 and v2 into the framebuffer using the DDA
%         algorithm.
%         ATTENTION: Coordinates of the line have to be rounded with the
%         function 'round(...)'.
%     framebuffer           ... framebuffer
%     v1                    ... vertex 1
%     v2                    ... vertex 2

[x1, y1, depth1] = v1.getScreenCoordinates();
[x2, y2, depth2] = v2.getScreenCoordinates();
dx = x2-x1;
dy = y2-y1;
m = dy / dx;
x = x1;
y = y1;

if (abs(dx) > abs(dy))
    steps = abs(dx);
else
    steps = abs(dy);
end

xStep = dx / steps;
yStep = dy / steps;
totalDistance = sqrt((x1 - x2)^2 + (y1 - y2)^2);
i = 0;
interpolatedDepth = depth1;
interpolatedColor = v1.getColor();

while i <= steps
    
    % Interpolating depth and color if depths or colors are not equal
    if (depth1 ~= depth2 || ~isequal(v1.getColor(), v2.getColor()))
        currentDistance = sqrt((x1 - x)^2 + (y1 - y)^2);
        t = currentDistance / totalDistance;
        interpolatedColor = MeshVertex.mix(v1.getColor(), v2.getColor(), t);
        interpolatedDepth = MeshVertex.mix(depth1, depth2, t);
    end
    
    framebuffer.setPixel(round(x), round(y), interpolatedDepth, interpolatedColor);
    x = x + xStep;
    y = y + yStep;
    i = i + 1;
end

% TODO 1: Implement this function.
% BONUS:  Solve this task without using loops and without using loop
%         emulating functions (e.g. arrayfun).

end
