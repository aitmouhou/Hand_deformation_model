addpath(genpath('external'));
addpath 'functions';

mesh = load('tr_mesh.mat');
mesh = mesh.transformed;

transforms = cell(1, 18);
for i = 1 : 18
    transforms{i} = eye(4);
end
axes = bone_axes(mesh.spheres);

transforms_ad = cell(1,4);
for i = 1 : 4
    transforms_ad{i} = eye(4);
end 

%% angle apply
angle = zeros(19,1);

% Digit 1 flexion(+)/extension(-) 
angle(1) = 0
angle(2) = 0
angle(3) = 0

% Digit 2 flexion(+)/extension(-) 
angle(4) = 0;
angle(5) = 0;
angle(6) = 0;

% Digit 3 flexion(+)/extension(-) 
angle(7) = 0
angle(8) = 0;
angle(9) = 0;

% Digit 4 flexion(+)/extension(-) 
angle(10) = 0;
angle(11) = 0;
angle(12) = 0;

% Digit 5 flexion(+)/extension(-) 
angle(13) = 0; % 
angle(14) = 0; %
angle(15) = 0; %
 
% MCP Abduction/adduction
 angle(16) = 0; %D2
 angle(17) = 0; %D3
 angle(18) = 0; %D4
 angle(19) = 0; %D5


% disp([angle_1 angle_2 angle_3; angle_4 angle_5 angle_6; angle_7 angle_8 angle_9; angle_10 angle_11 angle_12;...
% angle_13 angle_14 angle_15;])

