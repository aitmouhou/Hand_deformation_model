clc
clear all;
addpath functions;
addpath(genpath('external'));
%% Data import (mesh, CoR)
[V, F, FB, H] = function_loading_ply_file('hand_meshmodel_190730.ply');
load('centers.mat');
% 1~4: little, 5~8: ring, 9~12: middle, 13~16: index, 17~20: thumb, 
% 22: wrist center
A = centers;
C = V;

% bone segment generation (Things to do, save bone hierarchy)
load('bone_segment.mat')

%% Visualization of hand
figure(2) % point cloud 3D plotting
hold on
axis equal
plot3(A(:,1),A(:,2),A(:,3),'b*')
plot3(A(1:4,1), A(1:4,2), A(1:4,3),'k-')
plot3(A(5:8,1), A(5:8,2), A(5:8,3),'k-')
plot3(A(9:12,1), A(9:12,2), A(9:12,3),'k-')
plot3(A(13:16,1), A(13:16,2), A(13:16,3),'k-')
plot3(A(17:20,1), A(17:20,2), A(17:20,3),'k-')
plot3(A([4 22],1),A([4 22],2),A([4 22],3),'b-')
plot3(A([8 22],1),A([8 22],2),A([8 22],3),'b-')
plot3(A([12 22],1),A([12 22],2),A([12 22],3),'b-')
plot3(A([16 22],1),A([16 22],2),A([16 22],3),'b-')
plot3(A([20 22],1),A([20 22],2),A([20 22],3),'b-')
plot3(A([22 27],1),A([22 27],2),A([22 27],3),'k-')
scatter3(A(:,1),A(:,2),A(:,3),'.', 'MarkerEdgeColor',[0, 0, 0])
scatter3(C(:,1),C(:,2),C(:,3),'.', 'MarkerEdgeColor',[217/255, 217/255, 217/255])
%scatter3(A([1:20, 22],1),A([1:20, 22],2),A([1:20, 22],3), 'o', 'MarkerEdgeColor',[255/255, 0/255, 0/255])
scatter3(C(746,1),C(746,2),C(746,3), 'o', 'MarkerEdgeColor',[255/255, 0/255, 0/255])
hold off

C = V;
figure(1) % point cloud 3D plotting
hold on
axis equal
scatter3(C(:,1),C(:,2),C(:,3),'.', 'MarkerEdgeColor',[217/255, 217/255, 217/255])
B = centers;
scatter3(A(:,1),A(:,2),A(:,3),'.', 'MarkerEdgeColor',[0, 0, 0])
hold off

%% Test code for vertex vi

jna = centers(3,:);
jnb = centers(2,:);
%vt = [-69.7 -22.5 60.9]; % after the segment 
vt = [-61.20 -20.35 44.06]; % between the segment
%vt = [-47.85 -0.99 -10.44] % before the segment
vt_jna = vt - jna;
jnb_jna = jnb - jna;
delta = dot(vt_jna,jnb_jna)/ (norm(jnb-jna))^2;

% distance of projection vector from vi to segment 
% vt: target vertex 
av = vt-jna; bv = jnb-jna; cv = dot(av,bv)/norm(bv); % vector define
dv1 = sqrt(norm(av)^2 - norm(cv)^2); % distance by trigonometric functions
dv = av - dot(av,bv)/norm(bv)^2 * bv; % distance by vector & norm 
dv2 = norm(dv);

% neighboring vertex info in the FACE column
% vertexIdx = 12;
vertexIdx = 1281;

F2 = F;
LI = F2 == vertexIdx;
[row, col] = find(LI);
F2 = F2(row,:);

for i = 1:size(F2,1)*3
    v(i,1) = F2(i);
end
    
nv = vertexIdx; % target vertex
for i = 1:size(v,1)
    if v(i) ~= nv
       nv = [nv v(i)]; % nv: List of neighbor vertices of target with 1-node
    end
end

% vertex normal calculation (unit vector by sum of the around face normal)

normals = getNormals(V, F);
normals_F = normals(row,:);
normals_F = sum(normals_F);
normals_F = normals_F/norm(normals_F);
vni = normals_F;

