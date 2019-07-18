function DNN = LoadNN(file)
%% ��ָ��Ŀ¼��������������.
% file: DNN���Ŀ¼.
% ����DNN: cell���飬���δ��A1, A2, A3, ...�� E, Loss.
% Ԭ���飬2019-7

if nargin == 0
    file = 'DNN_s*.mat';
end

dnn = dir(file);
if ~isempty(dnn)
    load(dnn(end).name);
    fprintf('Load DNN [%s] succeed.\n', dnn(end).name);
else
    DNN = cell(0);
    fprintf('Load Deep Neural Networks failed.\n');
end

end
