clc;
clear all
rand('state',sum(100*clock));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_generation=50; %% có 200 lan chay trong quá trình
max_stall_generation=50; %% 50 the he giong nhau thì dung
epsilon=0.0001; %% J chuan ( neu the he nào có J<=epsilon tuc là tìm dc thông so thoa man, thì dung)
pop_size=30; %%so cá the trong quan the, moi cá the có moi bo PID riêng biet
npar = 6; %% có 3 nhiem sac the trong 1 cá the
range=[ 0 0 0 0 0 0;...
1000 1000 1000 1000 1000 1000]; %% giá tri Ki kp kd nam trong khoang 0,1
dec=[3 3 3 3 3 3]; %% so có 3 chu so thap phân
sig=[5 5 5 5 5 5]; %% 5 chu so có nghia, có nghia là 0.00 den 0.99
cross_prob = 0.7; %% muc do cá the con giong ca the me
mutate_prob = 0.3; %% he so dot bien, he so càng lon thì cá the con càng ít giong cá the me
elitism = 1; %% luon giu lai giá tri tot nhat trong khi lai tao
rho=0.02; %% trong so quyet dinh cái nào quan trong vs J hon
par=Init(pop_size,npar,range); %%khai tao 20 ca the cha me dau tien
Terminal=0; %khoi dong
generation = 0; %%các giá tri
stall_generation=0; %dau tien truoc khi chay GA
for pop_index=1:pop_size,
Kp1=par(pop_index,1);
Ki1=par(pop_index,2);
Kd1=par(pop_index,3);
Kp2=par(pop_index,4);
Ki2=par(pop_index,5);
Kd2=par(pop_index,6);
sim('RobotArm'); %%bat dau mo phong
J=(e1'*e1)+(e2'*e2)+rho*(tau1'*tau1)+rho*(tau2'*tau2);
fitness(pop_index)=1/(J+eps);
end;
[bestfit0,bestchrom]=max(fitness);
Kp10=par(bestchrom,1); %cac ca the
Ki10=par(bestchrom,2); %cha me
Kd10=par(bestchrom,3); %dau tien
Kp20=par(bestchrom,4); %cac ca the
Ki20=par(bestchrom,5); %cha me
Kd20=par(bestchrom,6); %dau tien
J0=1/bestfit0-0.001;%do elitism= nen doi hoi phai co 1 cha me tot nhat de so sanh
while ~Terminal,%terminal se bang 1 neu chay du 200 the he hoac trong qua trinh chay co 1 the he con cai best
generation = generation+1;%truoc moi lan chay cho hien thi
disp(['generation #' num2str(generation) ' of maximum ' num2str(max_generation)]);
filename = 'PIDfirst.mat';
save(filename)
pop=Encode_Decimal_Unsigned(par,sig,dec); %ma hoa thap phan(NST cua cac cha me)
parent=Select_Linear_Ranking(pop,fitness,0.2,elitism,bestchrom); %sap hang cha me tuyen tinh(cha me tot nhat)
child=Cross_Twopoint(parent,cross_prob,elitism,bestchrom);%con cai sinh ra se dc lai ghep
pop=Mutate_Uniform(child,mutate_prob,elitism,bestchrom);%dot bien theo dang phan bo deu
par=Decode_Decimal_Unsigned(pop,sig,dec);%giai ma ket qua ve lai dang nst
for pop_index=1:pop_size,%lan luot test tung ca the trong quan the
Kp1=par(pop_index,1); %quy doi gia tri nhiem
Ki1=par(pop_index,2);%sac the ve cac gia tri
Kd1=par(pop_index,3);%Kp1,Ki1,Kd1
Kp2=par(pop_index,1); %quy doi gia tri nhiem
Ki2=par(pop_index,2);%sac the ve cac gia tri
Kd2=par(pop_index,3);%Kp1,Ki1,Kd1
sim('RobotArm');%tien hanh chay mo phong de kiem tra
J=(e1'*e1)+rho*(tau1'*tau1)+(e2'*e2)+rho*(tau2'*tau2);
fitness(pop_index)=1/(J+eps);
end;
[bestfit(generation),bestchrom]=max(fitness);%ca the nao co kp1,ki1,kd1,kp2,ki2, kd2 se dc chon la ca the toi uu
if generation == max_generation %neu chay du 200 the he roi ma chua co ca the toi uu
Terminal = 1; %thi cho terminal=1,stop GA
elseif generation>1,
if abs(bestfit(generation)-bestfit(generation-1))<epsilon,
stall_generation=stall_generation+1;
if stall_generation == max_stall_generation, Terminal = 1;end %con trong qtr chay ma xuat hien ca the toi uu thi dung
else
stall_generation=0;
end;
end;
end; %While
plot(1./bestfit)
Kp10
Ki10
Kd10
Kp20
Ki20
Kd20
J0
Kp1=par(bestchrom,1) %hien thi
Ki1=par(bestchrom,2) %cac nst
Kd1=par(bestchrom,3)%kp1,ki1,kd1,kp2,ki2,kd2
Kp2=par(bestchrom,4) %hien thi
Ki2=par(bestchrom,5) %cac nst
Kd2=par(bestchrom,6)%kp1,ki1,kd1,kp2,ki2,kd2
J=1/bestfit(end) %ham tieu chuan tuong ung ca the con tot nhat do
sim('RobotArm');%tien hanh mo phong lai de kiem tra ca the con tot nhat do cho dap ung he thong nhu the nao
filename = 'PIDfirst.mat';
save(filename)