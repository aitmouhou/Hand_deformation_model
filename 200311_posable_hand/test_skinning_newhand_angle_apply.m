clc;
clear all;

addpath(genpath('external'));
addpath 'functions';
% mesh = load('mesh/neutral.mat');
mesh = load('hy_mesh.mat');
mesh = mesh.mesh;
% load('angle.mat');
% angle(16:19,1) = 0;
% angle(17) = -0.1;
angle = zeros(1,19);

transforms = cell(1, 18);
for i = 1 : 18
    transforms{i} = eye(4);
end
axes = bone_axes(mesh.spheres);

transforms_ad = cell(1,4);
for i = 1 : 4
    transforms_ad{i} = eye(4);
end 

% axes_t = axes;
% for i = 1:18;
% axes_t{1,i}(1:3,1:3) = axes_t{1,i}(1:3,1:3)+axes_t{1,i}(1:3,4);
% end     
% 
% % variables of axis end-point & center-point 
% axes_x_pt = zeros(18,3); axes_y_pt = zeros(18,3); axes_z_pt = zeros(18,3); axes_center_pt = zeros(18,3);
%     for i = 1:18
%     axes_x_pt(i,:) = axes_t{1,i}(1:3)';
% end
% for i = 1:18
%     axes_y_pt(i,:) = axes_t{1,i}(5:7)';
% end
% for i = 1:18
%     axes_z_pt(i,:) = axes_t{1,i}(9:11)';
% end
% for i = 1:18
%     axes_center_pt(i,:) = axes_t{1,i}(13:15)';
% end  
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

%% 
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


%% skinning
transformed = mesh;
transformed = skin_linear(transformed, transforms);

%% visualization
figure(2)
hold on
axis equal
axis off
%scatter3(transformed.vertices(:,1), transformed.vertices(:,2), transformed.vertices(:,3), '.', 'MarkerEdgeColor',[25/255, 25/255, 25/255])
h = trimesh(transformed.faces, transformed.vertices(:, 1), transformed.vertices(:, 2), transformed.vertices(:, 3), 'EdgeColor', 'none', 'FaceColor', [0.8, 0.8, 0.8], 'FaceAlpha', 1);
        lighting gouraud;
    view([-90, 0]);
    camlight;
    view([90, 0]);
    camlight;
hold off

%% registration trial
% 
% [targetV, targetF, targetFB, target_Header] = function_loading_ply_file('YG_hand_grip.ply');
% targetV(:,4:6) = [];
% sourceV = transformed.vertices;
% sourceF = transformed.faces;
% 
% iterations = 10;
% flag_prealligndata = 0;
% [registered,targetV,targetF] = nonrigidICP(targetV,sourceV,targetF,sourceF,iterations,flag_prealligndata)





























