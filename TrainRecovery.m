function [DNN, state] = TrainRecovery(n)
%% �ָ�֮ǰ�Ľ�������Ž���ѵ�������߼�������������.
% n:������Ԫ���������а�˳���һ��Ԫ��Ϊ�������Ԫ�ĸ���,
% ���һ��Ԫ��Ϊ�������Ԫ�ĸ���������Ԫ��Ϊ���ز����Ԫ����.
% DNN: cell���飬���δ��A1, A2, A3, ...�� E, Loss.
% Ԭ���飬2019-7

DNN = LoadNN();

if isempty(DNN)
    % ��ͷ��ʼѵ��.
    h = length(n); % �������
    DNN = cell(1, h+1);
    for i = 1:h-1
        % ��һ��Ϊƫ����.
        DNN{i} = rand(n(i+1), n(i) + 1) - 0.5;
    end
    % ������2��Ԫ��Ϊ���к͵�λ������.
    DNN{h} = [zeros(n(h), 1), eye(n(h))];
end

disp('DNN infomation:'); disp(DNN);

for i = 1:length(n)
    fprintf('��[%g]����Ԫ����: %g.\n', i, n(i));
end

%% �����������Ƿ���ѵ�����.
loss = DNN{end}(3, :);
best = max(loss);
count = 0;
state = false;
for i = length(loss)-2:length(loss)
    if 0 <= loss(i) && loss(i) <= best
        count = count + 1;
        if count == 3
            state = true;
        end
    else
        break
    end
end
