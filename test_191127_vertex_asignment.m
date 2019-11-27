% vt = [-73.1647, -21.2086, 43.3912];


vertexIdx = 5051

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

% vertex normal plotting
vt = V(vertexIdx,:);
vni = vni.*10;
vni_p = vt + vni
VTP = [vt; vni_p];

C = V;
figure(1) % point cloud 3D plotting
hold on
axis equal
scatter3(C(:,1),C(:,2),C(:,3),'.', 'MarkerEdgeColor',[217/255, 217/255, 217/255])
plot3(VTP(1:2,1), VTP(1:2,2), VTP(1:2,3), 'r-')
B = centers;
scatter3(A(:,1),A(:,2),A(:,3),'.', 'MarkerEdgeColor',[0, 0, 0])
hold off




Sj = zeros(21,4); Sj(1:21,1) = [1:21]';

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
