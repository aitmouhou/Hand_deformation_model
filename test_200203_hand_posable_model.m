clc; clear all;
addpath functions;
addpath(genpath('external'));
load('sg_mesh.mat');
load('weights_1.mat');
load('weights_2.mat');
centers = sg_mesh.centers; v_segment = sg_mesh.assignment; 
V = sg_mesh.vertices; F = sg_mesh.faces;
S = sg_mesh.bonestructure;

%% visualization
B = V;
A = centers;
figure()
hold on
axis equal
scatter3(B(:,1),B(:,2),B(:,3),'.', 'MarkerEdgeColor',[180/255, 180/255, 180/255])
plot3(A(:,1),A(:,2),A(:,3),'b*')
% plot3(A(1:4,1), A(1:4,2), A(1:4,3),'k-')
% plot3(A(5:8,1), A(5:8,2), A(5:8,3),'k-')
% plot3(A(9:12,1), A(9:12,2), A(9:12,3),'k-')
% plot3(A(13:16,1), A(13:16,2), A(13:16,3),'k-')
plot3(A(17:20,1), A(17:20,2), A(17:20,3),'k-')
% plot3(A([4 22],1),A([4 22],2),A([4 22],3),'b-')
% plot3(A([8 22],1),A([8 22],2),A([8 22],3),'b-')
% plot3(A([12 22],1),A([12 22],2),A([12 22],3),'b-')
% plot3(A([16 22],1),A([16 22],2),A([16 22],3),'b-')
plot3(A([20 22],1),A([20 22],2),A([20 22],3),'b-')
plot3(A([22 27],1),A([22 27],2),A([22 27],3),'k-')
hold off

%%

transforms = cell(1, 4);
for i = 1:8
    transforms{i} = eye(4);
end

%% Axes defining
axes = bone_axes(mesh.spheres);






%%

axes_t = axes;
for i = 1:8
    axes_t{1,i}(1:3,1:3) = axes_t{1,i}(1:3,1:3)+axes_t{1,i}(1:3,4);
end     

% variables of axis end-point & center-point 
axes_x_pt = zeros(8,3); 
axes_y_pt = zeros(8,3); 
axes_z_pt = zeros(8,3); 
axes_center_pt = zeros(8,3);

for i = 1:8
    axes_x_pt(i,:) = axes_t{1,i}(1:3)';
end

for i = 1:8
    axes_y_pt(i,:) = axes_t{1,i}(5:7)';
end

for i = 1:8
    axes_z_pt(i,:) = axes_t{1,i}(9:11)';
end

for i = 1:8
    axes_center_pt(i,:) = axes_t{1,i}(13:15)';
end  




