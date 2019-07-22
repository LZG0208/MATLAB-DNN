function DNN = TrainDNN(Train, Label, Test, Tag, hidden, alpha)
% �ڸ��������ݼ���ѵ��������.
% Train: �������ݼ���ÿһ�д���һ��input.
% Label: ���ݼ������ǩ��ÿһ�д���һ��output.
% Test: �������Լ���ÿһ�д���һ��input.
% Tag: ���Լ������ǩ��ÿһ�д���һ��output.
% hidden: vector���м������Ԫ����.
% alpha: ��ʼѧϰ��.
% DNN: cell���飬���δ��A1, A2, A3, ...�� E, Loss.
% Ԭ���飬2019-7

%% ������Ԫ����
sx = size(Train, 1);    %�������Ԫ����
n = hidden;             %���ز���Ԫ����
sy = size(Label, 1);    %�������Ԫ����
q = length(n) + 1;      %Ȩ�ؾ���ĸ���

%% ��ʼֵ
if nargin < 4
    alpha = 1e-2; % ��ʼѧϰ��
end
iter = 1000; % ��������������
[DNN, state] = TrainRecovery([sx, n, sy]);% �ָ�ѵ��
start = size(DNN{end}, 2); % ��һ�ε�������
if state
    fprintf('DNN:����[%g]��,����%g.\n', start, DNN{end}(3, end));
    return
end
fprintf('�ӵ�[%g]����ʼ����.\n', start);
p = alpha * 0.99^start;
lr = p * 0.99.^(0:iter); % ѧϰ�����������˥��

%profile on;
%profile clear;
%% ��ʼ����
num = size(Train, 2);
% ��һ�д�����ڶ������д��׼ȷ��
errs = zeros(3, iter);
count = 0; EarlyStopping = 3; %DNN��ͣ����
queue = cell(EarlyStopping+1, 1); %����������DNN����
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
    queue = circshift(queue, 1);
    queue{1} = DNN;
    e = mean(sqrt(sum(total.*total)));
    s = Accuracy(DNN, Train, Label);
    t = Accuracy(DNN, Test, Tag);
    best = max(errs(3, 1:i)); % ǰi-1����õĽ��
    errs(1, i) = e; errs(2, i) = s; errs(3, i) = t;
    if t <= best
        count = count + 1;
        if count == EarlyStopping
            DNN = queue{end};
            Loss = SaveResult(DNN, DNN{end}, errs, i-EarlyStopping, 1);
            return
        end
    else
        count = 0;
    end
    % ����Ȩ��
    if t >= 0
        Loss = SaveResult(DNN, DNN{end}, errs, i, 10);
    end
    fprintf('%g err=%g lr=%g acc=%g %g use %gs\n',i+start,e,alpha,s,t,toc);
end
%profile viewer;
