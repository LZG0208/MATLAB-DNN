function [p, s] = Identify(file)
% �Ը�����ͼ���ļ�����ʶ��.����Ϊ�׵׺���.
% ����ʶ����p����÷�s.
% Ԭ���飬2019-7

m = double(rgb2gray(imread(file)));
m = imresize(255-m, [28, 28], 'bicubic');
v = max(max(m));

if v == 0
    p = -1; s = 0;
else
    DNN = LoadNN();
    q = length(DNN)-2;
    if q > 0
        m = m / v;
        X = reshape(m, 28*28, 1);
        for i = 1:q
            X = reLU(DNN{i} * [1; X]);
        end
        [s, p] = max(X);
        p = p - 1;
        imshow(m);
        xlabel(num2str(p));
        ylabel(num2str(s));
    else
        p = -1; s = 0;
    end
end

end
