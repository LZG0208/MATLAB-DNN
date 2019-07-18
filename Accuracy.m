function s = Accuracy(DNN, Test, Tag)
%% ����������DNN�ڲ��Լ�Test�ϵ�׼ȷ��.Tag�ǲ��Լ��ı�ǩ.
% DNN: cell���飬���δ��A1, A2, A3, ...�� E, Loss.
% Test:���ݼ�.
% Tag:���ݼ���ǩ.
% s: DNN׼ȷ��.
% Ԭ���飬2019-7

if isempty(Test) || isempty(Tag)
    s = -1;
    return
end

n = length(DNN) - 2;
X = Test;
for i = 1:n
    X = reLU(DNN{i} * [ones(1, size(X, 2)); X]);
end
[a, p] = max(X);
[b, tag] = max(Tag);
s = mean(p == tag);

end
