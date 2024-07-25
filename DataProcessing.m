
data_add = '.../data.csv';
data = readtable('data_add', 'HeaderLines', 1);
t0 = data.LDC_XMB;
signal = data.LDC_Y;
t = sqrt(t0 / (1024 * 23.31) * (58^2 - 24^2) + 24^2);
% subplot(2,1,1)
plot(t,signal)

threshold1 = 200;
threshold2 = 4000;
signal(signal < threshold1 | signal > threshold2) = 0;
new_signal = signal;
% subplot(2,1,2)
plot(t,new_signal)

count_zeros = 0;
sum = 0;
list_matrix = [1,2,3,4,5,6,7,8];
value_matrix = [0,0,0,0,0,0,0,0];
inverselist_matrix = [1,2,3,4,5,6,7,8];
inversevalue_matrix = [0,0,0,0,0,0,0,0];

for i = length(new_signal):-1:1
    current_value = new_signal(i);
    
    if current_value == 0
        count_zeros = count_zeros + 1;
    else
        if count_zeros > 3000 && current_value >= 200
            sum = sum + 1;
            inverselist_matrix(sum) = i;
            new_signal(i) = 4000;
            if sum >= 8
                break;
            end
        end
        count_zeros = 0;
    end
end


count_zeros = 0;
sum = 0;
for i = 1:length(new_signal)
    current_value = new_signal(i);

    if current_value == 0
        count_zeros = count_zeros + 1;
    else
        if count_zeros > 3000 && current_value >= 200
            sum = sum + 1;
            list_matrix(sum) = i;
            new_signal(i) = 5000;
            if sum == 8
                break;
            end
        end
        count_zeros = 0;
    end
end


% subplot(2,1,2)
plot(t,new_signal)

fprintf('Sum: %d\n', sum);
disp('listVector:');
disp(list_matrix);
disp('valueVector:');
disp(value_matrix);

fprintf('Sum: %d\n', sum);
disp('inverselistVector:');
disp(inverselist_matrix);
disp('inversevalueVector:');
disp(inversevalue_matrix);

group1 = signal(list_matrix(1):inverselist_matrix(8));
group2 = signal(list_matrix(2):inverselist_matrix(7));
group3 = signal(list_matrix(3):inverselist_matrix(6));
group4 = signal(list_matrix(4):inverselist_matrix(5));
group5 = signal(list_matrix(5):inverselist_matrix(4));
group6 = signal(list_matrix(6):inverselist_matrix(3));
group7 = signal(list_matrix(7):inverselist_matrix(2));
group8 = signal(list_matrix(8):inverselist_matrix(1));

zero = zeros(size(t));
zero1 = zero(inverselist_matrix(8)+1:list_matrix(2)-1);
zero2 = zero(inverselist_matrix(7)+1:list_matrix(3)-1);
zero3 = zero(inverselist_matrix(6)+1:list_matrix(4)-1);
zero4 = zero(inverselist_matrix(5)+1:list_matrix(5)-1);
zero5 = zero(inverselist_matrix(4)+1:list_matrix(6)-1);
zero6 = zero(inverselist_matrix(3)+1:list_matrix(7)-1);
zero7 = zero(inverselist_matrix(2)+1:list_matrix(8)-1);
zero8 = zero(inverselist_matrix(1)+1:length(new_signal));


np = 800;
new_group0 = signal(1:list_matrix(1)-1);
[new_group1, ylower1] = envelope(group1,np,'peak');
[new_group2, ylower2] = envelope(group2,np,'peak');
[new_group3, ylower3] = envelope(group3,np,'peak');
[new_group4, ylower4] = envelope(group4,np,'peak');
[new_group5, ylower5] = envelope(group5,np,'peak');
[new_group6, ylower6] = envelope(group6,np,'peak');
[new_group7, ylower7] = envelope(group7,np,'peak');
[new_group8, ylower8] = envelope(group8,np,'peak');

cat_signal = cat(1,new_group0,new_group1,zero1,new_group2,zero2,new_group3, ...
    zero3, new_group4,zero4,new_group5,zero5,new_group6,zero6,new_group7, ...
    zero7,new_group8,zero8);

t_ = t(1:length(new_signal));

%subplot(3,1,2)
plot(t_,cat_signal)
ylim([0 1500])


value = [0 0 0 0 0 0 0 0];

t1 = t(list_matrix(1):inverselist_matrix(8));
t2 = t(list_matrix(2):inverselist_matrix(7));
t3 = t(list_matrix(3):inverselist_matrix(6));
t4 = t(list_matrix(4):inverselist_matrix(5));
t5 = t(list_matrix(5):inverselist_matrix(4));
t6 = t(list_matrix(6):inverselist_matrix(3));
t7 = t(list_matrix(7):inverselist_matrix(2));
t8 = t(list_matrix(8):inverselist_matrix(1));

value(1) = trapz(t1,new_group1);
value(2) = trapz(t2,new_group2);
value(3) = trapz(t3,new_group3);
value(4) = trapz(t4,new_group4);
value(5) = trapz(t5,new_group5);
value(6) = trapz(t6,new_group6);
value(7) = trapz(t7,new_group7);
value(8) = trapz(t8,new_group8);

disp('value:');
disp(value);