% angle(theta) between dv and vertex normal
% dv: projection vector, vni: vertex normal of vi
dv = dv./dv2;

cosTH = dot(dv,vni)/(norm(dv)*norm(vni)); 


%% 


vertexIdx = 1
1:745, 

for vertexIdx = 1:6984;

% vertexIdx = 746

Sj = zeros(21,4); Sj(1:21,1) = [1:21]';

F2 = F;
LI = F2 == vertexIdx;
[row2, col2] = find(LI);
F2 = F2(row2,:);
for i = 1:size(F2,1)*3
    v(i,1) = F2(i);
end   
nv = vertexIdx;
for i = 1:size(v,1)
    if v(i) ~= nv
       nv = [nv v(i)]; % nv: List of neighbor vertices of target with 1-node
    end
end
normals = getNormals(V, F);
normals_F = normals(row2,:);
normals_F = sum(normals_F);
normals_F = normals_F/norm(normals_F);
vni = normals_F; % weighted normal vector of vi

for segment=1:21
vt = V(vertexIdx,:);
jna = A(S(segment,1),:); jnb = A(S(segment,2),:); 
vt_jna = vt - jna;
jnb_jna = jnb - jna;
delta = dot(vt_jna,jnb_jna)/ (norm(jnb-jna))^2;
Sj(segment,2) = delta;

av = vt-jna; 
bv = jnb-jna; 
cv = dot(av,bv)/norm(bv);
dv1 = sqrt(norm(av)^2 - norm(cv)^2);
dv = av - dot(av,bv)/norm(bv)^2 * bv; % projection vector
dv2 = norm(dv);
Sj(segment,3) = dv2;
dv = dv./dv2;
cosTH = dot(dv,vni)/(norm(dv)*norm(vni));
Sj(segment,4) = cosTH;
end

LIX = Sj(:,4)>=0;
Sj_1 = Sj(:,1); Sj_2 = Sj(:,2); Sj_3 = Sj(:,3); Sj_4 = Sj(:,4);
Sj = [Sj_1(LIX) Sj_2(LIX) Sj_3(LIX) Sj_4(LIX)];

LIX = Sj(:,4)<1;
Sj_1 = Sj(:,1); Sj_2 = Sj(:,2); Sj_3 = Sj(:,3); Sj_4 = Sj(:,4);
Sj = [Sj_1(LIX) Sj_2(LIX) Sj_3(LIX) Sj_4(LIX)];

LIX = Sj(:,2)>=0;
Sj_1 = Sj(:,1); Sj_2 = Sj(:,2); Sj_3 = Sj(:,3); Sj_4 = Sj(:,4);
Sj_positive = [Sj_1(LIX) Sj_2(LIX) Sj_3(LIX) Sj_4(LIX)];

if size(Sj_positive,1) == 0
    v_segment(vertexIdx,1) = 22;
else
    v_mindist = min(Sj_positive(:,3));
    [row,col] = find(Sj == v_mindist); % searching min distance
    v_delta = Sj(row,2); % final delta of vi
    v_segment(vertexIdx,1) = row; % final segment of vi
end

end



%% Segment visualization

V2 = V;
% segment = 1;
VLI = [];
for segment=1:22
temLI = v_segment == segment;
VLI = [VLI temLI];
end 

temLI = v_segment == 1; Sg1 = V2(temLI,:);
temLI = v_segment == 2; Sg2 = V2(temLI,:);
temLI = v_segment == 3; Sg3 = V2(temLI,:);
temLI = v_segment == 4; Sg4 = V2(temLI,:);
temLI = v_segment == 5; Sg5 = V2(temLI,:);
temLI = v_segment == 6; Sg6 = V2(temLI,:);
temLI = v_segment == 7; Sg7 = V2(temLI,:);
temLI = v_segment == 8; Sg8 = V2(temLI,:);
temLI = v_segment == 9; Sg9 = V2(temLI,:);
temLI = v_segment == 10; Sg10 = V2(temLI,:);
temLI = v_segment == 11; Sg11 = V2(temLI,:);
temLI = v_segment == 12; Sg12 = V2(temLI,:);
temLI = v_segment == 13; Sg13 = V2(temLI,:);
temLI = v_segment == 14; Sg14 = V2(temLI,:);
temLI = v_segment == 15; Sg15 = V2(temLI,:);
temLI = v_segment == 16; Sg16 = V2(temLI,:);
temLI = v_segment == 17; Sg17 = V2(temLI,:);
temLI = v_segment == 18; Sg18 = V2(temLI,:);
temLI = v_segment == 19; Sg19 = V2(temLI,:);
temLI = v_segment == 20; Sg20 = V2(temLI,:);
temLI = v_segment == 21; Sg21 = V2(temLI,:);
temLI = v_segment == 22; Sg22 = V2(temLI,:);