%% MCP abduction/adduction motion
transforms_ad{1} = matrix_rotation( ... % D2 MCP -ab/ad
    angle(16), ... % rotation angle: 0 ~ 2, range 3 = 180 deg. 
    matrix_apply(transforms{2}, axes{6}(1 : 3, 3)', 0), ... axis - 3: abduction/adduction
    matrix_apply(transforms{2}, axes{6}(1 : 3, 4)') ... % center
) * transforms{2};
transforms_ad{2} = matrix_rotation( ...  % D3 MCP - ab/ad
    angle(17), ... % rotation angle: 0 ~ 2, range 3 = 180 deg. 
    matrix_apply(transforms{2}, axes{9}(1 : 3, 3)', 0), ... axis - 3: abduction/adduction
    matrix_apply(transforms{2}, axes{9}(1 : 3, 4)') ... % center
) * transforms{2};
transforms_ad{3} = matrix_rotation( ...  % D4 MCP -ab/ad
    angle(18), ... % rotation angle: 0 ~ 2, range 3 = 180 deg. 
    matrix_apply(transforms{2}, axes{12}(1 : 3, 3)', 0), ... axis - 3: abduction/adduction
    matrix_apply(transforms{2}, axes{12}(1 : 3, 4)') ... % center
) * transforms{2};
transforms_ad{4} = matrix_rotation( ... % D5 MCP - ab/ad
    angle(19), ... % rotation angle: 0 ~ 2, range 3 = 180 deg. 
    matrix_apply(transforms{2}, axes{16}(1 : 3, 3)', 0), ...  axis - 3: abduction/adduction
    matrix_apply(transforms{2}, axes{16}(1 : 3, 4)') ... % center
) * transforms{2};

%% Flexion/extension of fingers 
transforms{3} = matrix_rotation( ... % D1 CMC
    angle(1), ... % rotation angle: 0 ~ 2, range 3 = 180 deg.
    matrix_apply(transforms{2}, axes{3}(1 : 3, 1)', 0), ... % axis1: red; axis2: green; axis3: blue
    matrix_apply(transforms{2}, axes{3}(1 : 3, 4)') ... % center
) * transforms{2};
transforms{4} = matrix_rotation( ... % D1 MCP
    angle(2), ...
    matrix_apply(transforms{3}, axes{4}(1 : 3, 2)', 0), ... % axis1: red; axis2: green; axis3: blue
    matrix_apply(transforms{3}, axes{4}(1 : 3, 4)') ...
) * transforms{3};
transforms{5} = matrix_rotation( ... % D1 IP
    angle(3), ...
    matrix_apply(transforms{4}, axes{5}(1 : 3, 2)', 0), ... % axis1: red; axis2: green; axis3: blue
    matrix_apply(transforms{4}, axes{5}(1 : 3, 4)') ...
) * transforms{4};

transforms{6} = matrix_rotation( ... % D2 MCP
    angle(4), ... % rotation angle: 0 ~ 2, range 3 = 180 deg. 
    matrix_apply(transforms{2}, axes{6}(1 : 3, 2)', 0), ... % axis - 1: supination, pronation; 2: flexion/extension; 3: abduction/adduction
    matrix_apply(transforms{2}, axes{6}(1 : 3, 4)') ... % center
) * transforms_ad{1} * transforms{2};
transforms{7} = matrix_rotation( ... % D2 PIP
    angle(5), ...
    matrix_apply(transforms{6}, axes{7}(1 : 3, 2)', 0), ...
    matrix_apply(transforms{6}, axes{7}(1 : 3, 4)') ...
) * transforms{6};
transforms{8} = matrix_rotation( ... % D2 DIP
    angle(6), ...
    matrix_apply(transforms{7}, axes{8}(1 : 3, 2)', 0), ...
    matrix_apply(transforms{7}, axes{8}(1 : 3, 4)') ...
) * transforms{7};

transforms{9} = matrix_rotation( ...  % D3 MCP
    angle(7), ... % rotation angle: 0 ~ 2, range 3 = 180 deg. 
    matrix_apply(transforms{2}, axes{9}(1 : 3, 2)', 0), ... % axis - 1: supination, pronation; 2: flexion/extension; 3: abduction/adduction
    matrix_apply(transforms{2}, axes{9}(1 : 3, 4)') ... % center
) * transforms_ad{2} * transforms{2};
transforms{10} = matrix_rotation( ... % D3 PIP
    angle(8), ...
    matrix_apply(transforms{9}, axes{10}(1 : 3, 2)', 0), ...
    matrix_apply(transforms{9}, axes{10}(1 : 3, 4)') ...
) * transforms{9};
transforms{11} = matrix_rotation( ... % D3 DIP
    angle(9), ...
    matrix_apply(transforms{10}, axes{11}(1 : 3, 2)', 0), ...
    matrix_apply(transforms{10}, axes{11}(1 : 3, 4)') ...
) * transforms{10};

transforms{12} = matrix_rotation( ...  % D4 MCP
    angle(10), ... % rotation angle: 0 ~ 2, range 3 = 180 deg. 
    matrix_apply(transforms{2}, axes{12}(1 : 3, 2)', 0), ... % axis - 1: supination, pronation; 2: flexion/extension; 3: abduction/adduction
    matrix_apply(transforms{2}, axes{12}(1 : 3, 4)') ... % center
) * transforms_ad{3}* transforms{2};
transforms{13} = matrix_rotation( ... % D4 PIP
    angle(11), ...
    matrix_apply(transforms{12}, axes{13}(1 : 3, 2)', 0), ...
    matrix_apply(transforms{12}, axes{13}(1 : 3, 4)') ...
) * transforms{12};
transforms{14} = matrix_rotation( ... % D4 DIP
    angle(12), ...
    matrix_apply(transforms{13}, axes{14}(1 : 3, 2)', 0), ...
    matrix_apply(transforms{13}, axes{14}(1 : 3, 4)') ...
) * transforms{13};

transforms{16} = matrix_rotation( ... % D5 MCP
    angle(13), ... % rotation angle: 0 ~ 2, range 3 = 180 deg. 
    matrix_apply(transforms{2}, axes{16}(1 : 3, 2)', 0), ... % axis - 1: supination, pronation; 2: flexion/extension; 3: abduction/adduction
    matrix_apply(transforms{2}, axes{16}(1 : 3, 4)') ... % center
) * transforms_ad{4} * transforms{2};
transforms{17} = matrix_rotation( ...% D5 PIP
    angle(14), ...
    matrix_apply(transforms{16}, axes{17}(1 : 3, 2)', 0), ...
    matrix_apply(transforms{16}, axes{17}(1 : 3, 4)') ...
) * transforms{16};
transforms{18} = matrix_rotation( ... % D5 DIP
    angle(15), ...
    matrix_apply(transforms{17}, axes{18}(1 : 3, 2)', 0), ...
    matrix_apply(transforms{17}, axes{18}(1 : 3, 4)') ...
) * transforms{17};

%% Apply new hand posture by angle & render 3D model   

transformed = mesh;
transformed = skin_linear(transformed, transforms);
% transformed = skin_dualquat(transformed, transforms);

figure(1)
hold on;
axis equal
h = trimesh(transformed.faces, transformed.vertices(:, 1), transformed.vertices(:, 2), transformed.vertices(:, 3), 'EdgeColor', 'none', 'FaceColor', [0.8, 0.8, 0.8], 'FaceAlpha', 0.5);
scatter3(transformed.vertices(:, 1), transformed.vertices(:, 2), transformed.vertices(:, 3), '.' ,'MarkerEdgeColor',[255/255, 0, 0])
lighting gouraud;
view([-90, 0]);
camlight;
view([90, 0]);
camlight;
hold off;