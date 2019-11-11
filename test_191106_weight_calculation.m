clc
clear all;

addpath functions;
[V, F, FB, H] = function_loading_ply_file('hand_meshmodel_190730.ply');
load('centers.mat');

A = V;
figure(1) % point cloud 3D plotting
hold on
axis equal
scatter3(A(:,1),A(:,2),A(:,3),'.', 'MarkerEdgeColor',[217/255, 217/255, 217/255])
B = centers;
scatter3(B(:,1),B(:,2),B(:,3),'.', 'MarkerEdgeColor',[0, 0, 0])
hold off

jna = centers(2,:);
jnb = centers(1,:);
vt = [-69.7 -22.5 60.9];
vt_jna = vt - jna
jnb_jna = jnb - jna
delta = dot(vt_jna,jnb_jna)/ (norm(jnb-jna))^2

nv   % neighboring vertex info in the FACE column

T == nv;
[row, col] = find(T);
x = size(row,1)
F2 = F(row,:);
edges = [F2(:,[1,2]); F2(:,[2,3]); F2(:,[3,1])];

F2 == 12

neighbor = [];
for i = 1 : size(edges, 1)
    if ~any(edges(:, 1) == edges(i, 2) & edges(:, 2) == edges(i, 1))
        neighbor = [neighbor; edges(i, [2, 1])];
    end
end

Tx = F2 ~= 12
Tx = F2(1,:) ~= 12
F2_1 = F2(1,:)
F3_1 = F2_1(Tx)

F3 = zeros(size(F2,1), size(F2,2)-1)

for i = 1:6
Fv = F2(i,:)
Tx = Fv ~= 12
Fv_new = Fv(Tx)
F3(i,:) = Fv_new
end

edges = F3;

neighbor = edges(1,:)
edges(1,:) = []

if neighbor(end) == edges(:,1) 
row = find(neighbor(end) == edges(:,1))
neighbor = [neighbor edges(row,2)];
edges(row,:) = []
end












