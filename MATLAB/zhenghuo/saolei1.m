function search(mf,nf,minenum,h,minefield,flag,jieshu)

if flag==minefield
    mh=msgbox('你好厉害哟！','提示');
end
if minefield(mf,nf)==1
    set(gco,'style','text','string','','backgroundcolor',[0 0 0]);
    load handel;
    sound(y,Fs)
    pause(4);
    mh=msgbox('您输了！请再接再厉！','提示');
    sp=actxserver('SAPI.SpVoice');
    sp.Speak('您输了！请再接再厉！')
    pause(2)
    close all;
    delete(hf);

else   
if minenum(mf,nf)==0
    flag(mf,nf)=1;
    set(h(mf,nf),'string','');
    set(h(mf,nf),'value',1);
    mf1=mf-1;nf1=nf-1;
    mf2=mf-1;nf2=nf;
    mf3=mf-1;nf3=nf+1;
    mf4=mf;  nf4=nf-1;
    mf5=mf;  nf5=nf+1;
    mf6=mf+1;nf6=nf-1;
    mf7=mf+1;nf7=nf;
    mf8=mf+1;nf8=nf+1;

if mf1>0&&nf1>0 && flag(mf1,nf1)==0
    flag(mf1,nf1)=1;
    if minenum(mf1,nf1)==0
        set(h(mf1,nf1),'style','text','string','','backgroundcolor',[0 0 0]);
    else
    set(h(mf1,nf1),'string',num2str(minenum(mf1,nf1)));
    set(h(mf1,nf1), 'foregroundColor',0.1*[1,1,1]);
    set(h(mf1,nf1),'style','text','backgroundcolor',[1 1 1]);
    end
    if minenum(mf1,nf1)==0
        search(mf1,nf1,minenum,h,minefield,flag,jieshu);
       
    end
    set(h(mf1,nf1),'value',1);
end
if mf2>0 && flag(mf2,nf2)==0
    flag(mf2,nf2)=1;
    if minenum(mf2,nf2)==0
        set(h(mf2,nf2),'style','text','string','','backgroundcolor',[0 0 0]);
    else
    set(h(mf2,nf2),'string',num2str(minenum(mf2,nf2)));
    end
    set(h(mf2,nf2), 'foregroundColor',0.1*[1,1,1]);
    set(h(mf2,nf2),'style','text','backgroundcolor',[1 1 1]);
    
    if minenum(mf2,nf2)==0
        search(mf2,nf2,minenum,h,minefield,flag,jieshu);
    end
    set(h(mf2,nf2),'value',1);
end
if mf3>0&&nf3<11 && flag(mf3,nf3)==0
    flag(mf3,nf3)=1;
    if minenum(mf3,nf3)==0
        set(h(mf3,nf3),'style','text','string','','backgroundcolor',[0 0 0]);
    else
    set(h(mf3,nf3),'string',num2str(minenum(mf3,nf3)));
    end
    set(h(mf3,nf3), 'foregroundColor',0.1*[1,1,1]);
    set(h(mf3,nf3),'style','text','backgroundcolor',[1 1 1]);
    
    if minenum(mf3,nf3)==0
        search(mf3,nf3,minenum,h,minefield,flag,jieshu);
    end   
    set(h(mf3,nf3),'value',1);
end
if nf4>0 && flag(mf4,nf4)==0
    flag(mf4,nf4)=1;
    if minenum(mf4,nf4)==0
        set(h(mf4,nf4),'style','text','string','','backgroundcolor',[0 0 0]);
    else
    set(h(mf4,nf4),'string',num2str(minenum(mf4,nf4)));
    end
    set(h(mf4,nf4), 'foregroundColor',0.1*[1,1,1]);
    set(h(mf4,nf4),'style','text','backgroundcolor',[1 1 1]);
    
    if minenum(mf4,nf4)==0
        search(mf4,nf4,minenum,h,minefield,flag,jieshu);
    end    
    set(h(mf4,nf4),'value',1);
end
if nf5<11 && flag(mf5,nf5)==0
    flag(mf5,nf5)=1;
    if minenum(mf5,nf5)==0
        set(h(mf5,nf5),'style','text','string','','backgroundcolor',[0 0 0]);
    else
    set(h(mf5,nf5),'string',num2str(minenum(mf5,nf5)));
    end
    set(h(mf5,nf5), 'foregroundColor',0.1*[1,1,1]);
    set(h(mf5,nf5),'style','text','backgroundcolor',[1 1 1]);
    
    if minenum(mf5,nf5)==0
        search(mf5,nf5,minenum,h,minefield,flag,jieshu);
    end    
    set(h(mf5,nf5),'value',1);
end
if mf6<11&&nf6>0 && flag(mf6,nf6)==0
    flag(mf6,nf6)=1;
    if minenum(mf6,nf6)==0
        set(h(mf6,nf6),'style','text','string','','backgroundcolor',[0 0 0]);
    else
    set(h(mf6,nf6),'string',num2str(minenum(mf6,nf6)));
    end
    set(h(mf6,nf6), 'foregroundColor',0.1*[1,1,1]);
    set(h(mf6,nf6),'style','text','backgroundcolor',[1 1 1]);
    
    if minenum(mf6,nf6)==0
        search(mf6,nf6,minenum,h,minefield,flag,jieshu);
    end   
    set(h(mf6,nf6),'value',1);
end
if mf7<11 && flag(mf7,nf7)==0
    flag(mf7,nf7)=1;
    if minenum(mf7,nf7)==0
        set(h(mf7,nf7),'style','text','string','','backgroundcolor',[0 0 0]);
    else
    set(h(mf7,nf7),'string',num2str(minenum(mf7,nf7))); 
    end
    set(h(mf7,nf7), 'foregroundColor',0.1*[1,1,1]);
    set(h(mf7,nf7),'style','text','backgroundcolor',[1 1 1]);
   
    if minenum(mf7,nf7)==0
        search(mf7,nf7,minenum,h,minefield,flag,jieshu);
    end    
    set(h(mf7,nf7),'value',1);
end
if mf8<11&&nf8<11 && flag(mf8,nf8)==0
    flag(mf8,nf8)=1;
    if minenum(mf8,nf8)==0
        set(h(mf8,nf8),'style','text','string','','backgroundcolor',[0 0 0]);
    else
    set(h(mf8,nf8),'string',num2str(minenum(mf8,nf8)));
    end
    set(h(mf8,nf8), 'foregroundColor',0.1*[1,1,1]);
    set(h(mf8,nf8),'style','text','backgroundcolor',[1 1 1]);
    
    if minenum(mf8,nf8)==0
        search(mf8,nf8,minenum,h,minefield,flag,jieshu);
    end    
    set(h(mf8,nf8),'value',1);
end
    else
    set(h(mf,nf),'string',num2str(minenum(mf,nf)));
end
  set(h(mf,nf), 'foregroundColor',0.1*[1,1,1]);
  set(h(mf,nf),'style','text','backgroundcolor',[1 1 1]);   

end
end

