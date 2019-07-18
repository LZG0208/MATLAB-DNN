% trainMNIST:
% ����㣺��д����28*28����Ԫ
% ���ز㣺n1,n2,...,ni
% ����㣺10����Ԫ�����������ͼƬ�������ĸ�����
% ���磺Out = Sigmoid(...Sigmoid(A2 * Sigmoid(A1*In)))
% Ԭ���飬2019-7
% MATLAB version >= MATLAB 7.0.0.19920 (R14)

clear;clc;
%% MNIST���ݶ�ȡ�뱣��.
train_file = 'data/train-images.idx3-ubyte';
label_file = 'data/train-labels.idx1-ubyte';
[Train, Label] = loadMNIST(train_file, label_file);
if isempty(Train) || isempty(Label)
    return
end
test_file = 'test/t10k-images.idx3-ubyte';
test_label = 'test/t10k-labels.idx1-ubyte';
[Test, Tag] = loadMNIST(test_file, test_label, true);
if isempty(Test) || isempty(Tag)
    return
end

%% ������Ԫ����
sx = size(Train, 1);    %�������Ԫ����
n = [28,28,28];         %���ز���Ԫ����
sy = size(Label, 1);    %�������Ԫ����
q = length(n) + 1;      %Ȩ�ؾ���ĸ���

%% ��ʼֵ
alpha = 1e-2; % ��ʼѧϰ��
iter = 1000; % ��������������
DNN = TrainRecovery([sx, n, sy]);% �ָ�ѵ��
start = size(DNN{end}, 2); % ��һ�ε�������
fprintf('�ӵ�[%g]����ʼ����.\n', start);
p = alpha * 0.99^start;
lr = p * 0.99.^(0:iter); % ѧϰ�����������˥��

%profile on;
%profile clear;
%% ��ʼ����
num = size(Train, 2);
% ��һ�д�����ڶ������д��׼ȷ��
errs = zeros(3, iter);
for i = 1:iter
    tic;
    alpha = lr(i);
    % �����
    total = zeros(sy, num);
    for k = 1 : num % ����Ԫ��
        % ǰ�򴫲�
        X = cell(1, q+1);
        X{1} = Train(:, k); % input
        for p = 1:q
            X{p+1} = reLU(DNN{p} * [1; X{p}]);
        end
        err = X{q+1} - Label(:, k); % error
        total(:, k) = err;

        Store = DNN;
        % BP-���򴫲�
        for p = 1:q
            err = (DNN{end-p}(:, 2:end)' * err) .* Grad(X{q+2-p});
            Store{end-1-p} = DNN{end-1-p} - alpha * err * [1; X{q+1-p}]';
        end
        DNN = Store;
    end
    e = mean(sqrt(sum(total.*total)));
    s = Accuracy(DNN, Train, Label);
    t = Accuracy(DNN, Test, Tag);
    errs(1, i) = e; errs(2, i) = s; errs(3, i) = t;
    % ����Ȩ��
    if t >= 0
        Loss = SaveResult(DNN, DNN{end}, errs, i, 10);
    end
    fprintf('%g err=%g lr=%g acc=%g %g use %gs\n',i+start,e,alpha,s,t,toc);
end
%profile viewer;
