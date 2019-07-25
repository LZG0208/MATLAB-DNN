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
if ~exist(train_file)
    fprintf('�뽫"data/train-images-idx3-ubyte.gz"��ѹ.\n');
end
if ~exist(label_file)
    fprintf('�뽫"data/train-labels-idx1-ubyte.gz"��ѹ.\n');
end
[Train, Label] = loadMNIST(train_file, label_file);
if isempty(Train) || isempty(Label)
    return
end
test_file = 'test/t10k-images.idx3-ubyte';
test_label = 'test/t10k-labels.idx1-ubyte';
if ~exist(test_file)
    fprintf('�뽫"test/10k-images-idx3-ubyte.gz"��ѹ.\n');
end
if ~exist(test_label)
    fprintf('�뽫"test/t10k-labels-idx1-ubyte.gz"��ѹ.\n');
end
[Test, Tag] = loadMNIST(test_file, test_label, true);
if isempty(Test) || isempty(Tag)
    return
end
clear train_file label_file test_file test_label;

%% ѵ��������.
DNN = TrainDNN(Train, Label, Test, Tag, [28, 14], 1e-2);