figure()
hold on
axis equal
scatter3(Sg1(:,1),Sg1(:,2),Sg1(:,3),'.', 'MarkerEdgeColor',[16/255, 241/255, 255/255])
scatter3(Sg2(:,1),Sg2(:,2),Sg2(:,3),'.', 'MarkerEdgeColor',[213/255, 42/255, 219/255])
scatter3(Sg3(:,1),Sg3(:,2),Sg3(:,3),'.', 'MarkerEdgeColor',[233/255, 30/255, 68/255])
scatter3(Sg4(:,1),Sg4(:,2),Sg4(:,3),'.', 'MarkerEdgeColor',[179/255, 59/255, 235/255])
scatter3(Sg5(:,1),Sg5(:,2),Sg5(:,3),'.', 'MarkerEdgeColor',[69/255, 204/255, 104/255])
scatter3(Sg6(:,1),Sg6(:,2),Sg6(:,3),'.', 'MarkerEdgeColor',[191/255, 247/255, 20/255])
scatter3(Sg7(:,1),Sg7(:,2),Sg7(:,3),'.', 'MarkerEdgeColor',[247/255, 170/255, 20/255])
scatter3(Sg8(:,1),Sg8(:,2),Sg8(:,3),'.', 'MarkerEdgeColor',[242/255, 62/255, 27/255])
scatter3(Sg9(:,1),Sg9(:,2),Sg9(:,3),'.', 'MarkerEdgeColor',[191/255, 247/255, 20/255])
scatter3(Sg10(:,1),Sg10(:,2),Sg10(:,3),'.', 'MarkerEdgeColor',[247/255, 170/255, 20/255])
scatter3(Sg11(:,1),Sg11(:,2),Sg11(:,3),'.', 'MarkerEdgeColor',[242/255, 62/255, 27/255])
scatter3(Sg12(:,1),Sg12(:,2),Sg12(:,3),'.', 'MarkerEdgeColor',[191/255, 247/255, 20/255])
scatter3(Sg13(:,1),Sg13(:,2),Sg13(:,3),'.', 'MarkerEdgeColor',[247/255, 170/255, 20/255])
scatter3(Sg14(:,1),Sg14(:,2),Sg14(:,3),'.', 'MarkerEdgeColor',[242/255, 62/255, 27/255])
scatter3(Sg15(:,1),Sg15(:,2),Sg15(:,3),'.', 'MarkerEdgeColor',[191/255, 247/255, 20/255])
scatter3(Sg16(:,1),Sg16(:,2),Sg16(:,3),'.', 'MarkerEdgeColor',[247/255, 170/255, 20/255])
scatter3(Sg17(:,1),Sg17(:,2),Sg17(:,3),'.', 'MarkerEdgeColor',[242/255, 62/255, 27/255])
scatter3(Sg18(:,1),Sg18(:,2),Sg18(:,3),'.', 'MarkerEdgeColor',[191/255, 247/255, 20/255])
scatter3(Sg19(:,1),Sg19(:,2),Sg19(:,3),'.', 'MarkerEdgeColor',[247/255, 170/255, 20/255])
scatter3(Sg20(:,1),Sg20(:,2),Sg20(:,3),'.', 'MarkerEdgeColor',[242/255, 62/255, 27/255])
scatter3(Sg21(:,1),Sg21(:,2),Sg21(:,3),'.', 'MarkerEdgeColor',[0, 0, 0])
hold off











