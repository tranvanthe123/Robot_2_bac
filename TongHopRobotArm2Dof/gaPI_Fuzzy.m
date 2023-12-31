clc;
clear all
rand('state',sum(100*clock));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_generation=50; %% c� 200 lan chay trong qu� tr�nh
max_stall_generation=10; %% 50 the he giong nhau th� dung
epsilon=0.0001; %% J chuan ( neu the he n�o c� J<=epsilon tuc l� t�m dc th�ng so thoa man, th� dung)
pop_size=20; %%so c� the trong quan the, moi c� the c� moi bo PID ri�ng biet
npar = 4; %% c� 3 nhiem sac the trong 1 c� the
range=[ 0 0 0 0;...
        2 300 2 300]; %% gi� tri Ki kp kd nam trong khoang 0,1
dec=[3 3 3 3]; %% so c� 3 chu so thap ph�n
sig=[5 5 5 5]; %% 5 chu so c� nghia, c� nghia l� 0.00 den 0.99
cross_prob = 0.9; %% muc do c� the con giong ca the me
mutate_prob = 0.1; %% he so dot bien, he so c�ng lon th� c� the con c�ng �t giong c� the me
elitism = 1; %% luon giu lai gi� tri tot nhat trong khi lai tao
rho=0.02; %% trong so quyet dinh c�i n�o quan trong vs J hon
par=Init(pop_size,npar,range); %%khai tao 20 ca the cha me dau tien
Terminal=0; %khoi dong
generation = 0; %%c�c gi� tri
stall_generation=0; %dau tien truoc khi chay GA
for pop_index=1:pop_size,
K1=par(pop_index,1)
K2=par(pop_index,2)
K3=par(pop_index,3)
K4=par(pop_index,4)

sim('RobotArm'); %%bat dau mo phong
J=(e1'*e1)+(e2'*e2)+rho*(tau1'*tau1)+rho*(tau2'*tau2);
fitness(pop_index)=1/(J+eps);
end;
[bestfit0,bestchrom]=max(fitness);
K10=par(bestchrom,1); %cac ca the
K20=par(bestchrom,2)+267; %cha me
K30=par(bestchrom,3); %dau tien
K40=par(bestchrom,4)+200; %cac ca the
J0=1/bestfit0-0.001;%do elitism= nen doi hoi phai co 1 cha me tot nhat de so sanh
while ~Terminal,%terminal se bang 1 neu chay du 200 the he hoac trong qua trinh chay co 1 the he con cai best
generation = generation+1;%truoc moi lan chay cho hien thi
disp(['generation #' num2str(generation) ' of maximum ' num2str(max_generation)]);
filename = 'PIFuzzyfourth.mat';
save(filename)
pop=Encode_Decimal_Unsigned(par,sig,dec); %ma hoa thap phan(NST cua cac cha me)
parent=Select_Linear_Ranking(pop,fitness,0.2,elitism,bestchrom); %sap hang cha me tuyen tinh(cha me tot nhat)
child=Cross_Twopoint(parent,cross_prob,elitism,bestchrom);%con cai sinh ra se dc lai ghep
pop=Mutate_Uniform(child,mutate_prob,elitism,bestchrom);%dot bien theo dang phan bo deu
par=Decode_Decimal_Unsigned(pop,sig,dec);%giai ma ket qua ve lai dang nst
for pop_index=1:pop_size,%lan luot test tung ca the trong quan the
K1=par(pop_index,1) %quy doi gia tri nhiem
K2=par(pop_index,2)%sac the ve cac gia tri
K3=par(pop_index,3)%Kp1,Ki1,Kd1
K4=par(pop_index,1) %quy doi gia tri nhiem
sim('RobotArm');%tien hanh chay mo phong de kiem tra
J=(e1'*e1)+(e2'*e2)+rho*(tau1'*tau1)+rho*(tau2'*tau2);
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
K10
K20
K30
K40
J0
K1=par(bestchrom,1) %hien thi
K2=par(bestchrom,2) %cac nst
K3=par(bestchrom,3)%kp1,ki1,kd1,kp2,ki2,kd2
K4=par(bestchrom,4) %hien thi
J=1/bestfit(end) %ham tieu chuan tuong ung ca the con tot nhat do
sim('RobotArm');%tien hanh mo phong lai de kiem tra ca the con tot nhat do cho dap ung he thong nhu the nao
filename = 'PIFuzzyfourth.mat';
save(filename)