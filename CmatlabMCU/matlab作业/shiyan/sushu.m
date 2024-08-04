function a=sushu(x)
     if x==2
         disp('yes');
     elseif x==1
         disp('既不是质数，也不是合数');
     else
        for i=2:x-1
            if rem(x,i)==0
                disp('no');
                break;
            elseif x-1==i
                disp('yes');
            end
        end
     end
end
