clc
clear all
addpath(genpath('external'));
addpath(genpath('functions'));
%addpath('F:\[GitHub]\Hand_deformation_model\functions');
%addpath('C:\Users\Hayoung Jung\Documents\[GitHub-Labtop]\Hand_deformation_model\functions');

load('tr_mesh.mat');
V = transformed.vertices; F = transformed.faces; 
v_segment = transformed.assignments; weights = transformed.weights;
COR = zeros(30,3);
for i=1:30
COR(i,:) = transformed.spheres{1,i}.center; 
end 
C = COR;

load('sg_mesh.mat');
V2 = sg_mesh.vertices; F2 = sg_mesh.faces; 
v_segment2 = sg_mesh.assignment; %weights2 = 
COR2 = sg_mesh.centers(30,3);
C2 = COR;

%%
figure()
hold on
axis equal
axis off
scatter3(V(:,1),V(:,2),V(:,3),'.', 'MarkerEdgeColor',[180/255, 180/255, 180/255])
hold off
