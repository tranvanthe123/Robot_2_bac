% Neural 1
L1 = length(tau1);
X1 = [e1(2:L1)'; de1(2:L1)'; tau1(1:L1-1)'];      % vecto dau vao
D1 = [tau1(2:L1)'];                               % vecto dau ra
N  = 20;                                        % so lop an
mynet1 = newff(X1,D1,N,{'tansig' 'purelin'});   % hàm tong hop va ham tac dong
mynet1.trainparam.epochs=1000;                  % so luot chay
mynet1.trainparam.lr=0.0001;                    % he so hoc
mynet1 = train(mynet1,X1,D1);                   % dao tao và hinh thanh mang Neural
gensim(mynet1);

%Neural 2
L2 = length(tau2);
X2 = [e2(2:L2)'; de2(2:L2)'; tau2(1:L2-1)'];
D2 = [tau2(2:L2)'];
N  = 20;
mynet2 = newff(X2,D2,N,{'tansig' 'purelin'});
mynet2.trainparam.epochs=1000;
mynet2.trainparam.lr=0.0001;
mynet2 = train(mynet2,X2,D2);
gensim(mynet2);